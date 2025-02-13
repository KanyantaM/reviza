import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
import 'package:reviza/features/edit_courses/view/home_tab_view.dart';
import 'package:student_repository/student_repository.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditMyCoursesBloc(repo: StudentRepository()),
      child: HomeTabView(
        studentId: userId,
      ),
    );
  }
}
