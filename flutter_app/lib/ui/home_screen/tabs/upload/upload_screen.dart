import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/upload_pdf.dart';
import 'package:reviza/features/upload_pdf/view/components/course_search.dart';
import 'package:reviza/features/upload_pdf/view/components/platform_file_upload.dart';
import 'package:reviza/features/upload_pdf/view/components/upload_box.dart';
import 'package:reviza/utilities/cloud.dart';
import 'package:study_material_repository/study_material_repository.dart';

class UploadTypeScreen extends StatefulWidget {
  const UploadTypeScreen({super.key, required this.uid});
  final String uid;

  @override
  State<UploadTypeScreen> createState() => _UploadTypeScreenState();
}

class _UploadTypeScreenState extends State<UploadTypeScreen> {
  PlatformFile? _platformFile;
  Types? _type;

  int _currentStep = 0;

  String _selectedCourse = '';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 2 : 4;
    final padding = isMobile ? 20.0 : 40.0;
    // final fontSize = isMobile ? 24.0 : 32.0;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Stepper(
            physics: ClampingScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (value) => _currentStep = value,
            steps: [
              //step one, select course
              Step(
                title: Text('Select Course'),
                content: FutureBuilder(
                    future: fetchCurrentStudentOnline(widget.uid),
                    builder: (context, snapshot) {
                      return buildSearchableDropdown(
                          'Course', snapshot.data?.myCourses ?? [], (selected) {
                        _selectedCourse = selected;
                      });
                    }),
              ),
              Step(
                title: Text('Select Type'),
                content: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    _buildUploadTypeCard('NOTES', Icons.note, () {
                      setState(() {
                        _type = Types.notes;
                      });
                    }),
                    _buildUploadTypeCard('PAPERS', Icons.note, () {
                      setState(() {
                        _type = Types.papers;
                      });
                    }),
                    _buildUploadTypeCard('BOOKS', Icons.book, () {
                      setState(() {
                        _type = Types.books;
                      });
                    }),
                    _buildUploadTypeCard('LINKS', Icons.link, () {
                      setState(() {
                        _type = Types.links;
                      });
                    }),
                    _buildUploadTypeCard('ASS..', Icons.assessment, () {
                      setState(() {
                        _type = Types.assignment;
                      });
                    }),
                    _buildUploadTypeCard('LABS', Icons.troubleshoot, () {
                      setState(() {
                        _type = Types.lab;
                      });
                    }),
                  ],
                ),
              ),
              Step(
                title: Text('Select File'),
                content: _platformFile == null && _type != Types.links
                    ? UploadBox(
                        onTap: _getfile,
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected File:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SharingFileWidget(
                              onCancelShare: () {
                                setState(() {
                                  _platformFile = null;
                                });
                              },
                              platformFile: _platformFile!,
                            ),
                          ],
                        ),
                      ),
              ),
              Step(
                  title: Text('Annotate'),
                  content: UploadPdfPage(
                    uploadType: _type ?? Types.notes,
                    uid: widget.uid,
                    course: _selectedCourse,
                  ))
            ]),
      ),
    );
  }

  _getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );

    if (result != null) {
      _platformFile = result.files.first;
    }

    setState(() {});
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
            ],
          ),
        ),
      ),
    );
  }
}
