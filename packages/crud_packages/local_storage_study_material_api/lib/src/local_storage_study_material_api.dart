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
    _box = await Hive.openBox('study_materials');
    _isInitialized = true; }
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
    List<dynamic> materialsList = _box.get(courseFolderKey, defaultValue: []);
    materialsList.add(material.toJson());
    await _box.put(courseFolderKey, materialsList);
  }

  @override
  Future<void> updateStudyMaterial(StudyMaterial material) async {
    _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(material.subjectName);
    List<dynamic> materialsList = _box.get(courseFolderKey, defaultValue: []);
    int index = materialsList.indexWhere((item) => item['id'] == material.id);

    if (index != -1) {
      materialsList[index] = material.toJson();
      await _box.put(courseFolderKey, materialsList);
    }
  }

  @override
  Future<void> deleteStudyMaterial(StudyMaterial material) async {

  _ensureInitialized();
    for (var key in _box.keys) {
      List<dynamic> materialsList = _box.get(key, defaultValue: []);
      materialsList.removeWhere((item) => item['id'] == material.id);
      await _box.put(key, materialsList);
    }
  }

  @override
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(List<String> courses) async {
  Map<String, List<StudyMaterial>> studyMaterialsMap = {};

  for (String course in courses) {
    _ensureInitialized();
    String courseFolderKey = getCourseFolderKey(course);
    List<dynamic> materialsList = _box.get(courseFolderKey, defaultValue: []);
    List<StudyMaterial> studyMaterials = materialsList
        .map((json) => StudyMaterial.fromJson(json as Map<String, dynamic>))
        .toList();

    studyMaterialsMap[course] = studyMaterials;
  }

  return studyMaterialsMap;
}


  @override
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial material) async {
    _ensureInitialized();
    for (var key in _box.keys) {
      List<dynamic> materialsList = _box.get(key, defaultValue: []);
      var json = materialsList.firstWhere((item) => item['id'] == material.id, orElse: () => null);

      if (json != null) {
        return StudyMaterial.fromJson(json as Map<String, dynamic>);
      }
    }

    return null;
  }
}
