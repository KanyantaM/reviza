import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/app/routes/routes.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return RepositoryProvider.value(
          value: _authenticationRepository,
          child: BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
            child: const AppView(),
          ),
        );
      }
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.theme, // Access the theme from the AppState
          home: FlowBuilder<AppState>(
            state: state,
            onGeneratePages: onGenerateAppViewPages,
          ),
        );
      },
    );
  }
}

