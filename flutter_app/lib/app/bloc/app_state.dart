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

  AppState.authenticated(User user, bool theme)
      : this._(status: AppStatus.authenticated, user: user, theme: user.theme);

  const AppState.unauthenticated()
      : this._(status: AppStatus.unauthenticated, theme: true);

  final AppStatus status;
  final User user;
  final bool theme;

  @override
  List<Object> get props => [status, user, theme];

  AppState copyWith({
    User? user,
    bool? theme,
  }) {
    return AppState._(
      status: status,
      user: user ?? this.user,
      theme: theme ?? this.theme,
    );
  }
}
