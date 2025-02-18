import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_material_api/study_material_api.dart';

class FiresbaseStudyMaterialImplementation implements StudyMaterialApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addStudyMaterial(StudyMaterial material) async {
    await _firestore
        .collection(material.subjectName)
        .doc(material.id)
        .set(material.toOnline());
  }

  @override
  Future<void> annotateStudyMaterial({
    required String id,
    required String course,
    String? titile,
    String? description,
  }) async {
    if (titile != null && description != null) {
      await _firestore.collection(course).doc(id).update({
        'title': titile,
        'description': description,
      });
    } else if (description != null) {
      await _firestore.collection(course).doc(id).update({
        'description': description,
      });
    } else {
      await _firestore.collection(course).doc(id).update({
        'title': titile,
      });
    }
  }

  @override
  Future<void> updateStudyMaterial(StudyMaterial material) async {
    await _firestore
        .collection(material.subjectName)
        .doc(material.id)
        .update(material.toOnline());
  }

  @override
  Future<void> deleteStudyMaterial(StudyMaterial material) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      // Reference to the file in Firebase Storage
      Reference reference = storage.ref().child(material.onlinePath!);

      // Delete the file
      await reference.delete();

      await _firestore
          .collection(material.subjectName)
          .doc(material.id)
          .delete();

      throw Exception('File deleted successfully');
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  @override
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(
      List<String> courses) async {
    Map<String, List<StudyMaterial>> studyMaterialsMap = {};
    for (String course in courses) {
      QuerySnapshot querySnapshot = await _firestore.collection(course).get();
      List<StudyMaterial> studyMaterials = querySnapshot.docs
          .map((doc) =>
              StudyMaterial.fromOnlineJson(doc.data() as Map<String, dynamic>))
          .toList();

      studyMaterialsMap[course] = studyMaterials;
    }

    return studyMaterialsMap;
  }

  @override
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial material) async {
    DocumentSnapshot docSnapshot = await _firestore
        .collection(material.subjectName)
        .doc(material.id)
        .get();
    if (docSnapshot.exists) {
      return StudyMaterial.fromOnlineJson(
          docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Future<void> deleteStudyMaterialsByCourse(String course) {
    throw UnimplementedError();
  }
}
