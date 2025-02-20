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
    on<FetchCourseMaterials>((event, emit) async {
      Map<String, List<StudyMaterial>> map = {};
      emit(FetchingMaterialsState());
      emit(LoadingState());
      try {
        if (event.online) {
          map = await _materialRepository.fetchUploadedMaterial(
              course: event.course ?? '');
        } else {
          map = await _materialRepository.fetchDownloads();
        }
        emit(MaterialsFetchedState(courseToMaterialsMap: map));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch study material\n $e'));
      }
    });

    on<DownLoadMaterial>(_downloadMaterial);

    on<DownLoadMaterial>((event, emit) async {
      try {
        await for (final progress
            in _materialRepository.downloadMaterial(event.course)) {
          emit(DownloadingCourses());

          if (progress == 1.0) {
            emit(MaterialDownloadedSuccesfully());
          }
        }
      } catch (e) {
        emit(ErrorState(message: 'Failed to download material\n $e'));
      }
    });

    on<VoteMaterial>(
      (event, emit) async {
        try {
          await _materialRepository.upvoteMaterial(
              vote: event.vote, studyMaterial: event.material);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );

    on<ReportMaterial>(
      (event, emit) async {
        try {
          _materialRepository.reportMaterial(studyMaterial: event.material);
        } on Exception catch (e) {
          emit(ErrorState(message: 'Voting failed\n ERROR: $e'));
        }
      },
    );
  }

  /// Handles multiple file uploads concurrently
  Future<void> _downloadMaterial(
      DownLoadMaterial event, Emitter<DownloadingCourses> emit) async {
    // List<Future<void>> StudentCache.uploadTasks = [];

    for (StudyMaterial material in StudentCache.currentDownload) {
      if (!(await material.isOnDevice)) {
        StudentCache.currentDownloadTasks
            .add(_downloadSingleFile(material, event, emit));
      }
    }

    await Future.wait(StudentCache.currentDownloadTasks);

    emit(DownloadingCourses());
  }

  Future<void> _downloadSingleFile(
    StudyMaterial material,
    DownLoadMaterial event,
    Emitter<DownloadingCourses> emit,
  ) async {
    if (material.onlinePath == null) {
      throw Exception('Please give ${material.title} a document type');
    }

    try {
      Stream<double> dowloadStatus =
          _materialRepository.downloadMaterial(material);

      // Show notification that upload has started
      final notificationTask =
          NotificationService.showDownloadProgressNotification(
              0, material.title, material.id);
      StudentCache.addNotifications(notificationTask);

      await emit.forEach<double>(
        dowloadStatus,
        onError: (error, stackTrace) {
          StudentCache.currentDownload
              .removeWhere((up) => material.id == up.id);

          NotificationService.showDownloadErrorNotification(
              material.title, material.id);

          return DownloadingCourses();
        },
        onData: (status) {
          if (status < 1) {
            final StudyMaterial newUpload =
                material.copyWith(downloadProgress: status);
            StudentCache.currentDownload
                .removeWhere((up) => material.id == up.id);
            StudentCache.currentDownload.add(newUpload);

            NotificationService.showDownloadProgressNotification(
                status, material.title, material.id);

            return DownloadingCourses();
          }

          if (status == 1) {
            NotificationService.showDownloadCompletionNotification(
                material.title, material.id);

            return DownloadingCourses();
          }

          return DownloadingCourses();
        },
      );
    } catch (e) {
      // Cancel notification on error

      emit(ErrorState(
        message: 'Upload failed for ${material.title}: ${e.toString()}',
      ));
    }
  }

  final StudyMaterialRepo _materialRepository;
}
