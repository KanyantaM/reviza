import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reviza/app/bloc_observer.dart';
import 'package:reviza/app/services/notifications_service.dart';
import 'package:reviza/app/view/app.dart';
import 'package:reviza/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  NotificationService.initialize();

  runApp(App(authenticationRepository: authenticationRepository));
}
