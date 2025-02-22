import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/introduction/introduction.dart';
import 'package:reviza/features/login/view/login_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  // String uid,
  AppState state,
  List<Page<dynamic>> pages,
) {
  switch (state.status) {
    case AppStatus.authenticated:
      StudentCache.initCache(uid: state.user.id);
      FlutterNativeSplash.remove();
      return [IntroductionPage.page(state.user.id)];
    case AppStatus.unauthenticated:
      FlutterNativeSplash.remove();
      return [LoginPage.page()];
  }
}
