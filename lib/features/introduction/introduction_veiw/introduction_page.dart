import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/features/introduction/introduction_bloc/bloc/introduction_bloc_bloc.dart';
import 'package:reviza/features/introduction/introduction_veiw/introduction_view.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key, required this.userId});
  final String userId;

  static Page<void> page(String uid) => MaterialPage<void>(child: IntroductionPage(userId: uid,));

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HiveUserRepository>(
          create: (context) => HiveUserRepository(),
        ),
        RepositoryProvider<FirestoreUserRepository>(
          create: (context) => FirestoreUserRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => IntroductionBloc(
          studentOffline: context.read<HiveUserRepository>(),
          studentOnline: context.read<FirestoreUserRepository>(),
        ),
        child: IntroductionView(studentId: userId,),
      ),
    );
  }
}
