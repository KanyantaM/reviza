import 'package:student_repository/student_repository.dart';

Future<Student?> fetchCurrentStudentOnline(String userId) async {
  return await StudentRepository().getUserById(userId);
}
