import 'models/study_material_model.dart';

abstract class StudyMaterialRepository {
  Future<void> addStudyMaterial(StudyMaterial material);
  Future<void> updateStudyMaterial(StudyMaterial material);
  Future<void> deleteStudyMaterial(StudyMaterial materialId);
  Future<Map<String,List<StudyMaterial>>> getStudyMaterials(List<String> course);
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial materialId);
}
