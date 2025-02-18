part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final User user;
}

final class _AppThemeChanged extends AppEvent {
  const _AppThemeChanged(this.isLight);

  final bool isLight;
}

class ChangeTheme extends AppEvent {
  final bool theme;

  ChangeTheme({required this.theme});
}
