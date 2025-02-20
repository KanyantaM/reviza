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
}

/// State when a file is being removed.
final class RemovingFileState extends UploadPdfState {}

/// State when there's an error during any upload-related process.
final class ErrorState extends UploadPdfState {
  final String message;

  const ErrorState({required this.message});
}

/// State when uploads are being fetched.
final class FetchingUploadsState extends UploadPdfState {}

/// State when there's an error fetching uploaded files.
final class FetchingUploadedPdfErrorState extends UploadPdfState {}

/// Upload model with status tracking
class Uploads {
  final String name;
  bool get isAnnotated => description != null;
  final String courseName;
  final Types? type;
  final String? id;
  final String? status;
  bool get wentThrough => status == '✅';
  final File file;
  final String? description;

  const Uploads({
    required this.file,
    required this.courseName,
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.description,
  });

  Uploads copywith({
    File? file,
    String? courseName,
    String? id,
    Types? type,
    String? name,
    String? status,
    String? description,
  }) {
    return Uploads(
        file: file ?? this.file,
        courseName: courseName ?? this.courseName,
        type: type ?? this.type,
        name: name ?? this.name,
        status: status ?? this.status,
        id: this.id,
        description: description ?? this.description);
  }

  // @override
  // List<Object?> get props => [file];
}
