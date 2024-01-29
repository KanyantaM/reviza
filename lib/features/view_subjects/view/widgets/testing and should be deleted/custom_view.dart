import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class CustomPDFViewer extends StatefulWidget {
  const CustomPDFViewer({super.key});

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  final GlobalKey<State<StatefulWidget>> pdfViewerKey = GlobalKey();
  int currentPage = 0;
  int? totalPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            key: pdfViewerKey,
            filePath:
                'assets/pdf/Modern App Development with Dart and Flutter 2_ A Comprehensive Introduction to Flutter.pdf',
            onRender: (pages) {
              setState(() {
                totalPage = pages;
              });
            },
            onError: (error) {
              if (kDebugMode) {
                print(error.toString());
              }
            },
            onPageError: (page, error) {
              if (kDebugMode) {
                print('$page: ${error.toString()}');
              }
            },
            onViewCreated: (PDFViewController pdfViewController) {
              // Access pdfViewController if needed
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page ?? 0;
              });
              if (kDebugMode) {
                print('page change: $page/$total');
              }
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Page $currentPage/${totalPage ?? ''}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                        // Handle upvote action
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                            size: 30,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle downvote action
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          "Download",
                          style: TextStyle(fontSize: 16.0, color: Colors.blue),
                        ),
                        Icon(
                          Icons.download_rounded,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const Row(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CustomPDFViewer(),
  ));
}
