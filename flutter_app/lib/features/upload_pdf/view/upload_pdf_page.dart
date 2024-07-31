import 'package:cloud_storage_study_material_api/cloud_storage_study_material_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/upload_pdf/view/upload_pdf_view.dart';
import 'package:reviza/misc/course_info.dart';

class UploadPdfPage extends StatelessWidget {
  const UploadPdfPage({super.key, required this.uploadType, required this.uid});
  final Types uploadType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadPdfBloc(
        studentOnline: FirestoreStudyMaterialRepository(),
      ),
      child: UploadPdfView(type: uploadType,id: uid,),
    );
  }
}

