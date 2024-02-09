import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_storage_study_material_api/cloud_storage_study_material_api.dart';
import 'package:study_material_api/study_material_api.dart';

part 'upload_pdf_event.dart';
part 'upload_pdf_state.dart';

class UploadPdfBloc extends Bloc<UploadPdfEvent, UploadPdfState> {
  UploadPdfBloc({required FirestoreStudyMaterialRepository studentOnline})
      : _materialOnlineDataRepository = studentOnline,
        super(UploadPdfInitial()) {
    on<UploadPdf>((event, emit) async {
      emit(UploadingPdfState());
      try {
        String filePath = await _pdfOps.uploadPdfToFirebase(
                event.pdfFile, event.subjectName, event.title, (progress) {
              uploadProgressCubit.updateProgress(progress);
            }) ??
            '';
        if (filePath.isEmpty && (event.type != 'LINKS')) {
          emit(const ErrorState(message: 'Couldn\'t find file path'));
        } else {
          int size = 0;
          if(event.type != 'LINKS')
            {size = await (File(event.pdfFile.path).length()) ~/ 1024;
            }
          StudyMaterial newStudyMaterial = StudyMaterial(
            subjectName: event.subjectName,
            type: event.type,
            id: event.id,
            title: event.title,
            description: event.description,
            filePath: filePath,
            fans: [],
            haters: [],
            reports: [],
            size: size,
          );
          await _materialOnlineDataRepository.addStudyMaterial(newStudyMaterial);
          emit(UploadedPdfState());
        }
      } catch (e) {
        emit(ErrorState(message: '$e'));
      }
    });

    on<RemoveFile>(
      (event, emit) async {
        emit(RemovingFileState());
        try {
          if (!(event.material.filePath?.isEmpty ?? false)) {
            try {
              _materialOnlineDataRepository.deleteStudyMaterial(event.material);
              emit(UploadPdfInitial());
            } catch (e) {
              emit(ErrorState(message: 'Error deleting from database\n $e'));
            }
          } else {
            emit(UploadPdfInitial());
          }
        } catch (e) {
          emit(ErrorState(message: 'Error deleting subjects\n $e'));
        }
      },
    );
  }
  final PdfOps _pdfOps = PdfOps();
  final FirestoreStudyMaterialRepository _materialOnlineDataRepository;
}

class UploadProgressCubit extends Cubit<double> {
  UploadProgressCubit() : super(0);

  void updateProgress(double progress) {
    emit(progress);
  }
}

UploadProgressCubit uploadProgressCubit = UploadProgressCubit();
