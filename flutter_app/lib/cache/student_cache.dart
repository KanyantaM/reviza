import 'package:chat_repository/chat_repository.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:student_repository/student_repository.dart';
import 'package:study_material_repository/study_material_repository.dart';

class StudentCache {
  static String _studentId = '';

  static List<String> _courses = [];
  static List<Future<void>> uploadTasks = [];
  static Map<String, List<StudyMaterial>> _cloudMaterial = {};
  static Map<String, List<StudyMaterial>> _localMaterial = {};
  static List<Uploads> _unseenUploads = [];
  static List<Uploads> _seenUploads = [];
  static List<ChatRoom> _chatRooms = [];

  static Future<void> initCache({required String uid}) async {
    _studentId = uid;
    Student? student = await StudentRepository().getUserById(_studentId);
    _courses = student?.myCourses ?? [];
    _localMaterial = await StudyMaterialRepo(uid: _studentId).fetchDownloads();
    _chatRooms = await ChatRepository(
      localChat: HiveImplementation(),
      onlineChat: FirestoreImplementation(),
    ).fetchAllChatRooms(uid);
  }

  static List<Uploads> get unseenUploads => _unseenUploads;

  static List<Uploads> get seenUploads => _seenUploads;

  static List<String> get courses => _courses;

  static void setUnseenUploads(List<Uploads> uploads) =>
      _unseenUploads = uploads;

  static void setCourses(List<String> newList) => _courses = newList;

  static void updateLocaldownlods(Map<String, List<StudyMaterial>> update) =>
      _localMaterial = update;

  static void updateLocalMaterial(Map<String, List<StudyMaterial>> update) =>
      _localMaterial = update;

  static void updateCloudMaterial(Map<String, List<StudyMaterial>> update) =>
      _cloudMaterial = update;

  static Student get tempStudent =>
      Student(userId: _studentId, myCourses: _courses);

  static void setSeenUploads(List<Uploads> completedUploads) {
    _seenUploads = completedUploads;
  }

  static List<ChatRoom> get chatRooms => _chatRooms;
}
