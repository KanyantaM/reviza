import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reviza/features/ai_chat_screen/bard_chat_screen.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:reviza/utilities/dialogues/error_dialog.dart';
import 'package:study_material_api/study_material_api.dart';

class CustomPDFViewer extends StatefulWidget {
  final bool viewOnline;
  final StudyMaterialOpened state;
  final Function onUpVote;
  final Function onDownVote;
  final Function onDelete;
  final Function onReport;

  const CustomPDFViewer({
    super.key,
    required this.state,
    required this.viewOnline,
    required this.onUpVote,
    required this.onDownVote,
    required this.onReport,
    required this.onDelete,
  });

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  StudyMaterial? _studyMaterial;
  String? _uid;
  bool? _hasVotedUp;
  final GlobalKey<State<StatefulWidget>> pdfViewerKey = GlobalKey();
  int currentPage = 1;
  int? totalPage;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_studyMaterial?.title ?? ''),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.robot),
              onPressed: () {
                // Handle share action
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: AiScreen(),
                      );
                    });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            key: pdfViewerKey,
            filePath: _studyMaterial!.filePath,
            onRender: (pages) {
              setState(() {
                totalPage = pages;
              });
            },
            onError: (error) {
              showErrorDialog(context, error.toString());
            },
            onPageError: (page, error) {
              showErrorDialog(context, '$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page ?? 0;
              });

              // showErrorDialog(context, 'page change: $page/$total');
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Page ${currentPage + 1}/${totalPage ?? ''}',
                style: const TextStyle(
                  fontSize: 16.0,
                  // color: Colors.white,
                ),
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
              : const Wrap(),
        ],
      ),
    );
  }
}

class VotingBar extends StatefulWidget {
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
  State<VotingBar> createState() => _VotingBarState();
}

class _VotingBarState extends State<VotingBar> {
  bool? _hasVotedUp;

  @override
  void initState() {
    _hasVotedUp = widget.hasVotedUp;
    super.initState();
  }

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
              color: Colors.grey[800],
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onUpVote();
                    setState(() {
                      if (_hasVotedUp == false || _hasVotedUp == null) {
                        _hasVotedUp = true;
                      } else {
                        _hasVotedUp = null;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        color: _hasVotedUp ?? false
                            ? Colors.green
                            : Colors.lightGreen[100],
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.onDownVote();
                      if (_hasVotedUp == true || _hasVotedUp == null) {
                        _hasVotedUp = false;
                      } else {
                        _hasVotedUp = null;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.thumb_down,
                        color:
                            _hasVotedUp ?? true ? Colors.red[100] : Colors.red,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      commingSoon(context);
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.blue,
                    )),
                InkWell(
                  onTap: () => widget.onReport(),
                  child: const Row(
                    children: [
                      Text(
                        "Report",
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                      Icon(
                        Icons.report_rounded,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                //        IconButton(
                //   icon: Icon(FontAwesomeIcons.robot),
                //   onPressed: () {
                //     // Handle share action
                //     commingSoon(context);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
