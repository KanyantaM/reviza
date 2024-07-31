import 'package:student_api/src/models/student_model.dart';

abstract class UserRepository {
  ///This method is used to check whether an authenticated user is already in the database/local or cloud
  Future<bool> isStudentRegistered(String studentId);

  ///This is used to register an app user as a student
  Future<void> addUser(Student student);

  ///This is used to get a user by there ID.
  Future<Student?> getUserById(String studentId);

  ///This method is called when a user wants to update there courses
  Future<void> updateUser(Student student);

  ///Removing a user from the database
  Future<void> deleteUser(String studentId);
}
