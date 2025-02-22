// import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polar_tab_bar/models/polar_tab_item.dart';
import 'package:polar_tab_bar/polar_tab_bar.dart';
import 'package:polar_tab_bar/widgets/polar_tab_page.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/upload_pdf/view/components/course_search.dart';
import 'package:reviza/features/upload_pdf/view/components/document_upload.dart';
import 'package:reviza/features/upload_pdf/view/components/upload_box.dart';
import 'package:reviza/features/upload_pdf/view/components/upload_type_selector.dart';
import 'package:reviza/features/upload_pdf/view/utils/widget_selector.dart';
import 'package:study_material_repository/study_material_repository.dart';
import 'package:uuid/uuid.dart';

class UploadPdfView extends StatefulWidget {
  final String id;
  const UploadPdfView({
    super.key,
    required this.id,
  });

  @override
  State<UploadPdfView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<UploadPdfView>
    with SingleTickerProviderStateMixin {
  List<String> _myCourses = [];
  bool isuploaded = false;
  PlatformFile? _platformFile;
  Types? _type;
  String _selectedCourse = '';
  String _materialId = Uuid().v4();
  List<Uploads> _currentUploads = <Uploads>[];

  void _updateCache(Uploads newUpload) {
    if (!_currentUploads.contains(newUpload)) {
      _currentUploads = StudentCache.unseenUploads;
      setState(() {
        _currentUploads.add(newUpload);
        StudentCache.setUnseenUploads(_currentUploads);
      });
    }
  }

  @override
  void initState() {
    _myCourses = StudentCache.courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<UploadPdfBloc, UploadPdfState>(
        builder: ((context, state) {
          if (_myCourses.isNotEmpty) {
            final List<PolarTabItem> tabs = [
              PolarTabItem(
                index: 0,
                title: "Upload",
                page: PolarTabPage(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          _buildCourseSelector(),
                          if (_selectedCourse.isNotEmpty)
                            UploadTypeSelector(
                                selectedType: _type,
                                onTypeSelected: (type) {
                                  setState(() {
                                    _type = type as Types?;
                                    // log(_type!.name);
                                  });
                                }),
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
                            ),
                          ],
                        ),
                      if (_type != null) _buildFileUploader(context),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Selected File:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (StudentCache.unseenUploads
                                  .map((upload) => upload.status)
                                  .toList()
                                  .contains(null))
                                ElevatedButton.icon(
                                  label: Text('Upload'),
                                  icon: const Icon(Icons.cloud_upload,
                                      color: Colors.blue),
                                  onPressed: () {
                                    context.read<UploadPdfBloc>().add(UploadPdf(
                                        uploads: List<Uploads>.from(
                                            StudentCache.unseenUploads)));
                                    setState(() {
                                      _platformFile = null;
                                    });
                                    // _annotateBottomSheet(context, null);
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: StudentCache.unseenUploads.length,
                          itemBuilder: (context, index) {
                            if (StudentCache.unseenUploads.isNotEmpty) {
                              final upload = StudentCache.unseenUploads.reversed
                                  .toList()[index];
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      elevation: 4,
                                      child: ListTile(
                                        leading: const Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.red,
                                            size: 32),
                                        title: Text(
                                          upload.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: upload.status == null
                                            ? Row(
                                                children: [
                                                  const Text("Ready to upload",
                                                      style: TextStyle(
                                                          color: Colors.green)),
                                                  const SizedBox(width: 8),
                                                  const Icon(Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 16),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(upload.status!,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orangeAccent)),
                                                  const SizedBox(width: 8),
                                                  const Icon(Icons.file_upload,
                                                      color:
                                                          Colors.orangeAccent,
                                                      size: 16),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Text('No uploads in progress');
                            }
                          }),
                      SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              PolarTabItem(
                index: 1,
                title:
                    "History ${StudentCache.seenUploads.isNotEmpty ? '(${StudentCache.seenUploads.length})' : ''}",
                page: PolarTabPage(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Recent Uploads:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: _buildUploadList()),
                    ],
                  ),
                ),
              ),
            ];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PolarTabBar(
                  activeTitleStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  titleStyle: Theme.of(context).textTheme.bodySmall,
                  activeBackground: Theme.of(context).primaryColor,
                  background: Theme.of(context).primaryColor.withAlpha(20),
                  type: PolarTabType.pill,
                  tabs: tabs),
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
      ),
    );
  }

  Widget _buildCourseSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child:
          buildSearchableDropdown('Course', StudentCache.courses, (selected) {
        setState(() {
          _selectedCourse = selected;
        });
      }),
    );
  }

  Widget _buildFileUploader(BuildContext context) {
    return _type != Types.links
        ? UploadBox(onTap: () => _pickFile(context))
        : const SizedBox();
  }

  Widget _buildUploadList() {
    return (StudentCache.seenUploads.isNotEmpty)
        ? ListView.builder(
            itemCount: StudentCache.seenUploads.length,
            itemBuilder: (context, index) {
              final upload = StudentCache.seenUploads[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(upload.name),
                  subtitle:
                      Text(" Annotated: ${upload.isAnnotated ? '✅' : '❌'}"),
                  trailing: !upload.wentThrough
                      ? const CircularProgressIndicator()
                      : Icon(
                          upload.wentThrough ? Icons.check_circle : Icons.error,
                          color:
                              upload.wentThrough ? Colors.green : Colors.red),
                  onTap: () {
                    if (!upload.isAnnotated) {
                      _annotateBottomSheet(context, upload);
                    }
                  },
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

  Future<dynamic> _annotateBottomSheet(BuildContext context, Uploads? upload) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      constraints: BoxConstraints(minHeight: 700),
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Meta Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: widgetSelector(
                  upload?.type ?? _type ?? Types.notes,
                  pp: PaperUploadForm(
                    courseName: _selectedCourse,
                    materialId: upload?.id ?? _materialId,
                  ),
                  notes: DocumentUploadForm(
                    courseName: _selectedCourse,
                    materialId: upload?.id ?? _materialId,
                    type: Types.notes,
                  ),
                  ass: DocumentUploadForm(
                    courseName: _selectedCourse,
                    materialId: upload?.id ?? _materialId,
                    type: Types.assignment,
                  ),
                  book: DocumentUploadForm(
                    courseName: _selectedCourse,
                    materialId: upload?.id ?? _materialId,
                    type: Types.books,
                  ),
                  lab: DocumentUploadForm(
                    courseName: _selectedCourse,
                    materialId: upload?.id ?? _materialId,
                    type: Types.lab,
                  ),
                  link: LinkUploadForm(
                    courseName: _selectedCourse,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _materialId = Uuid().v4();
        _platformFile = result.files.first;
        _updateCache(Uploads(
          id: Uuid().v4(),
          courseName: _selectedCourse,
          type: _type,
          name: basename(normalize(_platformFile!.path!)),
          file: File(_platformFile?.path ?? ''),
          status: null,
          description: null,
        ));
      });
    }
  }
}
