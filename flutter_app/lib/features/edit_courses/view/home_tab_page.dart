import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
import 'package:reviza/features/edit_courses/view/home_tab_view.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditMyCoursesBloc(
        studentOffline: context.read<HiveUserRepository>(),
        studentOnline: context.read<FirestoreUserRepository>(),
      ),
      child: HomeTabView(studentId: userId,),
    );
  }
}

