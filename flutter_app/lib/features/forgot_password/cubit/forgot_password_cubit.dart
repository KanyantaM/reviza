import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:reviza/features/forgot_password/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthenticationRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      : super(const ForgotPasswordState());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, errorMessage: null));
  }

  Future<void> resetPassword() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.sendPasswordResetEmail(email: state.email);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Failed to reset password. Please try again.',
        ),
      );
    }
  }
}
