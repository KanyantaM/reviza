part of 'upload_pdf_bloc.dart';

sealed class UploadPdfEvent extends Equatable {
  const UploadPdfEvent();

  @override
  List<Object> get props => [];
}

class UploadPdf extends UploadPdfEvent {
  final List<Uploads> uploads;

  /// Constructor now correctly references `pdfFiles`
  const UploadPdf({
    required this.uploads,
  });
}

class Annotate extends UploadPdfEvent {
  final Types type;

  final bool isRangeSelected;

  final int? startingYear;

  final int? endingYear;

  final String? category;

  final double? startingUnit;

  final double? endingUnit;

  final String? authorName;

//   url: _linkUrl,

  /// the id of the material to be updated
  final String materialId;

  /// the course
  final String course;

  /// the title
  final String? title;

  const Annotate(
      {required this.type,
      required this.isRangeSelected,
      required this.startingYear,
      required this.endingYear,
      required this.category,
      required this.startingUnit,
      required this.endingUnit,
      required this.authorName,
      required this.materialId,
      required this.title,
      required this.course});
}

///To cancel an upload
class RemoveFile extends UploadPdfEvent {
  final StudyMaterial material;

  const RemoveFile({required this.material});
}

class FetchMyUploads extends UploadPdfEvent {}
