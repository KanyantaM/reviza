import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
import 'package:reviza/features/edit_courses/view/my_subjects/view/my_subject_view.dart';
import 'package:student_repository/student_repository.dart';

class MySubjectsPage extends StatelessWidget {
  const MySubjectsPage({super.key, required this.userId});
  final Student userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMyCoursesBloc(repo: StudentRepository()),
      child: MySubjectsView(
        student: userId,
      ),
    );
  }
}
