import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/upload_pdf/view/upload_pdf_view.dart';
import 'package:study_material_repository/study_material_repository.dart';

class UploadPdfPage extends StatelessWidget {
  const UploadPdfPage({super.key, required this.uploadType, required this.uid});
  final Types uploadType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadPdfBloc(
        studyMaterialRepo: StudyMaterialRepo(uid: uid),
      ),
      child: UploadPdfView(
        type: uploadType,
        id: uid,
      ),
    );
  }
}
