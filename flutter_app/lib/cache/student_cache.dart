import 'dart:collection';
import 'package:chat_repository/chat_repository.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:student_repository/student_repository.dart';
import 'package:study_material_repository/study_material_repository.dart';

class StudentCache {
  static String _studentId = '';

  static List<String> _courses = [];
  static List<Future<void>> uploadTasks = [];
  static final Map<String, List<StudyMaterial>> _cloudMaterial = {};
  static Map<String, List<StudyMaterial>> _localMaterial = {};
  static List<Uploads> _unseenUploads = [];
  static List<Uploads> _seenUploads = [];
  static List<StudyMaterial> currentDownload = [];
  static List<Future<void>> currentDownloadTasks = [];
  static List<ChatRoom> _chatRooms = [];
  static final List<Future<void>> _notifications = [];
  static Student? _student;

  static Future<void> initCache({required String uid}) async {
    _studentId = uid;
    _student = await StudentRepository().getUserById(_studentId);
    _courses = _student?.myCourses ?? []; // Ensure _courses is never null
    _localMaterial = await StudyMaterialRepo(uid: _studentId).fetchDownloads();

    _chatRooms = await ChatRepository(
      localChat: HiveImplementation(),
      onlineChat: FirestoreImplementation(),
    ).fetchAllChatRooms(uid);
  }

  /// Getters for read-only access
  static List<Uploads> get unseenUploads => _unseenUploads;
  static List<Uploads> get seenUploads => _seenUploads;
  static UnmodifiableListView<String> get courses =>
      UnmodifiableListView(_courses);
  static Student get tempStudent =>
      _student ??
      Student(
          userId: _studentId,
          myCourses: _courses,
          uploadCount: 0,
          downloadCount: 0,
          badUploadCount: 0);
  static List<ChatRoom> get chatRooms => _chatRooms;
  static UnmodifiableListView<Future<void>> get notifications =>
      UnmodifiableListView(_notifications);
  static Map<String, List<StudyMaterial>> get localStudyMaterial =>
      _localMaterial;
  static Map<String, List<StudyMaterial>> get cloudStudyMaterial =>
      _cloudMaterial;

  /// Methods to update cache
  static void updateCloudStudyMaterial(
      String course, List<StudyMaterial> materials) {
    _cloudMaterial[course] = materials;
  }

  static void setUnseenUploads(List<Uploads> uploads) =>
      _unseenUploads = uploads;

  static void setCourses(List<String> newList) => _courses = newList;

  static void addCourse(String course) => _courses.add(course);

  static void updateCourseLocalMaterial(
      {required String course, required List<StudyMaterial> materials}) {
    _localMaterial[course] = materials;
  }

  static void updateCourseCloudMaterial(
      {required String course, required List<StudyMaterial> materials}) {
    _cloudMaterial[course] = materials;
  }

  static void updateLocalMaterial(Map<String, List<StudyMaterial>> update) =>
      _localMaterial = update;
  static void setSeenUploads(List<Uploads> completedUploads) =>
      _seenUploads = completedUploads;
  static void addNotifications(Future<void> localNotification) =>
      _notifications.add(localNotification);
}
