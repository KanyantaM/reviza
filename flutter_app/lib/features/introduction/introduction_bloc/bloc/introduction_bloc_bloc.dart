import 'package:bloc/bloc.dart';
import 'package:cloud_student_api/cloud_student_api.dart';
import 'package:equatable/equatable.dart';
import 'package:local_student_api/local_student_api.dart';
import 'package:student_api/student_api.dart';

part 'introduction_bloc_event.dart';
part 'introduction_bloc_state.dart';

class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  IntroductionBloc(
      {required HiveUserRepository studentOffline,
      required FirestoreUserRepository studentOnline})
      : _studentOfflineDataRepository = studentOffline,
        _studentOnlineDataRepostitory = studentOnline,
        super(IntroductionInitial()) {
    on<CheckIntroductionStatus>((event, emit) async {
      try {
        emit(IntroductionCheckingStatus());
        bool registeredOnline = await _studentOfflineDataRepository
            .isStudentRegistered(event.studentId);
        bool registeredOffline = await _studentOnlineDataRepostitory
            .isStudentRegistered(event.studentId);
        if (registeredOffline || registeredOnline) {
          emit(IntroductionIntroduced());
        } else {
          emit(IntroductionNotIntroduced());
        }
      } on Exception catch (e) {
        emit(IntroductionErrorState(message: 'Error:\n $e'));
      }
    });

    on<RegisterStudent>((event, emit) async{
      emit(IntroductionRegisteringCourses());
      try {
        Student user = Student(userId: event.studentId, myCourses: event.courses);
        await _studentOfflineDataRepository.addUser(user);
        await _studentOnlineDataRepostitory.addUser(user);
        emit(IntroductionIntroduced());
      } catch (e) {
        emit(IntroductionErrorState(message: 'Failed to save your courses.\n $e'));
      }
    },);
  }

  final HiveUserRepository _studentOfflineDataRepository;
  final FirestoreUserRepository _studentOnlineDataRepostitory;
}
