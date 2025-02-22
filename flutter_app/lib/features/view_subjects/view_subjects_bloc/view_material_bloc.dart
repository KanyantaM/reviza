import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reviza/app/services/notifications_service.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:study_material_repository/study_material_repository.dart';

part 'view_material_events.dart';
part 'view_material_state.dart';

class ViewMaterialBloc extends Bloc<ViewMaterialEvent, ViewMaterialState> {
  ViewMaterialBloc({required StudyMaterialRepo studyMaterial})
      : _materialRepository = studyMaterial,
        super(ViewMaterialInitial()) {
    on<DownLoadMaterial>(_downloadMaterial);
    on<VoteMaterial>(_voteMaterial);
    on<ReportMaterial>(_reportMaterial);
    on<DeleteMaterials>((event, emit) async {
      for (StudyMaterial path in event.materials) {
        await StudyMaterialRepo(uid: StudentCache.tempStudent.userId)
            .deleteLocalMaterial(material: path);
      }
      emit(ViewMaterialInitial());
    });
  }

  final StudyMaterialRepo _materialRepository;

  /// Handles material voting (upvote/downvote) and updates cache
  Future<void> _voteMaterial(
      VoteMaterial event, Emitter<ViewMaterialState> emit) async {
    try {
      await _materialRepository.upvoteMaterial(
          vote: event.vote, studyMaterial: event.material);

      // Update cache
      final course = event.material.subjectName;
      final updatedMaterials = List<StudyMaterial>.from(
          StudentCache.localStudyMaterial[course] ?? []);
      final index =
          updatedMaterials.indexWhere((mat) => mat.id == event.material.id);
      if (index != -1) {
        event.material.fans.remove(StudentCache.tempStudent.userId);
        event.material.haters.remove(StudentCache.tempStudent.userId);

        if (event.vote == true) {
          event.material.fans.add(StudentCache.tempStudent.userId);
        } else if (event.vote == false) {
          event.material.haters.add(StudentCache.tempStudent.userId);
        }
        updatedMaterials[index] = event.material
            .copyWith(fans: event.material.fans, haters: event.material.haters);
        StudentCache.updateCourseLocalMaterial(
            course: course, materials: updatedMaterials);
      }
      emit(ViewMaterialInitial());
    } on Exception catch (e) {
      emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
    }
  }

  /// Handles reporting a material and updates cache
  Future<void> _reportMaterial(
      ReportMaterial event, Emitter<ViewMaterialState> emit) async {
    try {
      _materialRepository.reportMaterial(studyMaterial: event.material);

      // Update cache: Remove reported material (if necessary)
      final course = event.material.subjectName;
      final updatedMaterials = List<StudyMaterial>.from(
          StudentCache.localStudyMaterial[course] ?? []);
      updatedMaterials.removeWhere((mat) => mat.id == event.material.id);
      StudentCache.updateLocalMaterial({course: updatedMaterials});
      emit(ViewMaterialInitial());
    } on Exception catch (e) {
      emit(ErrorState(message: 'Reporting failed\n ERROR: $e'));
    }
  }

  /// Handles downloading materials and updating cache
  Future<void> _downloadMaterial(
      DownLoadMaterial event, Emitter<ViewMaterialState> emit) async {
    if (await event.course.isOnDevice) {
      emit(ErrorState(message: '${event.course.title} already downloaded'));
      return;
    }

    final StudyMaterial material = event.course;
    StudentCache.currentDownloadTasks
        .add(_downloadSingleFile(material, event, emit));

    await Future.wait(StudentCache.currentDownloadTasks);
    emit(DownloadingCourses());
  }

  /// Handles the actual file download and updates StudentCache
  Future<void> _downloadSingleFile(StudyMaterial material,
      DownLoadMaterial event, Emitter<ViewMaterialState> emit) async {
    if (material.onlinePath == null) {
      emit(
          ErrorState(message: 'Please give ${material.title} a document type'));
      return;
    }

    String pathToSaveDownload =
        await getFilePath(event.course.id, event.course.subjectName);

    if (File(pathToSaveDownload).existsSync()) {
      File(pathToSaveDownload).deleteSync();
    }

    try {
      log(pathToSaveDownload);
      Stream<String> downloadStatus = _materialRepository.downloadMaterial(
        studyMaterial: material,
        pathToDownload: pathToSaveDownload,
      );

      // Show notification that download has started
      final notificationTask =
          NotificationService.showDownloadProgressNotification(
              0, material.title, material.id);
      StudentCache.addNotifications(notificationTask);

      await emit.forEach<String>(
        downloadStatus,
        onError: (error, stackTrace) {
          StudentCache.currentDownload
              .removeWhere((mat) => material.id == mat.id);
          NotificationService.showDownloadErrorNotification(
              material.id, material.title);
          return ErrorState(message: error.toString());
        },
        onData: (status) {
          if (status.contains('%')) {
            final double progress =
                double.tryParse(status.replaceAll('%', '')) ?? 0;
            final updatedMaterial =
                material.copyWith(downloadProgress: progress);
            StudentCache.currentDownload
                .removeWhere((mat) => material.id == mat.id);
            StudentCache.currentDownload.add(updatedMaterial);

            NotificationService.showDownloadProgressNotification(
                progress, material.title, material.id);
          }

          if (status == '✅') {
            NotificationService.showDownloadCompletionNotification(
                material.title, material.id);
            final course = material.subjectName;
            final updatedMaterials = List<StudyMaterial>.from(
                StudentCache.localStudyMaterial[course] ?? []);
            updatedMaterials.add(material.copyWith(
                downloadProgress: 1, localPath: pathToSaveDownload));
            StudentCache.updateLocalMaterial({course: updatedMaterials});

            StudentCache.initCache(uid: StudentCache.tempStudent.userId);
            return DownloadingCourses();
          }
          return DownloadingCourses();
        },
      );
    } catch (e) {
      emit(ErrorState(
        message: 'Download failed for ${material.title}: ${e.toString()}',
      ));
    }
  }

  Future<String> getFilePath(String fileId, String subjectName) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/$subjectName';
    await Directory(path).create(recursive: true); // Ensure directory exists
    return '$path/$fileId';
  }
}
