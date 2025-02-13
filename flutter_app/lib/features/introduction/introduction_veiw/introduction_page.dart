import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/introduction/introduction_bloc/bloc/introduction_bloc_bloc.dart';
import 'package:reviza/features/introduction/introduction_veiw/introduction_view.dart';
import 'package:student_repository/student_repository.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key, required this.userId});
  final String userId;

  static Page<void> page(String uid) => MaterialPage<void>(
          child: IntroductionPage(
        userId: uid,
      ));

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StudentRepository>(
      create: (context) => StudentRepository(),
      child: BlocProvider(
        create: (context) => IntroductionBloc(
          studentRepository: context.read<StudentRepository>(),
        ),
        child: IntroductionView(
          studentId: userId,
        ),
      ),
    );
  }
}
