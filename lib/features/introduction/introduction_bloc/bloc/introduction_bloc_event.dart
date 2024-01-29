part of 'introduction_bloc_bloc.dart';

sealed class IntroductionEvent extends Equatable {
  const IntroductionEvent();

  @override
  List<Object> get props => [];
}

class CheckIntroductionStatus extends IntroductionEvent {
  final String studentId;

  const CheckIntroductionStatus({required this.studentId});
}

class RegisterStudent extends IntroductionEvent{
  final String studentId;
  final List<String> courses;

  const RegisterStudent({required this.studentId, required this.courses});
}