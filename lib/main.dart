import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:reviza/app/bloc_observer.dart';
import 'package:reviza/app/view/app.dart';
import 'package:reviza/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  Gemini.init(apiKey: 'AIzaSyAc4B-fK2YSYVV9qG-HPzznQbpjlcmLkfw', enableDebugging: true);
  
  await HiveInitializer.initializeHive();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}
