import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/view/upload_pdf_view.dart';

class UploadPdfPage extends StatelessWidget {
  const UploadPdfPage({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  Widget build(BuildContext context) {
    return UploadPdfView(
      id: uid,
    );
  }
}
