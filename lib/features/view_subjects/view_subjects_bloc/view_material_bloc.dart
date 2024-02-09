import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_storage_study_material_api/cloud_storage_study_material_api.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_study_material_api/local_storage_study_material_api.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:study_material_api/study_material_api.dart';
import 'package:path_provider/path_provider.dart';

part 'view_material_events.dart';
part 'view_material_state.dart';

class ViewMaterialBloc extends Bloc<ViewMaterialEvent, ViewMaterialState> {
  ViewMaterialBloc(
      {required FirestoreStudyMaterialRepository onlineMaterial,
      required HiveStudyMaterialRepository offlineMaterial})
      : _materialOnlineDataRepository = onlineMaterial,
        _hiveStudyMaterialRepository = offlineMaterial,
        super(ViewMaterialInitial()) {
    on<FetchCourseMaterials>((event, emit) async {
      List<StudyMaterial> materials = [];
      List<String> courses = [];
      List<String> myCourse = [event.course ?? ''];
      Map<String, List<StudyMaterial>> map = {};
      emit(FetchingMaterialsState());
      emit(LoadingState());
      try {
        if (event.online) {
          map = await _materialOnlineDataRepository.getStudyMaterials(myCourse);
        } else {
          List<String> myCourses = [];
          await HiveUserRepository()
              .getUserById(event.uid)
              .then((value) => myCourses = value?.myCourses ?? []);
          map = await _hiveStudyMaterialRepository.getStudyMaterials(myCourses);
        }
        if (event.course != null) {
          materials = map[event.course] ?? [];
        } else {
          for (String course in map.keys) {
            courses.add(course);
            materials.addAll(map[course] ?? []);
          }
        }
        emit(
            MaterialsFetchedState(studyMaterials: materials, courses: courses));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch user subjects\n $e'));
      }
    });

    on<DownLoadMaterial>((event, emit) async {
      try {
        Future<String> getFilePath(String filename, String subjectName) async {
          final dir = await getApplicationDocumentsDirectory();
          return "${dir.path}/$subjectName/$filename";
        }
        String urlOG = event.course.filePath ?? '';
        String url = event.course.filePath!;
        String fileName = event.course.title;
        String subjectName = event.course.subjectName;
        String path = await getFilePath(fileName, subjectName);

        // Check if the file already exists
        if (await File(path).exists()) {
          // File exists, emit StudyMaterialOpened directly
          StudyMaterial oldMaterial = event.course;
          oldMaterial.filePath = path;
          emit(
            StudyMaterialOpened(
              originalStudyMaterial: event.course,
              studyMaterial: oldMaterial,
              uid: event.uid,
            ),
          );
        } else {
          // emit(const DownloadingCourses(progress: 0));
          Dio dio = Dio();
          await dio.download(
            url,
            path,
            onReceiveProgress: (receivedBytes, totalBytes) {
              double progress = receivedBytes / totalBytes;
              emit(DownloadingCourses(progress: totalBytes.toDouble()));
              downLoadProgressCubit.updateProgress(progress);
            },
            deleteOnError: true,
          ).then((response) {
            StudyMaterial oldMaterial = event.course;
            oldMaterial.filePath = path;
            _hiveStudyMaterialRepository.addStudyMaterial(oldMaterial);
            emit(DownloadedCourse());
            downLoadProgressCubit.close;
            StudyMaterial  originalStudyMaterial = StudyMaterial(subjectName: event.course.subjectName, type: event.course.type, id: event.course.id, title: event.course.title, description: event.course.description, filePath: urlOG, fans: event.course.fans, haters: event.course.haters, reports: event.course.reports, size: event.course.size);
            oldMaterial.filePath = path;
            print('${originalStudyMaterial.filePath} vs ${oldMaterial.filePath}');
            emit(
              StudyMaterialOpened(
                originalStudyMaterial: originalStudyMaterial,
                studyMaterial: oldMaterial,
                uid: event.uid,
              ),
            );
          });
          
        }
      } catch (e) {
        emit(ErrorState(message: 'Failed to download material\n $e'));
      }
    });

    on<VoteMaterial>(
      (event, emit) async {
        List haters = event.material.haters;
        List fans = event.material.fans;
        StudyMaterial updateStudyMaterial = event.material;
        if (event.vote != null) {
          if (event.vote!) {
            if (!fans.contains(event.uid)) {
              updateStudyMaterial.haters.remove(event.uid);
              updateStudyMaterial.fans.add(event.uid);
            } else {
              updateStudyMaterial.haters.remove(event.uid);
              updateStudyMaterial.fans.remove(event.uid);
            }
          } else {
            if (!(haters.contains(event.uid))) {
              updateStudyMaterial.fans.remove(event.uid);
              updateStudyMaterial.haters.add(event.uid);
            } else {
              updateStudyMaterial.haters.remove(event.uid);
              updateStudyMaterial.fans.remove(event.uid);
            }
          }
        } else {
          updateStudyMaterial.haters.remove(event.uid);
          updateStudyMaterial.fans.remove(event.uid);
        }
        try {
          await _materialOnlineDataRepository
              .updateStudyMaterial(updateStudyMaterial);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReportMaterial>(
      (event, emit) async {
        List reports = event.material.reports;
        StudyMaterial updateStudyMaterial = event.material;
        if (!(reports.contains(event.uid))) {
          updateStudyMaterial.reports.add(event.uid);
        }
        try {
          if (event.material.reports.length <= 5) {
            await _materialOnlineDataRepository
                .updateStudyMaterial(updateStudyMaterial);
          } else {
            await _materialOnlineDataRepository
                .deleteStudyMaterial(event.material);
          }
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReadStudyMaterial>(
      (event, emit) => emit(
        StudyMaterialOpened(
          studyMaterial: event.offline,
          originalStudyMaterial: event.online,
          uid: event.uid,
        ),
      ),
    );
  }

  final HiveStudyMaterialRepository _hiveStudyMaterialRepository;
  final FirestoreStudyMaterialRepository _materialOnlineDataRepository;
}

class DownloadProgressCubit extends Cubit<double> {
  DownloadProgressCubit() : super(0);

  void updateProgress(double value) {
    emit(value);
  }
}

DownloadProgressCubit downLoadProgressCubit = DownloadProgressCubit();
