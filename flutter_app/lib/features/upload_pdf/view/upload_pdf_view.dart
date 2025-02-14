import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/upload_pdf/view/components/document_upload.dart';
import 'package:reviza/features/upload_pdf/view/components/upload_snack_bar.dart';
import 'package:reviza/features/upload_pdf/view/utils/widget_selector.dart';
import 'package:reviza/utilities/cloud.dart';

import 'package:student_repository/student_repository.dart';
import 'package:study_material_repository/study_material_repository.dart';

class UploadPdfView extends StatefulWidget {
  final String id;
  final Types type;
  final String courseName;
  const UploadPdfView({
    super.key,
    required this.type,
    required this.id,
    required this.courseName,
  });

  @override
  State<UploadPdfView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<UploadPdfView>
    with SingleTickerProviderStateMixin {
  Student? _student;
  List<String> _myCourses = [];
  bool isuploaded = false;

  void getStudent() async {
    _student = await fetchCurrentStudentOnline(widget.id);
    setState(() {
      _myCourses = _student!.myCourses;
    });
  }

  @override
  void initState() {
    getStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UploadPdfBloc, UploadPdfState>(
        builder: ((context, state) {
          if (state is UploadingPdfState) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_myCourses.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: widgetSelector(
                widget.type,
                pp: PaperUploadForm(
                  courseName: widget.courseName,
                ),
                notes: DocumentUploadForm(
                  courseName: widget.courseName,
                ),
                ass: DocumentUploadForm(
                  courseName: widget.courseName,
                ),
                book: DocumentUploadForm(
                  courseName: widget.courseName,
                ),
                lab: DocumentUploadForm(
                  courseName: widget.courseName,
                ),
                link: LinkUploadForm(
                  courseName: widget.courseName,
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.orange),
                  SizedBox(height: 10),
                  Text(
                    'Please add your courses first!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        }),
        listener: (context, state) {
          if (state is UploadedPdfState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomSnackBar(
                errorText: 'File Uploaded',
                headingText: 'Success',
                color: const Color.fromARGB(255, 29, 164, 31),
                image: Image.asset(
                  'assets/icon/error_solid_green.png',
                  height: 35,
                  width: 35,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ));

            // add duration
            Future.delayed(const Duration(seconds: 3), () {});
            Navigator.pop(context);
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnackBar(
                  errorText: state.message,
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
        },
      ),
    );
  }
}
