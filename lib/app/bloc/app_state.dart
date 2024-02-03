part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    required this.theme,
  });

  const AppState.authenticated(User user, ThemeData theme)
      : this._(status: AppStatus.authenticated, user: user, theme: theme);

  AppState.unauthenticated()
      : this._(status: AppStatus.unauthenticated, theme: ReviZaTheme.light);

  final AppStatus status;
  final User user;
  final ThemeData theme;

  @override
  List<Object> get props => [status, user, theme];

  AppState copyWith({
    User? user,
    ThemeData? theme,
  }) {
    return AppState._(
      status: status,
      user: user ?? this.user,
      theme: theme ?? this.theme,
    );
  }
}
