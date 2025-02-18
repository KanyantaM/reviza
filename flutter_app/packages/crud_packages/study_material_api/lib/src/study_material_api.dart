import 'models/study_material_model.dart';

abstract class StudyMaterialApi {
  Future<void> addStudyMaterial(StudyMaterial material);
  Future<void> annotateStudyMaterial({
    required String id,
    required String course,
    String? titile,
    String? description,
  });
  Future<void> updateStudyMaterial(StudyMaterial material);
  Future<void> deleteStudyMaterial(StudyMaterial materialId);
  Future<void> deleteStudyMaterialsByCourse(String course);
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(
      List<String> course);
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial materialId);
}
