import 'package:reviza/cache/student_cache.dart';
import 'package:study_material_repository/study_material_repository.dart';

Future<Map<String, List<StudyMaterial>>> fetchMaterials(
    {required bool isOnline, String? course}) async {
  final StudyMaterialRepo materialRepository =
      StudyMaterialRepo(uid: StudentCache.tempStudent.userId);
  Map<String, List<StudyMaterial>> map = {};

  try {
    if (isOnline) {
      if (StudentCache.cloudStudyMaterial[course]?.isEmpty ?? true) {
        map = await materialRepository.fetchUploadedMaterial(
            course: course ?? '');
        StudentCache.updateCloudStudyMaterial(course ?? '', map[course]!);
      } else {
        map = StudentCache.cloudStudyMaterial;
      }
    } else {
      map = StudentCache.localStudyMaterial;
    }
    return map;
  } catch (e) {
    throw Exception('Failed to fetch study material\n $e');
  }
}
