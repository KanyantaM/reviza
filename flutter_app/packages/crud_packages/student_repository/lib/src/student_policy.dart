import 'package:student_api/student_api.dart';

/// Cached-first repository pattern for fetching and updating student data.
class StudentRepository {
  final StudentApi _onlineImplementation = FiresbaseOnlineStudent();
  final StudentApi _cachedImplementation = HiveCachedStudentApi();

  /// Check if a student is registered using local cache first, then online.
  Future<bool> isStudentRegistered(String studentId) async {
    bool isRegistered =
        await _cachedImplementation.isStudentRegistered(studentId);
    if (!isRegistered) {
      isRegistered = await _onlineImplementation.isStudentRegistered(studentId);
    }
    return isRegistered;
  }

  /// Add a student to both local cache and online database.
  Future<void> addUser(Student student) async {
    await _onlineImplementation.addUser(student);
    await _cachedImplementation.addUser(student);
  }

  /// Fetch user by ID. Checks cache first, then falls back to online API.
  Future<Student?> getUserById(String studentId) async {
    Student? student = await _cachedImplementation.getUserById(studentId);
    if (student == null) {
      student = await _onlineImplementation.getUserById(studentId);
      if (student != null) {
        await _cachedImplementation.addUser(student); // Cache the student
      }
    }
    return student;
  }

  /// Update user details in both local and online storage.
  Future<void> updateUser(Student student) async {
    await _onlineImplementation.updateUser(student);
    await _cachedImplementation.updateUser(student);
  }

  /// Delete user from both online and cached storage.
  Future<void> deleteUser(String studentId) async {
    await _onlineImplementation.deleteUser(studentId);
    await _cachedImplementation.deleteUser(studentId);
  }
}
