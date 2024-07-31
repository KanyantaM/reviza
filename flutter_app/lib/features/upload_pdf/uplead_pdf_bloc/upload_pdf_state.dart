part of 'upload_pdf_bloc.dart';

sealed class UploadPdfState extends Equatable {
  const UploadPdfState();
  
  @override
  List<Object> get props => [];
}

final class UploadPdfInitial extends UploadPdfState {}

final class UploadingPdfState extends UploadPdfState{}

final class UploadedPdfState extends UploadPdfState{
}

final class RemovingFileState extends UploadPdfState{}

final class ErrorState extends UploadPdfState{
  final String message;

  const ErrorState({required this.message});
}