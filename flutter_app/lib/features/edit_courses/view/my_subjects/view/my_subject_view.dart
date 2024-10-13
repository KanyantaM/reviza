import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/edit_courses/bloc/edit_my_courses_bloc.dart';
import 'package:reviza/widgets/subject_listile.dart';
import 'package:student_api/student_api.dart';

class MySubjectsView extends StatefulWidget {
  final Student student;
  const MySubjectsView({super.key, required this.student});

  @override
  State<MySubjectsView> createState() => _MySubjectState();
}

List<String> _subjectsToDelete = [];

class _MySubjectState extends State<MySubjectsView> {
  bool isEditSubjects = false;

  _updateisEditSubjects() {
    setState(() {
      isEditSubjects = !isEditSubjects;
      _subjectsToDelete = [];
    });
  }

  @override
  void initState() {
    isEditSubjects = false;
    _subjectsToDelete = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mySubjectsList(context, widget.student.myCourses, widget.student);
  }

  Column _mySubjectsList(
      BuildContext context, List<String> courses, Student student) {
    return Column(
      // shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: BannerCarousel(
            banners: <BannerModel>[
              BannerModel(
                  id: 'image1', imagePath: 'assets/images/intro/fatimah.jpg')
            ],
            customizedIndicators: const IndicatorModel.animation(
                width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
            height: 120,
            activeColor: Theme.of(context).splashColor,
            disableColor: Theme.of(context).splashColor.withAlpha(50),
            animation: true,
            borderRadius: 10,
            width: 250,
            indicatorBottom: false,
          ),
        ),
        isEditSubjects
            ? _subjectsHeading(
                IconButton(
                  onPressed: () {
                    _updateisEditSubjects();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
                '${_subjectsToDelete.length} Selected',
                IconButton(
                  onPressed: () {
                    context.read<EditMyCoursesBloc>().add(DeleteCourses(
                        student: student, coursesToDelete: _subjectsToDelete));
                    setState(() {
                      isEditSubjects = false;
                    });

                    // customDeleteDialogue(context, _subjectsToDelete, student);
                  },
                  icon: const Icon(Icons.delete),
                ),
              )
            : _subjectsHeading(
                null,
                'My Subjects',
                IconButton(
                  onPressed: () {
                    _updateisEditSubjects();
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
        ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return isEditSubjects
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_subjectsToDelete.contains(courses[index])) {
                          _subjectsToDelete.remove(courses[index]);
                        } else {
                          _subjectsToDelete.add(courses[index]);
                        }
                      });
                    },
                    child: SubjectListTile(
                      isDelete: isEditSubjects,
                      subject: courses[index],
                      isSelected: _subjectsToDelete.contains(courses[index]),
                      uid: student.userId,
                    ))
                : SubjectListTile(
                    isDelete: isEditSubjects,
                    subject: courses[index],
                    isSelected: true,
                    uid: student.userId,
                  );
          },
        ),
      ],
    );
  }

  Row _subjectsHeading(
    IconButton? frontButton,
    String title,
    IconButton endButton,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 15), child: frontButton),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '\t ${title.split(':').first}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  // color: Colors.white
                ),
              ),
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(right: 15), child: endButton),
      ],
    );
  }
}
