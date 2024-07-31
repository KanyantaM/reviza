import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_api/study_material_api.dart';

class StudyMaterialCard extends StatelessWidget {
  final StudyMaterial studyMaterial;
  final Function(StudyMaterial) onTap;
  final Function onLongPress;
  final bool isDeleteMode;
  final Function(StudyMaterial path) onAddToDeleteList;
  final List<StudyMaterial> shouldBeDeleted;

  const StudyMaterialCard({
    super.key,
    required this.studyMaterial,
    required this.onTap,
    required this.onLongPress,
    required this.isDeleteMode,
    required this.onAddToDeleteList,
    required this.shouldBeDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress: () => onLongPress(),
        onTap: () async {
          if (isDeleteMode) {
            // String devicePath = await getPathTodDelete(studyMaterial);
            onAddToDeleteList(studyMaterial);
          } else {
            onTap(studyMaterial);
          }
        },
        child: Card(
          child: Column(
            children: [
              // Top section with text
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isDeleteMode)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                  future:  getPathTodDelete(studyMaterial),
                                  builder: (context, snapshot) {
                                    if (snapshot.data?.isNotEmpty ?? false) {
                                      if (shouldBeDeleted
                                          .contains(studyMaterial)) {
                                        return const Icon(
                                            Icons.check_circle_outline_rounded);
                                      } else {
                                        return const Icon(
                                            Icons.circle_outlined);
                                      }
                                    } else {
                                      return const Wrap();
                                    }
                                  }),
                              // (shouldBeDeleted)?const Icon(Icons.check_circle_outline_rounded):const Icon(Icons.circle_outlined),
                            ],
                          ),
                        Text(
                          '️🗒️',
                          textScaleFactor: (isDeleteMode) ? 3 : 4,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studyMaterial.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "desc: ${studyMaterial.description}",
                            style: const TextStyle(fontSize: 14.0),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => commingSoon(context),
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Bottom section with thumbs up and download size
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        (studyMaterial.fans.length >=
                                studyMaterial.haters.length)
                            ? const Icon(
                                Icons.thumb_up,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.thumb_down,
                                color: Colors.red,
                              ),
                        Text(
                          "${(((studyMaterial.fans.length >= studyMaterial.haters.length) ? studyMaterial.fans.length : studyMaterial.haters.length) / (studyMaterial.fans.length + studyMaterial.haters.length)).toStringAsFixed(1)}% (${(studyMaterial.fans.length + studyMaterial.haters.length).toString()})",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: (studyMaterial.fans.length >=
                                      studyMaterial.haters.length)
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FutureBuilder(
                            future: getFilePath(
                                studyMaterial.title, studyMaterial.subjectName),
                            builder: (context, snapshot) {
                              if (snapshot.data ?? false) {
                                return const Icon(Icons.phone_android_outlined);
                              } else {
                                return const Icon(Icons.cloud_outlined);
                              }
                            }),
                        Text(
                          (studyMaterial.size! <= 1000)
                              ? ' ${studyMaterial.size.toString()} KB'
                              : ' ${(studyMaterial.size! / 1000).toStringAsFixed(2)} MB',
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> getFilePath(String filename, String subjectName) async {
  final dir = await getApplicationDocumentsDirectory();
  if (await File("${dir.path}/$subjectName/$filename").exists()) {
    return true;
  } else {
    return false;
  }
}

Future<String> getPathTodDelete(StudyMaterial studyMaterial) async {
  final dir = await getApplicationDocumentsDirectory();
  if (await File(
          "${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}")
      .exists()) {
    return "${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}";
  }
  return '';
}

Future deleteFile(StudyMaterial studyMaterial) async {
  final dir = await getApplicationDocumentsDirectory();
  if (await File(
          "${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}")
      .exists()) {
    File("${dir.path}/${studyMaterial.subjectName}/${studyMaterial.title}")
        .delete();
  }
}
