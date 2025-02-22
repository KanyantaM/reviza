import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_repository/study_material_repository.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomPDFViewer extends StatefulWidget {
  final StudyMaterial material;

  const CustomPDFViewer({
    super.key,
    required this.material,
  });

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  StudyMaterial? _studyMaterial;
  int currentPage = 1;
  int totalPage = 1;
  Future<String?>? _localFileFuture;

  @override
  void initState() {
    super.initState();
    _studyMaterial = widget.material;
    _localFileFuture = _studyMaterial?.revizaStorage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_studyMaterial?.title ?? 'PDF Viewer'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          // PDF Viewer
          Positioned.fill(
            child: _studyMaterial == null
                ? const Center(child: Text('Study material not available.'))
                : _studyMaterial!.onlinePath?.isNotEmpty ?? false
                    ? SfPdfViewer.network(
                        _studyMaterial?.onlinePath ?? '',
                        controller: _pdfViewerController,
                        onDocumentLoaded: (details) {
                          setState(() {
                            totalPage = details.document.pages.count;
                          });
                        },
                        onPageChanged: (details) {
                          setState(() {
                            currentPage = details.newPageNumber;
                          });
                        },
                      )
                    : FutureBuilder<String?>(
                        future: _localFileFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error loading file: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No study material found.'));
                          }

                          final file = File(snapshot.data!);
                          if (!file.existsSync()) {
                            return const Center(
                                child: Text('File does not exist.'));
                          }

                          return SfPdfViewer.file(
                            file,
                            controller: _pdfViewerController,
                            onDocumentLoaded: (details) {
                              setState(() {
                                totalPage = details.document.pages.count;
                              });
                            },
                            onPageChanged: (details) {
                              setState(() {
                                currentPage = details.newPageNumber;
                              });
                            },
                          );
                        },
                      ),
          ),

          // VotingBar positioned at the bottom
          Positioned(
            bottom: 10, // Ensure it's slightly above the screen bottom
            left: 0,
            right: 0,
            child: VotingBar(
              openMaterial: widget.material,
            ),
          ),
        ],
      ),
    );
  }
}

class VotingBar extends StatefulWidget {
  const VotingBar({
    super.key,
    required this.openMaterial,
  });

  final StudyMaterial openMaterial;

  @override
  State<VotingBar> createState() => _VotingBarState();
}

class _VotingBarState extends State<VotingBar> {
  bool? _hasVotedUp;
  final String uid = StudentCache.tempStudent.userId;
  @override
  void initState() {
    super.initState();

    if (widget.openMaterial.fans.contains(uid)) {
      _hasVotedUp = true;
    } else if (_hasVotedUp = widget.openMaterial.haters.contains(uid)) {
      _hasVotedUp = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .appBarTheme
              .backgroundColor
              ?.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color:
                    _hasVotedUp == true ? Colors.green : Colors.lightGreen[100],
              ),
              onPressed: () {
                if (_hasVotedUp != true) {}
                setState(() {
                  if (_hasVotedUp == true) {
                    _hasVotedUp = null;
                    context.read<ViewMaterialBloc>().add(
                          VoteMaterial(
                            material: widget.openMaterial,
                            vote: _hasVotedUp,
                          ),
                        );
                  } else {
                    _hasVotedUp = true;
                    context.read<ViewMaterialBloc>().add(
                          VoteMaterial(
                            material: widget.openMaterial,
                            vote: _hasVotedUp,
                          ),
                        );
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.thumb_down,
                color: _hasVotedUp == false ? Colors.red : Colors.red[100],
              ),
              onPressed: () {
                setState(() {
                  if (_hasVotedUp == false) {
                    _hasVotedUp = null;
                    context.read<ViewMaterialBloc>().add(
                          VoteMaterial(
                            material: widget.openMaterial,
                            vote: _hasVotedUp,
                          ),
                        );
                  } else {
                    _hasVotedUp = false;
                    context.read<ViewMaterialBloc>().add(
                          VoteMaterial(
                            material: widget.openMaterial,
                            vote: _hasVotedUp,
                          ),
                        );
                  }
                });
              },
            ),
            IconButton(
              onPressed: () => commingSoon(context),
              icon: const Icon(Icons.share, color: Colors.blue),
            ),
            InkWell(
              onTap: () => context.read<ViewMaterialBloc>().add(
                    ReportMaterial(
                      material: widget.openMaterial,
                    ),
                  ),
              child: const Row(
                children: [
                  Text("Report",
                      style: TextStyle(fontSize: 16.0, color: Colors.red)),
                  Icon(Icons.report_rounded, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
