import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Password must be at least 8 characters long.
  tooShort,

  /// Password must contain at least one letter.
  missingLetter,

  /// Password must contain at least one number.
  missingNumber
}

/// {@template password}
/// Form input for a password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  static final _letterRegExp = RegExp(r'[A-Za-z]');
  static final _numberRegExp = RegExp(r'\d');

  @override
  PasswordValidationError? validator(String? value) {
    final password = value ?? '';

    if (password.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!_letterRegExp.hasMatch(password)) {
      return PasswordValidationError.missingLetter;
    }
    if (!_numberRegExp.hasMatch(password)) {
      return PasswordValidationError.missingNumber;
    }

    return null;
  }
}
