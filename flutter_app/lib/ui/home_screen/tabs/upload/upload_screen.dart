import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:polar_tab_bar/models/polar_tab_item.dart';
import 'package:polar_tab_bar/polar_tab_bar.dart';
import 'package:polar_tab_bar/widgets/polar_tab_page.dart';
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
  final List<Map<String, dynamic>> _uploads = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PolarTabItem> tabs = [
      PolarTabItem(
        index: 0,
        title: "Upload",
        page: PolarTabPage(
          child: _uploadView(),
        ),
      ),
      PolarTabItem(
        index: 1,
        title: "History",
        page: PolarTabPage(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Recent Uploads:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: _buildUploadList()),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PolarTabBar(
            background: Theme.of(context).cardColor,
            type: PolarTabType.pill, // Default Type
            tabs: tabs),
      ),
    );
  }

  Widget _uploadView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _buildCourseSelector(),
              if (_selectedCourse.isNotEmpty) _buildTypeSelector(),
            ],
          ),
          if (_type == null)
            Column(
              children: [
                Image.asset(
                  'assets/images/upload.png',
                  height: 200,
                ),
                Text(
                  'Please select a course and material type',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
          else if (_platformFile == null)
            _buildFileUploader()
          else
            _buildFilePreview(),
          SizedBox.shrink(),
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
            setState(() {
              _selectedCourse = selected;
            });
          });
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    final types = [
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: types.map((item) {
            final bool isSelected = _type == item['type'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: InkWell(
                onTap: () => setState(() => _type = item['type'] as Types?),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.withAlpha(100)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        item['icon'] as IconData?,
                        size: 36,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFileUploader() {
    return _type != Types.links
        ? UploadBox(onTap: _pickFile)
        : const SizedBox();
  }

  Widget _buildFilePreview() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected File:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading:
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
              title: Text(
                _platformFile!.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  const Text("Ready to upload",
                      style: TextStyle(color: Colors.green)),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.cloud_upload, color: Colors.blue),
                onPressed: () => _showAnnotationModal(_platformFile!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadList() {
    return (_uploads.isNotEmpty)
        ? ListView.builder(
            itemCount: _uploads.length,
            itemBuilder: (context, index) {
              final upload = _uploads[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(upload['name']),
                  subtitle: Text(
                      "Status: ${upload['status']} | Annotated: ${upload['annotated'] ? 'Yes' : 'No'}"),
                  trailing: upload['status'] == 'Uploading'
                      ? const CircularProgressIndicator()
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
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_folder.png',
                  height: 200,
                ),
                Text('You have\'t uploaded any material')
              ],
            ),
          );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() => _platformFile = result.files.first);
    }
  }

  void _uploadFile(bool annotated) {
    setState(() {
      _uploads.add({
        'name': _platformFile!.name,
        'status': 'Uploading',
        'annotated': annotated
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _uploads.last['status'] = 'Success';
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Annotate Document",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 350,
                child: UploadPdfPage(
                    uploadType: _type ?? Types.notes,
                    uid: widget.uid,
                    course: _selectedCourse),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _uploadFile(false);
                      },
                      child: const Text("Later")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _uploadFile(true);
                      },
                      child: const Text("Save")),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
