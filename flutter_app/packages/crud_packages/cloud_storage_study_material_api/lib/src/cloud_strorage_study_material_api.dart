import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:study_material_api/study_material_api.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreStudyMaterialRepository implements StudyMaterialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addStudyMaterial(StudyMaterial material) async {
    await _firestore.collection(material.subjectName).doc(material.id).set(material.toJson());
  }

  @override
  Future<void> updateStudyMaterial(StudyMaterial material) async {
    await _firestore.collection(material.subjectName).doc(material.id).update(material.toJson());
  }

  @override
  Future<void> deleteStudyMaterial(StudyMaterial material) async {
    try {
    FirebaseStorage storage = FirebaseStorage.instance;

    // Reference to the file in Firebase Storage
    Reference reference = storage.ref().child(material.filePath!);

    // Delete the file
    await reference.delete();

    await _firestore.collection(material.subjectName).doc(material.id).delete();

    if (kDebugMode) {
      print('File deleted successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting file: $e');
    }
  }
  }

  @override
  Future<Map<String, List<StudyMaterial>>> getStudyMaterials(List<String> courses) async {
  Map<String, List<StudyMaterial>> studyMaterialsMap = {};
  for (String course in courses) {
    QuerySnapshot querySnapshot = await _firestore.collection(course).get();
    List<StudyMaterial> studyMaterials = querySnapshot.docs
        .map((doc) => StudyMaterial.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    studyMaterialsMap[course] = studyMaterials;
  }

  return studyMaterialsMap;
}


  @override
  Future<StudyMaterial?> getStudyMaterialById(StudyMaterial material) async {
    DocumentSnapshot docSnapshot = await _firestore.collection(material.subjectName).doc(material.id).get();
    if (docSnapshot.exists) {
      return StudyMaterial.fromJson(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
