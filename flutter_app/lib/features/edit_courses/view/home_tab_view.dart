import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
import 'package:reviza/features/edit_courses/view/home_button/views/home_bottomsheet_view.dart';

import 'my_subjects/view/my_subject_page.dart';

class HomeTabView extends StatelessWidget {
  final String studentId;

  const HomeTabView({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    EditMyCoursesBloc widgetBloc = context.read<EditMyCoursesBloc>();
    return BlocConsumer<EditMyCoursesBloc, EditMyCoursesState>(
      listener: (context, state) {
        if (state is CoursesEditedSuccesfully) {
          _showSuccessSnackbar(context, 'Courses edited successfully');
        } else if (state is ErrorState) {
          _showErrorDialog(context, state.message);
        } else if (state is DeletingCourses) {
          _showLoadingIndicator(context);
          widgetBloc.add(FetchMyCourses(studentId: studentId));
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Scaffold.of(context).showBottomSheet(
                (context) {
                  return HomeBottomSheetView(
                    student: StudentCache.tempStudent,
                    onSave: (selectedCourses) {
                      for (var course in selectedCourses) {
                        if (!StudentCache.courses.contains(course)) {
                          StudentCache.courses.add(course);
                        }
                      }
                      widgetBloc.add(AddMyCourse(
                          student: StudentCache.tempStudent,
                          courses: StudentCache.courses));
                    },
                  );
                },
                // isScrollControlled: true,
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          body: _buildBody(state, context),
        );
      },
    );
  }

  Widget _buildBody(EditMyCoursesState state, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        MySubjectsPage(
          userId: StudentCache.tempStudent,
        ),
      ],
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text('Deleting Courses...'),
            ],
          ),
        );
      },
    );
  }
}
