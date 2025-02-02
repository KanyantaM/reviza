import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PdfOps {
  /// Upload PDF to Firebase Storage
  /// - `subjectName` and `title` are required fields.
  /// - `uploadProgress` is a callback function to track progress.
  Future<String?> uploadPdfToFirebase(File pdfFile, String subjectName,
      String title, Function(double) uploadProgress) async {
    try {
      if (!pdfFile.existsSync()) {
        throw Exception("Upload failed: File does not exist.");
      }

      double progress = 0;

      String normalizedPath = p.normalize(pdfFile.path);
      String pdfFileName = (Platform.isWindows)
          ? pdfFile.path.split('\\').last
          : p.basename(normalizedPath);

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$subjectName/$title/$pdfFileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'application/pdf',
        cacheControl: 'public,max-age=300',
      );

      UploadTask uploadTask = storageReference.putFile(pdfFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot event) {
        progress = event.bytesTransferred / event.totalBytes;
        uploadProgress(progress);
      }, onError: (error) {
        uploadProgress(-1);
      });

      await uploadTask;
      return await storageReference.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Download PDF from Firebase Storage
  /// - Saves file in `/downloads/reviza/`
  Future<String> downloadPdfFromFirebase(String pdfUrl) async {
    try {
      String pdfFileName =
          Uri.parse(pdfUrl).pathSegments.last; // ✅ Safer extraction of filename

      // ✅ Get the documents directory
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String subdirectoryPath = '${documentsDirectory.path}/downloads/reviza/';
      Directory subdirectory = Directory(subdirectoryPath);

      if (!await subdirectory.exists()) {
        await subdirectory.create(recursive: true);
      }

      // ✅ Define local file path
      File pdfFile = File('$subdirectoryPath$pdfFileName');

      // ✅ Download the PDF
      await FirebaseStorage.instance.refFromURL(pdfUrl).writeToFile(pdfFile);

      return pdfFile.path;
    } catch (e) {
      throw Exception("Error downloading PDF: $e");
    }
  }
}
