import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/upload_pdf/view/components/upload_snack_bar.dart';
import 'package:reviza/features/upload_pdf/view/utils/type_description_generator.dart';
import 'package:reviza/utilities/dialogues/cannot_share_empty_not_dialog.dart';
import 'package:study_material_repository/study_material_repository.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({
    super.key,
    required this.file,
    required this.type,
    required this.course,
    this.isRangeSelected = false,
    this.startingYear,
    this.endingYear,
    this.category,
    this.startingUnit,
    this.endingUnit,
    this.author,
    this.linkUrl,
    this.title,
  });

  final File file;
  final bool isRangeSelected;
  final int? startingYear;
  final int? endingYear;
  final String? category;
  final double? startingUnit;
  final double? endingUnit;
  final String? author;
  final String? linkUrl;
  final Types type;
  final String course;
  final String? title;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool _uploading = false;
  File? _file;
  bool _isRangeSelected = false;
  int? _startingYear;
  int? _endingYear;
  String? _category;
  double? _startingUnit;
  double? _endingUnit;
  String? _author;
  String? _linkUrl;
  String? _course;
  Types _type = Types.notes;
  String? _title;

  @override
  void initState() {
    _file = widget.file;
    _isRangeSelected = widget.isRangeSelected;
    _endingYear = widget.startingYear;
    _startingYear = widget.endingYear;
    _category = widget.category;
    _startingUnit = widget.startingUnit;
    _endingUnit = widget.endingUnit;
    _author = widget.author;
    _linkUrl = widget.linkUrl;
    _course = widget.course;
    _type = widget.type;
    _title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: (29.7),
          width: (170.7),
          child: (_uploading)
              ? const Center(
                  child: Text(
                  'Uploading...',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ))
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).hoverColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular((20.86)),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _uploading = true;
                    });
                    await _uploadFile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: (9.86),
                      ),
                      Text(
                        "Upload Material",
                        style: TextStyle(
                          fontSize: (12.51),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  _uploadFile() async {
    if (_file != null &&
        ((_course?.isNotEmpty ?? (false)) || _type == Types.links)) {
      String normalizedPath = p.normalize(_file!.path);
      String pdfFileName = p.basename(normalizedPath);

      Map<String, String> typeDesc = typeDescriptionGenerator(
        type: widget.type,
        isRangeSelected: _isRangeSelected,
        startingYear: _startingYear,
        endingYear: _endingYear,
        category: _category,
        startingUnit: _startingUnit,
        endingUnit: _endingUnit,
        authorName: _author ?? '',
        url: _linkUrl,
      );

      context.read<UploadPdfBloc>().add(
            UploadPdf(
              subjectName: _course!,
              type: typeDesc['type']!,
              id: Uuid().v4(),
              title: _title ?? pdfFileName,
              description: typeDesc['desc']!,
              pdfFile: _file!,
            ),
          );
    } else if (_course!.isEmpty) {
      await showCannotShareEmptyNoteDialog(context);
    } else {
      _uploading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBar(
            errorText: 'No file selected',
            headingText: 'Oh Snap!',
            color: const Color(0xFFF75469),
            image: Image.asset('assets/icon/error_solid.png'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }
}
