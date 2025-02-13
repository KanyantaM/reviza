import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/upload_pdf.dart';
import 'package:study_material_repository/study_material_repository.dart';

class UploadTypeScreen extends StatelessWidget {
  const UploadTypeScreen({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 2 : 4;
    final padding = isMobile ? 20.0 : 40.0;
    final fontSize = isMobile ? 24.0 : 32.0;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Text(
              'Select Upload Type',
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // const Text('>', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
