import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_material_api/study_material_api.dart';

class HiveStudyMaterialRepository implements StudyMaterialRepository {
  late Box _box;
  bool _isInitialized = false;

  HiveStudyMaterialRepository() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(StudyMaterialAdapter());
      }
      _box = await Hive.openBox('study_materials');
      _isInitialized = true;
    }
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
    _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);
    List<dynamic> materialsList =
        _box.get(courseFolderKey, defaultValue: <StudyMaterial>[]);
    materialsList.add(material);
    await _box.put(courseFolderKey, materialsList);
  }

  @override
  Future<void> updateStudyMaterial(StudyMaterial material) async {
    _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);
    List<StudyMaterial> materialsList =
        _box.get(courseFolderKey, defaultValue: <StudyMaterial>[]);
    int index = materialsList.indexWhere((item) => item.id == material.id);

    if (index != -1) {
      materialsList[index] = material;
      await _box.put(courseFolderKey, materialsList);
    }
  }

  @override
  Future<void> deleteStudyMaterial(StudyMaterial material) async {
    _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);
    List<StudyMaterial> materialsList =
       List<StudyMaterial>.from( _box.get(courseFolderKey, defaultValue: <StudyMaterial>[]));
      materialsList.removeWhere((item) {
        if(item.id == material.id) {
          File(item.filePath!).delete();
          return true;
        }else {
          return false;
        }
      });
      await _box.put(courseFolderKey, materialsList);    
  }

  @override
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(
      List<String> courses ) async {
    Map<String, List<StudyMaterial>> studyMaterialsMap = {};
    for (String course in courses) {
      _ensureInitialized();
      String courseFolderKey = getCourseFolderKey(course);
      List<StudyMaterial> materialsList =
          List<StudyMaterial>.from(_box.get(courseFolderKey, defaultValue: <StudyMaterial>[]));
      List<StudyMaterial> studyMaterials = materialsList;

      studyMaterialsMap[course] = studyMaterials;
    }
    return studyMaterialsMap;
  }

  @override
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial material) async {
    _ensureInitialized();
    for (var key in _box.keys) {
      List<StudyMaterial> materialsList =
          List<StudyMaterial>.from(_box.get(key, defaultValue: <StudyMaterial>[]));
      StudyMaterial json =
          materialsList.firstWhere((item) => item.id == material.id);
      return json;
    }
    return null;
  }
}
