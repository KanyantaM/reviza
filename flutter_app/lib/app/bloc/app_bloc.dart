import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reviza/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(
                  authenticationRepository.currentUser, ReviZaTheme.light)
              : AppState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<ChangeTheme>(_onChangeTheme);

    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );

    _initializeTheme();
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

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
    final newTheme = ReviZaTheme.toggleTheme(state.theme);
    emit(state.copyWith(theme: newTheme));
    await _saveTheme(newTheme);
  }

  Future<void> _saveTheme(ThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', theme == ReviZaTheme.dark);
  }

  Future<ThemeData> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;
    return isDark ? ReviZaTheme.dark : ReviZaTheme.light;
  }

  Future<void> _initializeTheme() async {
    final theme = await _loadTheme();
    add(ChangeTheme(theme: theme));
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await super.close();
  }
}
