// import 'package:hive/hive.dart';
import 'package:student_api/student_api.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveUserRepository implements UserRepository {
  late Box _box;
  bool _isInitialized = false;

  HiveUserRepository() {
    _initHive();
  }

  Future<void> _initHive() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(StudentAdapter());
      }
      _box = await Hive.openBox('users');
      _isInitialized = true;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initHive();
    }
  }

  @override
  Future<void> addUser(Student user) async {
    await _ensureInitialized();
    await _box.put(user.userId, user.toJson());
  }

  @override
  Future<Student?> getUserById(String userId) async {
    await _ensureInitialized();
    var json = _box.get(userId);
    return json != null ? Student.fromJson(json) : null;
  }

  @override
  Future<void> updateUser(Student user) async {
    await _ensureInitialized();
    await _box.put(user.userId, user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _ensureInitialized();
    await _box.delete(userId);
  }

  @override
  Future<bool> isStudentRegistered(String userId) async {
    await _ensureInitialized();
    var json = await _box.get(userId);
    return (json != null);
  }
}


class HiveInitializer {
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox('users');
    await Hive.openBox('study_materials');
  }
}

