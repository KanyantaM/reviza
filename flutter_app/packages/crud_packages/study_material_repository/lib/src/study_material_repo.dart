import 'dart:async';
import 'dart:io';

import 'package:student_repository/student_repository.dart';
import 'package:study_material_api/study_material_api.dart';
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

  Stream<String> downloadMaterial({
    required StudyMaterial studyMaterial,
    required String pathToDownload,
    required Student downloader,
  }) {
    if (studyMaterial.onlinePath == null) {
      throw Exception('No online path available for download.');
    }

    final stateController = StreamController<String>();
    final studyMaterialRef =
        FirebaseStorage.instance.refFromURL(studyMaterial.onlinePath!);
    final file = File(pathToDownload);

    final downloadTask = studyMaterialRef.writeToFile(file);

    downloadTask.snapshotEvents.listen((taskSnapshot) async {
      try {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            stateController.add("${progress.toStringAsFixed(2)} %");
            break;
          case TaskState.paused:
            stateController.add('⏸️');
            break;
          case TaskState.canceled:
            stateController.add('❌');
            break;
          case TaskState.error:
            stateController.addError('❗ Download failed.');
            break;
          case TaskState.success:
            final StudyMaterial downloadedMaterial = studyMaterial.copyWith(
                localPath: pathToDownload,
                downloaders: (studyMaterial.downloads ?? 0) + 1);
            final Student updatedStudent = downloader.copyWith(
                downloadCount: (downloader.downloadCount ?? 0) + 1);

            await StudentRepository().updateUser(updatedStudent);
            await _cloudStorage.addStudyMaterial(downloadedMaterial);
            await _localStorage.addStudyMaterial(downloadedMaterial);
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
    required Student? uploader,
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
              downloads: 0,
              uploaderId: uploader?.userId ?? '',
            );

            final Student updatedStudent = uploader!
                .copyWith(uploadCount: (uploader.uploadCount ?? 0) + 1);

            await StudentRepository().updateUser(updatedStudent);

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

  Future<Student> _fetchCurrentStudent() async {
    return await StudentRepository().getUserById(uid) ??
        Student(
          userId: uid,
          myCourses: [],
          uploadCount: 0,
          downloadCount: 0,
          badUploadCount: 0,
        );
  }

  Future<void> deleteLocalCourseMaterial({required String course}) async {
    try {
      await _localStorage.deleteStudyMaterialsByCourse(course);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteLocalMaterial({required StudyMaterial material}) async {
    try {
      await _localStorage.deleteStudyMaterial(material);
    } on Exception catch (e) {
      throw Exception(e);
    }
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
