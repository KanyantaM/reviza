import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isValid => email.isNotEmpty; // Ensure email is not empty

  @override
  List<Object?> get props => [email, status, errorMessage];
}
