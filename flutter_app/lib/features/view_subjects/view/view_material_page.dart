import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/view_subjects/view/view_material_view.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:study_material_repository/study_material_repository.dart';

class ViewMaterialPage extends StatelessWidget {
  const ViewMaterialPage(
      {super.key,
      required this.isDownloadedView,
      required this.uid,
      this.courseName});
  final bool isDownloadedView;
  final String uid;
  final String? courseName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ViewMaterialBloc(studyMaterial: StudyMaterialRepo(uid: uid)),
      child: ViewMaterialsView(
        isDownloadedView: isDownloadedView,
        uid: uid,
        courseName: courseName,
      ),
    );
  }
}
