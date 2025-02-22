import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/app/routes/routes.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/ui/theme.dart';
import 'package:study_material_repository/study_material_repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => UploadPdfBloc(
                studyMaterialRepo: StudyMaterialRepo(
                    uid: context
                        .read<AuthenticationRepository>()
                        .currentUser
                        .id)),
          ),
          BlocProvider(
              create: (context) => ViewMaterialBloc(
                  studyMaterial: StudyMaterialRepo(
                      uid: context
                          .read<AuthenticationRepository>()
                          .currentUser
                          .id)))
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // themeMode: ThemeMode.system,
          // darkTheme: ReviZaTheme.dark,
          theme: state.theme
              ? ReviZaTheme.light
              : ReviZaTheme.dark, // Access the theme from the AppState
          home: FlowBuilder<AppState>(
            state: state,
            onGeneratePages: onGenerateAppViewPages,
          ),
        );
      },
    );
  }
}
