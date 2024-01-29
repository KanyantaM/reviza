part of 'introduction_bloc_bloc.dart';

sealed class IntroductionState extends Equatable {
  const IntroductionState();
  
  @override
  List<Object> get props => [];
}

final class IntroductionInitial extends IntroductionState {}

final class IntroductionNotIntroduced extends IntroductionState{}

final class IntroductionIntroduced extends IntroductionState{}

final class IntroductionCheckingStatus extends IntroductionState{}

final class IntroductionRegisteringCourses extends IntroductionState{}


final class IntroductionErrorState extends IntroductionState{
  final String message;

  const IntroductionErrorState({required this.message});
}