import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_api/student_api.dart';

class FiresbaseOnlineStudent implements StudentApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addUser(Student user) async {
    await _firestore.collection('users').doc(user.userId).set(user.toJson());
  }

  @override
  Future<Student?> getUserById(String userId) async {
    var docSnapshot = await _firestore.collection('users').doc(userId).get();
    var data = docSnapshot.data();
    return data != null ? Student.fromJson(data) : null;
  }

  @override
  Future<void> updateUser(Student user) async {
    await _firestore.collection('users').doc(user.userId).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<bool> isStudentRegistered(String studentId) async {
    var docSnapshot = await _firestore.collection('users').doc(studentId).get();
    var data = docSnapshot.data();
    return (data != null);
  }
}
