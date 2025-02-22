import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(
                  authenticationRepository.currentUser, true)
              : AppState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<ChangeTheme>(_onChangeTheme);
    on<_AppThemeChanged>(_onChangeThemezz);

    {
      _userSubscription = _authenticationRepository.user.listen(
        (user) {
          add(_AppUserChanged(user));
        },
      );

      _userTheme = _authenticationRepository.user.listen(
        (user) {
          add(_AppThemeChanged(user.theme));
        },
      );
    }
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<User> _userTheme;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user, state.theme)
          : AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<AppState> emit) async {
    bool newTheme = !state.theme;
    await _saveTheme(newTheme);
    emit(state.copyWith(theme: newTheme));
  }

  Future<void> _onChangeThemezz(
      _AppThemeChanged event, Emitter<AppState> emit) async {
    bool newTheme = event.isLight;
    await _saveTheme(newTheme);
    emit(state.copyWith(theme: newTheme));
  }

  Future<void> _saveTheme(bool isLightTheme) async {
    _authenticationRepository.updateTheme(isLight: isLightTheme);
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await _userTheme.cancel();
    await super.close();
  }
}
