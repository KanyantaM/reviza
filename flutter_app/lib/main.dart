import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:local_storage_study_material_api/local_storage_study_material_api.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/app/bloc_observer.dart';
import 'package:reviza/app/view/app.dart';
import 'package:reviza/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  final String apiKey = dotenv.env['GEMINI_API_KEY']!;
  Gemini.init(apiKey: apiKey, enableDebugging: true);

  HiveUserRepository();
  HiveStudyMaterialRepository();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}
