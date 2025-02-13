import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_material_api/study_material_api.dart';

class HiveStudyMaterialApiImplementation implements StudyMaterialApi {
  Box? _box; // Nullable to avoid premature access
  bool _isInitialized = false;

  HiveStudyMaterialApiImplementation() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(StudyMaterialAdapter());
    }

    _box = await Hive.openBox('study_materials');
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initHive();
    }
  }

  String getCourseFolderKey(String subjectName) {
    return 'folder_$subjectName';
  }

  @override
  Future<void> addStudyMaterial(StudyMaterial material) async {
    await _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);

    List<StudyMaterial> materialsList = List<StudyMaterial>.from(
        _box?.get(courseFolderKey, defaultValue: <StudyMaterial>[]) ?? []);

    materialsList.add(material);
    await _box?.put(courseFolderKey, materialsList);
  }

  @override
  Future<void> updateStudyMaterial(StudyMaterial material) async {
    await _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);

    List<StudyMaterial> materialsList = List<StudyMaterial>.from(
        _box?.get(courseFolderKey, defaultValue: <StudyMaterial>[]) ?? []);

    int index = materialsList.indexWhere((item) => item.id == material.id);
    if (index != -1) {
      materialsList[index] = material;
      await _box?.put(courseFolderKey, materialsList);
    }
  }

  @override
  Future<void> deleteStudyMaterial(StudyMaterial material) async {
    await _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);

    List<StudyMaterial> materialsList = List<StudyMaterial>.from(
        _box?.get(courseFolderKey, defaultValue: <StudyMaterial>[]) ?? []);

    materialsList.removeWhere((item) {
      if (item.id == material.id) {
        if (item.localPath != null && File(item.localPath!).existsSync()) {
          try {
            File(item.localPath!).deleteSync();
          } catch (e) {
            throw Exception('Error deleting file: $e');
          }
        }
        return true;
      }
      return false;
    });

    await _box?.put(courseFolderKey, materialsList);
  }

  @override
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(
      List<String> courses) async {
    await _ensureInitialized();

    Map<String, List<StudyMaterial>> studyMaterialsMap = {};
    for (String course in courses) {
      String courseFolderKey = getCourseFolderKey(course);

      List<StudyMaterial> materialsList = List<StudyMaterial>.from(
          _box?.get(courseFolderKey, defaultValue: <StudyMaterial>[]) ?? []);

      studyMaterialsMap[course] = materialsList;
    }
    return studyMaterialsMap;
  }

  @override
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial material) async {
    await _ensureInitialized();

    for (var key in _box?.keys ?? []) {
      List<StudyMaterial> materialsList = List<StudyMaterial>.from(
          _box?.get(key, defaultValue: <StudyMaterial>[]) ?? []);

      return materialsList.firstWhere((item) => item.id == material.id);
    }
    return null;
  }

  @override
  Future<void> deleteStudyMaterialsByCourse(
    String subjectName,
  ) async {
    String courseFolderKey = 'folder_\$subjectName';
    List<StudyMaterial> materialsList = List<StudyMaterial>.from(
        _box?.get(courseFolderKey, defaultValue: <StudyMaterial>[]) ?? []);

    for (var material in materialsList) {
      if (material.localPath != null &&
          File(material.localPath!).existsSync()) {
        try {
          File(material.localPath!).deleteSync();
        } catch (e) {
          throw Exception('Error deleting file: \$e');
        }
      }
    }
    await _box?.delete(courseFolderKey);
  }
}
