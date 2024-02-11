import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:equatable/equatable.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_api/student_api.dart';

part 'edit_my_courses_event.dart';
part 'edit_my_courses_state.dart';

class EditMyCoursesBloc extends Bloc<EditMyCoursesEvent, EditMyCoursesState> {
  EditMyCoursesBloc(
      {required HiveUserRepository studentOffline,
      required FirestoreUserRepository studentOnline})
      : _studentOfflineDataRepository = studentOffline,
        _studentOnlineDataRepository = studentOnline,
        super(EditMyCoursesInitial()) {
    on<FetchMyCourses>((event, emit) async {
      emit(FetchingCoursesState());
      try {
        Student
            currentStudent = /*await _studentOfflineDataRepository.getUserById(event.studentId) ??*/
            Student(userId: event.studentId, myCourses: []);
        //  if (currentStudent.myCourses.isEmpty) {
        currentStudent =
            await _studentOnlineDataRepository.getUserById(event.studentId) ??
                Student(userId: event.studentId, myCourses: []);
        //  }
        emit(CoursesFetchedState(student: currentStudent));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch user messages\n $e'));
      }
    });

    on<DeleteCourses>(
      (event, emit) async {
        emit(DeletingCourses());
        try {
          for (var courseToDelete in event.coursesToDelete) {
            event.student.myCourses.remove(courseToDelete);
            final dir = await getApplicationDocumentsDirectory();
            if (await File("${dir.path}/$courseToDelete/").exists()) {
              File("${dir.path}/$courseToDelete/").delete(recursive: true);
            }
          }
          await _studentOfflineDataRepository.updateUser(event.student);
          await _studentOnlineDataRepository.updateUser(event.student);
          emit(CoursesEditedSuccesfully());
          emit(CoursesFetchedState(student: event.student));
        } catch (e) {
          emit(ErrorState(message: 'Error deleting subjects\n $e'));
        }
      },
    );

    on<AddMyCourse>(
      (event, emit) async {
        try {
          for (var course in event.courses) {
            if (!event.student.myCourses.contains(course)) {
              event.student.myCourses.add(course);
            }
          }
          await _studentOfflineDataRepository.updateUser(event.student);
          await _studentOnlineDataRepository.updateUser(event.student);
          emit(EditMyCoursesInitial());
        } catch (e) {
          emit(ErrorState(message: 'Failed to add ${event.courses}\n $e'));
        }
      },
    );
  }

  final HiveUserRepository _studentOfflineDataRepository;
  final FirestoreUserRepository _studentOnlineDataRepository;
}
