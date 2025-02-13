import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_repository/student_repository.dart';

part 'introduction_bloc_event.dart';
part 'introduction_bloc_state.dart';

class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  IntroductionBloc({
    required StudentRepository studentRepository,
  })  : _studentRepository = studentRepository,
        super(IntroductionInitial()) {
    on<CheckIntroductionStatus>((event, emit) async {
      try {
        emit(IntroductionCheckingStatus());
        bool registered =
            await _studentRepository.isStudentRegistered(event.studentId);

        if (registered) {
          emit(IntroductionIntroduced());
        } else {
          emit(IntroductionNotIntroduced());
        }
      } on Exception catch (e) {
        emit(IntroductionErrorState(message: 'Error:\n $e'));
      }
    });

    on<RegisterStudent>(
      (event, emit) async {
        emit(IntroductionRegisteringCourses());
        try {
          Student user =
              Student(userId: event.studentId, myCourses: event.courses);
          await _studentRepository.addUser(user);
          emit(IntroductionIntroduced());
        } catch (e) {
          emit(IntroductionErrorState(
              message: 'Failed to save your courses.\n $e'));
        }
      },
    );
  }

  final StudentRepository _studentRepository;
}
