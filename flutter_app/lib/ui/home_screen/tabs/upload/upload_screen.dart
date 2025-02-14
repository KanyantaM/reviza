import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reviza/features/upload_pdf/upload_pdf.dart';
import 'package:reviza/features/upload_pdf/view/components/course_search.dart';
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
  String _selectedCourse = '';
  List<Map<String, dynamic>> uploads = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildCourseSelector(),
          _buildTypeSelector(),
          _buildFileUploader(),
          _platformFile != null
              ? Column(
                  children: [
                    Text('Platform: '),
                    ListTile(
                      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(_platformFile!.name),
                      subtitle: Text("Ready to upload"),
                      trailing: IconButton(
                        icon: Icon(Icons.upload),
                        onPressed: () => _showAnnotationModal(_platformFile!),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          Text('Recent Uploads:'),
          _buildUploadList(),
        ],
      ),
    );
  }

  Widget _buildCourseSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: fetchCurrentStudentOnline(widget.uid),
        builder: (context, snapshot) {
          return buildSearchableDropdown(
              'Course', snapshot.data?.myCourses ?? [], (selected) {
            setState(() => _selectedCourse = selected);
          });
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    List<Map<String, dynamic>> types = [
      {'title': 'Notes', 'icon': Icons.note, 'type': Types.notes},
      {'title': 'Papers', 'icon': Icons.description, 'type': Types.papers},
      {'title': 'Books', 'icon': Icons.book, 'type': Types.books},
      {'title': 'Links', 'icon': Icons.link, 'type': Types.links},
      {
        'title': 'Assignments',
        'icon': Icons.assignment,
        'type': Types.assignment
      },
      {'title': 'Labs', 'icon': Icons.science, 'type': Types.lab},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((item) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => _type = item['type']),
              child: Column(
                children: [
                  Icon(item['icon'],
                      size: 40,
                      color: _type == item['type']
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).chipTheme.disabledColor),
                  Text(item['title']),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFileUploader() {
    return _type != Types.links ? UploadBox(onTap: _getFile) : SizedBox();
  }

  Widget _buildUploadList() {
    return Expanded(
      child: ListView.builder(
        itemCount: uploads.length,
        itemBuilder: (context, index) {
          final upload = uploads[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(upload['name']),
              subtitle: Text(
                  "Status: ${upload['status']} | Annotated: ${upload['annotated'] ? 'Yes' : 'No'}"),
              trailing: upload['status'] == 'Uploading'
                  ? CircularProgressIndicator()
                  : Icon(
                      upload['status'] == 'Success'
                          ? Icons.check_circle
                          : Icons.error,
                      color: upload['status'] == 'Success'
                          ? Colors.green
                          : Colors.red),
              onTap: () => _showAnnotationModal(upload),
            ),
          );
        },
      ),
    );
  }

  _getFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() => _platformFile = result.files.first);
    }
  }

  _uploadFile(bool annotated) {
    setState(() {
      uploads.add({
        'name': _platformFile!.name,
        'status': 'Uploading',
        'annotated': annotated
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        uploads.last['status'] = 'Success';
        _platformFile = null;
        _type = null;
      });
    });
  }

  void _showAnnotationModal(dynamic file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Annotate Document",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                SizedBox(
                  height: 350,
                  child: UploadPdfPage(
                      uploadType: _type ?? Types.notes,
                      uid: widget.uid,
                      course: _selectedCourse),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _uploadFile(false);
                        },
                        child: Text("Later")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _uploadFile(true);
                        },
                        child: Text("Save")),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
