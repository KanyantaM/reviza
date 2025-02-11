import 'package:student_api/student_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCachedStudentApi implements StudentApi {
  Box? _box; // Nullable to prevent premature access
  bool _isInitialized = false;

  HiveCachedStudentApi() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(StudentAdapter());
    }

    _box = await Hive.openBox('users');
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initHive();
    }
  }

  @override
  Future<void> addUser(Student user) async {
    await _ensureInitialized();
    await _box?.put(user.userId, user);
  }

  @override
  Future<Student?> getUserById(String userId) async {
    await _ensureInitialized();
    return _box?.get(userId);
  }

  @override
  Future<void> updateUser(Student user) async {
    await _ensureInitialized();
    await _box?.put(user.userId, user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _ensureInitialized();
    await _box?.delete(userId);
  }

  @override
  Future<bool> isStudentRegistered(String userId) async {
    await _ensureInitialized();
    return _box?.containsKey(userId) ?? false;
  }
}
