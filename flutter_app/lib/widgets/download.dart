import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_material_api/study_material_api.dart';
import 'dart:io';

class DownloadingDialog extends StatefulWidget {
  final StudyMaterial material;
  const DownloadingDialog({super.key, required this.material});

  @override
  DownloadingDialogState createState() => DownloadingDialogState();
}

class DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;
  bool isDownloading = true; // Track download status

  @override
  void initState() {
    super.initState();
    Future.microtask(() => startDownloading()); // Fix async gap
  }

  Future<void> startDownloading() async {
    try {
      String url = widget.material.filePath!;
      String fileName = widget.material.title;
      String path = await _getFilePath(fileName);

      await dio.download(
        url,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes > 0) {
            setState(() {
              progress = receivedBytes / totalBytes;
            });
          }
        },
        deleteOnError: true,
      );

      // Ensure the file exists after download
      if (File(path).existsSync()) {
        throw Exception("Download Complete: $path");
      }
    } catch (e) {
      throw Exception("Download failed: $e");
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
        Navigator.pop(context); // Close dialog after completion
      }
    }
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final folderPath = "${dir.path}/${widget.material.subjectName}";
    await Directory(folderPath)
        .create(recursive: true); // Ensure directory exists
    return "$folderPath/$filename";
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDownloading)
            CircularProgressIndicator.adaptive(value: progress),
          const SizedBox(height: 20),
          Text(
            isDownloading
                ? "Downloading: $downloadingProgress%"
                : "Download Complete!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
