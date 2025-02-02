import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:study_material_api/study_material_api.dart';

Future<bool> isFileDownloaded(String filename, String subjectName) async {
  final dir = await getApplicationDocumentsDirectory();
  return File("${dir.path}/$subjectName/$filename").existsSync();
}

Future<String> getPathToDelete(StudyMaterial studyMaterial) async {
  final dir = await getApplicationDocumentsDirectory();
  final filePath =
      "${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}";
  return File(filePath).existsSync() ? filePath : '';
}

Future<void> deleteFile(StudyMaterial studyMaterial) async {
  final dir = await getApplicationDocumentsDirectory();
  final filePath =
      "${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}";
  if (File(filePath).existsSync()) {
    await File(filePath).delete();
  }
}
