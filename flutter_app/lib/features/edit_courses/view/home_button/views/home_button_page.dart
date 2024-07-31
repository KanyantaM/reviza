// import 'package:cloud_student_api/cloud_student_api.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_student_api/local_student_api.dart';
// import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
// import 'package:reviza/features/edit_courses/view/home_button/views/home_bottomsheet_view.dart';
// import 'package:student_api/student_api.dart';

// class HomeBottomSheetPage extends StatelessWidget {
//   const HomeBottomSheetPage({super.key, required this.userId});
//   final Student userId;
  

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EditMyCoursesBloc(studentOffline: HiveUserRepository(), studentOnline: FirestoreUserRepository()),
//       child: HomeBottomSheetView(student: userId,),
//     );
//   }
// }
