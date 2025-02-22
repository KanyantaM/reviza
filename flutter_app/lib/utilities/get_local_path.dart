import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(String fileId, String subjectName) async {
  final Directory dir = await getApplicationDocumentsDirectory();
  final String path = '${dir.path}/$subjectName';
  await Directory(path).create(recursive: true); // Ensure directory exists
  return '$path/$fileId';
}
