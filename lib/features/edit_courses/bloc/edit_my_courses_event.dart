part of 'edit_my_courses_bloc.dart';

sealed class EditMyCoursesEvent extends Equatable {
  const EditMyCoursesEvent();

  @override
  List<Object> get props => [];
}

class FetchMyCourses extends EditMyCoursesEvent {
  final String studentId;

  const FetchMyCourses({required this.studentId});
}

class DeleteCourses extends EditMyCoursesEvent{
  final Student student;
  final List<String> coursesToDelete;

  const DeleteCourses({required this.student, required this.coursesToDelete});
}

class AddMyCourse extends EditMyCoursesEvent{
  final Student student;
  final List<String> courses;

  const AddMyCourse({required this.student, required this.courses});
}