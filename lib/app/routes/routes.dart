import 'package:flutter/widgets.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/features/introduction/introduction.dart';
import 'package:reviza/features/login/view/login_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  // String uid,
  AppState state,
  List<Page<dynamic>> pages,
) {
  switch (state.status) {
    case AppStatus.authenticated:
      return [IntroductionPage.page(state.user.id)];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
