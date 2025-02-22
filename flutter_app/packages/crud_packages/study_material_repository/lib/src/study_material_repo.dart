import 'dart:async';
import 'dart:io';

import 'package:student_repository/student_repository.dart';
import 'package:study_material_api/study_material_api.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class StudyMaterialRepo {
  final String uid;
  final StudyMaterialApi _localStorage = HiveStudyMaterialApiImplementation();
  final StudyMaterialApi _cloudStorage = FiresbaseStudyMaterialImplementation();

  StudyMaterialRepo({required this.uid});

  Future<void> upvoteMaterial({
    required bool? vote,
    required StudyMaterial studyMaterial,
  }) async {
    final fans = List<String>.from(studyMaterial.fans);
    final haters = List<String>.from(studyMaterial.haters);

    if (vote == true) {
      fans.contains(uid) ? fans.remove(uid) : fans.add(uid);
      haters.remove(uid);
    } else if (vote == false) {
      haters.contains(uid) ? haters.remove(uid) : haters.add(uid);
      fans.remove(uid);
    } else {
      fans.remove(uid);
      haters.remove(uid);
    }

    final updatedStudyMaterial =
        studyMaterial.copyWith(fans: fans, haters: haters);

    try {
      await _localStorage.updateStudyMaterial(updatedStudyMaterial);
      await _cloudStorage.updateStudyMaterial(updatedStudyMaterial);
    } catch (e) {
      throw Exception('Failed to update vote: $e');
    }
  }

  Future<void> reportMaterial({
    required StudyMaterial studyMaterial,
  }) async {
    final reports = List<String>.from(studyMaterial.reports);
    if (reports.contains(uid)) return;

    reports.add(uid);
    final updatedStudyMaterial = studyMaterial.copyWith(reports: reports);

    try {
      if (reports.length > 5) {
        await _cloudStorage.deleteStudyMaterial(updatedStudyMaterial);
        await _localStorage.deleteStudyMaterial(studyMaterial);
      } else {
        await _cloudStorage.updateStudyMaterial(updatedStudyMaterial);
      }
    } catch (e) {
      throw Exception('Failed to report material: $e');
    }
  }

  Future<void> shareMaterial({required StudyMaterial studyMaterial}) async {
    // Implement sharing logic here
  }

  Stream<double> downloadMaterial(
    StudyMaterial studyMaterial,
  ) async* {
    if (studyMaterial.onlinePath == null) {
      throw Exception('No online path available for download.');
    }

    final filePath =
        await _getFilePath(studyMaterial.id, studyMaterial.subjectName);
    final downloadedMaterial = studyMaterial.copyWith(localPath: filePath);

    if (studyMaterial.isInBox) {
      yield 1.0;
      return;
    }

    final StreamController<double> controller = StreamController();

    try {
      await Dio().download(
        studyMaterial.onlinePath!,
        filePath,
        onReceiveProgress: (received, total) {
          final double progress = total > 0 ? received / total : 0.0;
          controller.add(
            progress,
          );
        },
      );

      controller.add(1.0);
      await _localStorage.addStudyMaterial(downloadedMaterial);
    } catch (e) {
      controller.addError(Exception('Download failed: $e'));
    } finally {
      await controller.close();
    }

    yield* controller.stream; // Stream the updates
  }

  Future<void> annotateMaterial(
      {required String id,
      required String course,
      String? title,
      String? description}) async {
    try {
      _cloudStorage.annotateStudyMaterial(id: id, course: course);
      _localStorage.annotateStudyMaterial(id: id, course: course);
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<String> uploadMaterial({
    required File? pdfFile,
    required String? title,
    required String? subjectName,
    required String type,
    required String? description,
    required String? materialId,
  }) {
    if (subjectName == null || subjectName.isEmpty) {
      throw Exception('Please select a course');
    }
    if (pdfFile == null || !pdfFile.existsSync()) {
      throw Exception('File is empty or does not exist');
    }
    if (title == null || title.isEmpty) {
      throw Exception('Couldn\'t assign title');
    }

    final stateController = StreamController<String>();
    final normalizedPath = normalize(pdfFile.path);
    final pdfFileName = basename(normalizedPath);
    final storageReference =
        FirebaseStorage.instance.ref().child('$subjectName/$pdfFileName');

    final metadata = SettableMetadata(
      contentType: 'application/pdf',
      cacheControl: 'public,max-age=300',
    );

    final uploadTask = storageReference.putFile(pdfFile, metadata);

    uploadTask.snapshotEvents.listen((snapshot) async {
      try {
        switch (snapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (snapshot.bytesTransferred / snapshot.totalBytes);
            stateController.add("${progress.toStringAsFixed(2)} %");
            break;
          case TaskState.paused:
            stateController.add('⏸️');
            break;
          case TaskState.canceled:
            stateController.add('❌');
            break;
          case TaskState.error:
            stateController.addError('❗ Upload failed.');
            break;
          case TaskState.success:
            final filePath = await storageReference.getDownloadURL();
            if (filePath.isEmpty && type != 'LINKS') {
              throw Exception('Couldn\'t find path to storage');
            }

            final studyMaterial = StudyMaterial(
              subjectName: subjectName,
              type: type,
              id: materialId ?? Uuid().v4(),
              title: title,
              description: description ?? '',
              onlinePath: filePath,
              fans: [],
              haters: [],
              reports: [],
              size: (type != 'LINKS') ? (await pdfFile.length()) ~/ 1024 : 0,
              localPath: pdfFile.path,
            );

            await _localStorage.addStudyMaterial(studyMaterial);
            await _cloudStorage.addStudyMaterial(studyMaterial);

            stateController.add('✅');
            await stateController.close();
            break;
        }
      } catch (e) {
        stateController.addError(e.toString());
        await stateController.close();
      }
    }, onError: (error) {
      stateController.addError(error.toString());
      stateController.close();
    }, cancelOnError: true);

    return stateController.stream;
  }

  Future<Map<String, List<StudyMaterial>>> fetchDownloads() async {
    Student student = await _fetchCurrentStudent();
    return _localStorage.getStudyMaterials(student.myCourses);
  }

  Future<Map<String, List<StudyMaterial>>> fetchUploadedMaterial(
      {required String course, String? type}) async {
    return _cloudStorage.getStudyMaterials([course]);
  }

  Future<String> _getFilePath(String fileId, String subjectName) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$subjectName/$fileId";
  }

  Future<Student> _fetchCurrentStudent() async {
    return await StudentRepository().getUserById(uid) ??
        Student(
          userId: uid,
          myCourses: [],
        );
  }

  Future<void> deleteLocalCourseMaterial({required String courseId}) async {
    await _localStorage.deleteStudyMaterialsByCourse(courseId);
  }

  Future<void> cancelUpload({required StudyMaterial material}) async {
    try {
      if (!(material.onlinePath?.isEmpty ?? false)) {
        try {
          _cloudStorage.deleteStudyMaterial(material);
        } catch (e) {
          throw Exception(e);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
