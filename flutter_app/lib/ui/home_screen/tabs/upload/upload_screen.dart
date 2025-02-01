import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/upload_pdf.dart';
import 'package:reviza/misc/course_info.dart';

class UploadTypeScreen extends StatelessWidget {
  const UploadTypeScreen({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Select Upload Type',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildUploadTypeCard('NOTES', Icons.note, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (UploadPdfPage(
                          uploadType: Types.notes,
                          uid: uid,
                        )),
                      ),
                    );
                  }),
                  _buildUploadTypeCard('PAPERS', Icons.note, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (UploadPdfPage(
                          uploadType: Types.papers,
                          uid: uid,
                        )),
                      ),
                    );
                  }),
                  _buildUploadTypeCard('BOOKS', Icons.book, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (UploadPdfPage(
                          uploadType: Types.books,
                          uid: uid,
                        )),
                      ),
                    );
                  }),
                  _buildUploadTypeCard('LINKS', Icons.link, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (UploadPdfPage(
                          uploadType: Types.links,
                          uid: uid,
                        )),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTypeCard(
      String title, IconData icon, void Function() onTap) {
    return Card(
      child: InkWell(
        splashColor: Colors.purple.shade50,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 10),
              Icon(icon),
              const SizedBox(height: 10),
              const Text('>'),
            ],
          ),
        ),
      ),
    );
  }
}
