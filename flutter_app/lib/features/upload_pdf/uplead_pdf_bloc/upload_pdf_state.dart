part of 'upload_pdf_bloc.dart';

sealed class UploadPdfState {
  const UploadPdfState();
}

final class UploadPdfInitial extends UploadPdfState {}

/// State when a file is actively being uploaded.
final class UploadingPdfState extends UploadPdfState {
  final List<Uploads> currentUploads;
  final List<Uploads> completedUploads;

  const UploadingPdfState({
    required this.currentUploads,
    required this.completedUploads,
  });

  // @override
  // List<Object> get props => [currentUploads, completedUploads];
}

/// State when all uploads are fetched successfully.
final class FetchedUploadsPdf extends UploadPdfState {
  final List<Uploads> currentUploads;
  final List<Uploads> completedUploads;

  const FetchedUploadsPdf({
    required this.currentUploads,
    required this.completedUploads,
  });

  @override
  List<Object> get props => [currentUploads, completedUploads];
}

/// State when a file is being removed.
final class RemovingFileState extends UploadPdfState {}

/// State when there's an error during any upload-related process.
final class ErrorState extends UploadPdfState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

/// State when uploads are being fetched.
final class FetchingUploadsState extends UploadPdfState {}

/// State when there's an error fetching uploaded files.
final class FetchingUploadedPdfErrorState extends UploadPdfState {}

/// Upload model with status tracking
class Uploads {
  final String name;
  final bool isAnnotated;
  final String courseName;
  final Types? type;
  final String? id;
  final String? status;
  bool get wentThrough => status == '✅';
  final File file;

  const Uploads({
    required this.file,
    required this.courseName,
    this.id,
    required this.type,
    required this.name,
    required this.isAnnotated,
    required this.status,
  });

  Uploads copywith({
    File? file,
    String? courseName,
    String? id,
    Types? type,
    String? name,
    bool? isAnnotated,
    String? status,
  }) {
    return Uploads(
        file: file ?? this.file,
        courseName: courseName ?? this.courseName,
        type: type ?? this.type,
        name: name ?? this.name,
        isAnnotated: isAnnotated ?? this.isAnnotated,
        status: status ?? this.status);
  }

  // @override
  // List<Object?> get props => [file];
}
