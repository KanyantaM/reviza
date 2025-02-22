import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:study_material_repository/study_material_repository.dart';

class AnnotatioButton extends StatelessWidget {
  const AnnotatioButton(
      {super.key,
      required this.selectedCourse,
      this.upload,
      required this.type,
      required this.materialId,
      this.isRangeSelected = false,
      this.startingYear,
      this.endingYear,
      this.category,
      this.startingUnit,
      this.endingUnit,
      this.authorName,
      this.title});
  final String selectedCourse;
  final Uploads? upload;
  final Types type;
  final String materialId;

  final bool isRangeSelected;

  final int? startingYear;

  final int? endingYear;

  final String? category;

  final double? startingUnit;

  final double? endingUnit;

  final String? authorName;

//   url: _linkUrl,

  /// the title
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Later")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UploadPdfBloc>().add(Annotate(
                  type: type,
                  isRangeSelected: isRangeSelected,
                  startingYear: startingYear,
                  endingYear: endingYear,
                  category: category,
                  startingUnit: startingUnit,
                  endingUnit: endingUnit,
                  authorName: authorName,
                  materialId: materialId,
                  title: title,
                  course: selectedCourse));
            },
            child: const Text("Save")),
      ],
    );
  }
}
