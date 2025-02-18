import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PdfOps {
  /// Upload PDF to Firebase Storage
  /// - `subjectName` and `title` are required fields.
  /// - `uploadProgress` is a callback function to track progress.
  Stream<TaskSnapshot> uploadPdfToFirebase(File pdfFile, String subjectName,
      String title, Function(double) uploadProgress) {
    try {
      if (!pdfFile.existsSync()) {
        throw Exception("Upload failed: File does not exist.");
      }

      String normalizedPath = p.normalize(pdfFile.path);
      String pdfFileName = p.basename(normalizedPath);

      Reference storageReference =
          FirebaseStorage.instance.ref().child('$subjectName/$pdfFileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'application/pdf',
        cacheControl: 'public,max-age=300',
      );

      UploadTask uploadTask = storageReference.putFile(pdfFile, metadata);
      uploadTask.onError((e, stackTrace) {
        throw Exception(e);
      });
      Stream<TaskSnapshot> taskSnapshots = uploadTask.snapshotEvents;

      taskSnapshots.listen((data) {
        switch (data.state) {
          case TaskState.running:
            final double progress =
                100.0 * (data.bytesTransferred / data.totalBytes);
            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
          case TaskState.success:
            break;
        }
      }, onError: (error) {
        throw Exception(error);
      });

      storageReference.getDownloadURL().then((url) {});

      return taskSnapshots;
    } catch (e) {
      throw Exception(e);
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
