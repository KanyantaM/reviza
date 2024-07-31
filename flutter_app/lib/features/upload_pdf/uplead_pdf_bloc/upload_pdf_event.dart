part of 'upload_pdf_bloc.dart';

sealed class UploadPdfEvent extends Equatable {
  const UploadPdfEvent();

  @override
  List<Object> get props => [];
}

/// should be used with the pdf operations package
class UploadPdf extends UploadPdfEvent {
  final File pdfFile;

  final String subjectName;

  final String type;

  final String id;

  final String title;

  final String description;

  const UploadPdf(
      {required this.subjectName,
      required this.type,
      required this.id,
      required this.title,
      required this.description,
      required this.pdfFile});
}

///To cancel an upload
class RemoveFile extends UploadPdfEvent {
  final StudyMaterial material;

  const RemoveFile({required this.material});
}
