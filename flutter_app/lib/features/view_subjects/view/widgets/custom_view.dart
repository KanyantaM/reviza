import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/features/ai_chat_screen/bard_chat_screen.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
// import 'package:reviza/utilities/dialogues/error_dialog.dart';
import 'package:study_material_api/study_material_api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomPDFViewer extends StatefulWidget {
  final bool viewOnline;
  final StudyMaterialOpened state;
  final Function onUpVote;
  final Function onDownVote;
  final Function onReport;

  const CustomPDFViewer({
    super.key,
    required this.state,
    required this.viewOnline,
    required this.onUpVote,
    required this.onDownVote,
    required this.onReport,
  });

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  StudyMaterial? _studyMaterial;
  String? _uid;
  bool? _hasVotedUp;
  int currentPage = 1;
  int? totalPage;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  void _checkVoteStatus(StudyMaterial? studyMaterial, String? uid) {
    setState(() {
      if ((studyMaterial?.fans.contains(uid) ?? false)) {
        _hasVotedUp = true;
      } else if (studyMaterial?.haters.contains(uid) ?? false) {
        _hasVotedUp = false;
      } else {
        _hasVotedUp = null;
      }
    });
  }

  @override
  void initState() {
    _studyMaterial = widget.state.studyMaterial;
    _uid = widget.state.uid;
    _checkVoteStatus(_studyMaterial, _uid);
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_studyMaterial?.title ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.assistant),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: AiScreen(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            File(_studyMaterial?.filePath ?? ''),
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                totalPage = details.document.pages.count;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                currentPage = details.newPageNumber;
              });
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Page $currentPage/${totalPage ?? ''}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          widget.viewOnline
              ? VotingBar(
                  hasVotedUp: _hasVotedUp,
                  onUpVote: widget.onUpVote,
                  onDownVote: widget.onDownVote,
                  onReport: widget.onReport,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class VotingBar extends StatelessWidget {
  final bool? hasVotedUp;
  final Function onUpVote;
  final Function onDownVote;
  final Function onReport;
  const VotingBar({
    super.key,
    this.hasVotedUp,
    required this.onUpVote,
    required this.onDownVote,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: const EdgeInsets.all(15.0),
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
                    color: hasVotedUp == true
                        ? Colors.green
                        : Colors.lightGreen[100],
                  ),
                  onPressed: () => onUpVote(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    color: hasVotedUp == false ? Colors.red : Colors.red[100],
                  ),
                  onPressed: () => onDownVote(),
                ),
                IconButton(
                  onPressed: () => commingSoon(context),
                  icon: const Icon(Icons.share, color: Colors.blue),
                ),
                InkWell(
                  onTap: () => onReport(),
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
        ),
      ),
    );
  }
}
