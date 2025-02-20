import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reviza/app/services/notifications_service.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/upload_pdf/view/utils/type_description_generator.dart';
import 'package:study_material_repository/study_material_repository.dart';

part 'upload_pdf_event.dart';
part 'upload_pdf_state.dart';

class UploadPdfBloc extends Bloc<UploadPdfEvent, UploadPdfState> {
  UploadPdfBloc({required StudyMaterialRepo studyMaterialRepo})
      : _studyMaterialRepository = studyMaterialRepo,
        super(UploadPdfInitial()) {
    on<UploadPdf>(_onUploadPdf);
    on<Annotate>(_onAnnotate);
    on<RemoveFile>(_onRemoveFile);
  }

  final StudyMaterialRepo _studyMaterialRepository;
  final List<Uploads> _currentUploads = StudentCache.unseenUploads;
  final List<Uploads> _completedUploads = StudentCache.seenUploads;

  /// Handles multiple file uploads concurrently
  Future<void> _onUploadPdf(
      UploadPdf event, Emitter<UploadPdfState> emit) async {
    // List<Future<void>> StudentCache.uploadTasks = [];

    for (Uploads upload in StudentCache.unseenUploads) {
      if (upload.status == null) {
        StudentCache.uploadTasks.add(_uploadSingleFile(upload, event, emit));
      }
    }

    await Future.wait(StudentCache.uploadTasks);

    emit(FetchedUploadsPdf(
      currentUploads: List.from(_currentUploads),
      completedUploads: List.from(_completedUploads),
    ));
  }

  /// Uploads a single file and listens for status updates
  Future<void> _uploadSingleFile(
    Uploads upload,
    UploadPdf event,
    Emitter<UploadPdfState> emit,
  ) async {
    if (upload.type == null) {
      emit(ErrorState(message: 'Please give ${upload.name} a document type'));
      return;
    }

    try {
      Stream<String> uploadStatus = _studyMaterialRepository.uploadMaterial(
        pdfFile: upload.file,
        title: basename(normalize(upload.file.path)),
        subjectName: upload.courseName,
        type: upload.type?.name ?? '',
        description: '',
        materialId: upload.id,
      );

      // Show notification that upload has started
      final notificationTask = NotificationService.showProgressNotification(
          0, upload.name, upload.id ?? '');
      StudentCache.addNotifications(notificationTask);

      await emit.forEach<String>(
        uploadStatus,
        onError: (error, stackTrace) {
          final Uploads newUpload = upload.copywith(status: '❗ error');
          _currentUploads.removeWhere((up) => upload.file == up.file);
          _currentUploads.add(newUpload);
          _updateCache();

          NotificationService.showUploadErrorNotification(
              upload.name, upload.id ?? '');

          return UploadingPdfState(
            currentUploads: StudentCache.unseenUploads,
            completedUploads: StudentCache.seenUploads,
          );
        },
        onData: (status) {
          final Uploads newUpload = upload.copywith(status: status);
          _currentUploads.removeWhere((up) => upload.file == up.file);
          _currentUploads.add(newUpload);
          _updateCache();

          if (status.contains('%')) {
            // Extract percentage and update the notification
            final double progress =
                double.tryParse(status.replaceAll('%', '')) ?? 0;
            NotificationService.showProgressNotification(
                progress, upload.name, upload.id ?? '');

            return UploadingPdfState(
              currentUploads: StudentCache.unseenUploads,
              completedUploads: StudentCache.seenUploads,
            );
          }

          if (status == '✅') {
            _currentUploads.removeWhere((up) => upload.file == up.file);
            _completedUploads.add(newUpload);

            _updateCache();

            NotificationService.showCompletionNotification(
                upload.name, upload.id ?? '');

            return UploadingPdfState(
              currentUploads: StudentCache.unseenUploads,
              completedUploads: StudentCache.seenUploads,
            );
          }

          return UploadingPdfState(
            currentUploads: StudentCache.unseenUploads,
            completedUploads: StudentCache.seenUploads,
          );
        },
      );
    } catch (e) {
      // Cancel notification on error
      // NotificationService.cancelNotification(upload.id ?? '');

      emit(ErrorState(
        message:
            'Upload failed for ${basename(upload.file.path)}: ${e.toString()}',
      ));
    }
  }

  /// Handles annotation events
  void _onAnnotate(Annotate event, Emitter<UploadPdfState> emit) {
    final Uploads upload =
        _completedUploads.firstWhere((upload) => upload.id == event.materialId);
    final desc = descriptionGenerator(
      type: event.type,
      isRangeSelected: event.isRangeSelected,
      startingYear: event.startingYear,
      endingYear: event.endingYear,
      category: event.category,
      startingUnit: event.startingUnit,
      endingUnit: event.endingUnit,
      authorName: event.authorName ?? '',
      url: '',
    );
    final Uploads newUpload = upload.copywith(description: desc);

    try {
      _studyMaterialRepository.annotateMaterial(
        id: event.materialId,
        course: event.course,
        title: event.title ?? upload.name,
        description: desc,
      );

      _currentUploads.removeWhere((up) => upload.file == up.file);
      _completedUploads.add(newUpload);

      _updateCache();

      emit(FetchedUploadsPdf(
        currentUploads: List.from(_currentUploads),
        completedUploads: List.from(_completedUploads),
      ));
    } catch (e) {
      emit(ErrorState(message: 'Failed to annotate: ${e.toString()}'));
    }
  }

  /// Handles file removal events
  Future<void> _onRemoveFile(
      RemoveFile event, Emitter<UploadPdfState> emit) async {
    emit(RemovingFileState());

    try {
      if (event.material.onlinePath?.isNotEmpty ?? false) {
        await _studyMaterialRepository.cancelUpload(material: event.material);
      }

      _currentUploads
          .removeWhere((upload) => upload.name == event.material.title);
      _completedUploads
          .removeWhere((upload) => upload.name == event.material.title);

      _updateCache();

      emit(FetchedUploadsPdf(
        currentUploads: List.from(_currentUploads),
        completedUploads: List.from(_completedUploads),
      ));
    } catch (e) {
      emit(ErrorState(message: 'Error deleting file: ${e.toString()}'));
    }
  }

  /// Updates the StudentCache
  void _updateCache() {
    StudentCache.setUnseenUploads(List<Uploads>.from(_currentUploads));
    StudentCache.setSeenUploads(List<Uploads>.from(_completedUploads));
  }
}
