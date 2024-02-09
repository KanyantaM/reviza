import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class PdfOps {
  ///subject name and title should be compulsory fields
Future<String?> uploadPdfToFirebase(File pdfFile, String subjectName, String title, Function(double) uploadProgress) async {
  try {
    String pdfFileName = pdfFile.path.split('/').last;
    Reference storageReference = FirebaseStorage.instance.ref().child('$subjectName/$title/$pdfFileName');

    UploadTask uploadTask = storageReference.putFile(pdfFile);
    uploadTask.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      uploadProgress(progress); // Call the function with the progress value
      print('Upload progress: $progress'); // Update your UI here
    });

    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    log("Error uploading PDF: $e");
    return null;
  }
}


Future<String> downloadPdfFromFirebase(String pdfUrl) async {
  try {
    String pdfFileName = pdfUrl.split('/').last; // Extracting file name from URL

    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    
    // Create the desired subdirectory '/downloads/reviza/'
    String subdirectoryPath = '${documentsDirectory.path}/downloads/reviza/';
    Directory subdirectory = Directory(subdirectoryPath);
    if (!subdirectory.existsSync()) {
      subdirectory.createSync(recursive: true);
    }

    // Create the local PDF file
    File pdfFile = File('$subdirectoryPath$pdfFileName');

    // Download the PDF from Firebase Storage
    await FirebaseStorage.instance.refFromURL(pdfUrl).writeToFile(pdfFile);

    return pdfFile.path;
  } catch (e) {
    log("Error downloading PDF: $e");
    return '';
  }
}
}

