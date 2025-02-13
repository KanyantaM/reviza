import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_repository/student_repository.dart';
import 'package:study_material_repository/study_material_repository.dart';

part 'edit_my_courses_event.dart';
part 'edit_my_courses_state.dart';

class EditMyCoursesBloc extends Bloc<EditMyCoursesEvent, EditMyCoursesState> {
  EditMyCoursesBloc({
    required StudentRepository repo,
  })  : _studentRepository = repo,
        super(EditMyCoursesInitial()) {
    on<FetchMyCourses>((event, emit) async {
      emit(FetchingCoursesState());

      try {
        Student currentStudent =
            await _studentRepository.getUserById(event.studentId) ??
                Student(userId: event.studentId, myCourses: <String>[]);

        emit(CoursesFetchedState(student: currentStudent));
      } catch (e) {
        emit(ErrorState(message: 'Failed to fetch user messages\n $e'));
      }
    });

    on<DeleteCourses>(
      (event, emit) async {
        emit(DeletingCourses());
        try {
          for (String course in event.coursesToDelete) {
            event.student.myCourses.remove(course);
            StudyMaterialRepo(uid: event.student.userId)
                .deleteLocalCourseMaterial(courseId: course);
          }
          await _studentRepository.updateUser(event.student);
          emit(CoursesEditedSuccesfully());
          emit(CoursesFetchedState(student: event.student));
        } catch (e) {
          emit(ErrorState(message: 'Error deleting subjects\n $e'));
        }
      },
    );

    on<AddMyCourse>(
      (event, emit) async {
        try {
          for (var course in event.courses) {
            if (!event.student.myCourses.contains(course)) {
              event.student.myCourses.add(course);
            }
          }
          await _studentRepository.updateUser(event.student);
          emit(EditMyCoursesInitial());
        } catch (e) {
          emit(ErrorState(message: 'Failed to add ${event.courses}\n $e'));
        }
      },
    );
  }

  final StudentRepository _studentRepository;
}
