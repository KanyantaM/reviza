import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_material_repository/study_material_repository.dart';

part 'upload_pdf_event.dart';
part 'upload_pdf_state.dart';

class UploadPdfBloc extends Bloc<UploadPdfEvent, UploadPdfState> {
  UploadPdfBloc({required StudyMaterialRepo studyMaterialRepo})
      : _studyMaterialRepository = studyMaterialRepo,
        super(UploadPdfInitial()) {
    on<UploadPdf>((event, emit) async {
      emit(UploadingPdfState());
      try {
        _studyMaterialRepository.uploadMaterial(
          pdfFile: event.pdfFile,
          title: event.title,
          subjectName: event.subjectName,
          type: event.type,
          description: event.description,
        );
      } catch (e) {
        emit(ErrorState(message: '$e'));
      }
    });

    on<RemoveFile>(
      (event, emit) async {
        emit(RemovingFileState());
        try {
          if (!(event.material.onlinePath?.isEmpty ?? false)) {
            _studyMaterialRepository.cancelUpload(material: event.material);
          } else {
            emit(UploadPdfInitial());
          }
        } catch (e) {
          emit(ErrorState(message: 'Error deleting subjects\n $e'));
        }
      },
    );
  }
  final StudyMaterialRepo _studyMaterialRepository;
}

class UploadProgressCubit extends Cubit<double> {
  UploadProgressCubit() : super(0);

  void updateProgress(double progress) {
    emit(progress);
  }
}

UploadProgressCubit uploadProgressCubit = UploadProgressCubit();
