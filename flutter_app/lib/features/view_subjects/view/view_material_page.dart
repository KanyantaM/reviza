import 'package:flutter/material.dart';
import 'package:reviza/features/view_subjects/view/view_material_view.dart';

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
    return ViewMaterialsView(
      isDownloadedView: isDownloadedView,
      uid: uid,
      courseName: courseName,
    );
  }
}
