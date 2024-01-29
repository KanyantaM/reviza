part of 'edit_my_courses_bloc.dart';

sealed class EditMyCoursesState extends Equatable {
  const EditMyCoursesState();
  
  @override
  List<Object> get props => [];
}

final class EditMyCoursesInitial extends EditMyCoursesState {}

final class FetchingCoursesState extends EditMyCoursesState{}

final class CoursesFetchedState extends EditMyCoursesState{
  final Student student;

  const CoursesFetchedState({required this.student});
}

// final class SavingEdits extends EditMyCoursesState{}

final class CoursesEditedSuccesfully extends EditMyCoursesState{}

final class DeletingCourses extends EditMyCoursesState {}

final class ErrorState extends EditMyCoursesState{
  final String message;

  const ErrorState({required this.message});
}