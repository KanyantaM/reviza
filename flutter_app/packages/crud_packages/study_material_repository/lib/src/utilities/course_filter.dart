import 'package:study_material_repository/study_material_repository.dart';

Future<List<StudyMaterial>> filter(
  Map<String, List<StudyMaterial>> allMaterials, {
  String? courseName,
  Types? type,
}) async {
  if ((courseName!.isNotEmpty)) {
    return allMaterials.values.expand((x) => x).where((material) {
      bool matchesCourse = material.subjectName == courseName;
      bool matchesType = type == null || material.type == type.name;
      return matchesCourse && matchesType;
    }).toList();
  }
  return allMaterials.values.expand((x) => x).toList();
}
