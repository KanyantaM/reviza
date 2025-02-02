import 'package:flutter/material.dart';
import 'package:reviza/features/view_subjects/utils/important_functions.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_api/study_material_api.dart';

class StudyMaterialCard extends StatelessWidget {
  final StudyMaterial studyMaterial;
  final Function(StudyMaterial) onTap;
  final Function onLongPress;
  final bool isDeleteMode;
  final Function(StudyMaterial) onAddToDeleteList;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final textSize = screenWidth < 400 ? 13.0 : 15.0; // Responsive text size

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        onLongPress: () => onLongPress(),
        onTap: () {
          if (isDeleteMode) {
            onAddToDeleteList(studyMaterial);
          } else {
            onTap(studyMaterial);
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isDeleteMode)
                      FutureBuilder(
                        future: getPathToDelete(studyMaterial),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                shouldBeDeleted.contains(studyMaterial)
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: shouldBeDeleted.contains(studyMaterial)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    const Text('🗒️', textScaleFactor: 2.5),
                    const SizedBox(width: 10),

                    /// **Title & Description (Flexible to avoid overflow)**
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studyMaterial.title,
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            studyMaterial.description,
                            style: TextStyle(
                              fontSize: textSize - 2,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    /// **Share Button**
                    IconButton(
                      onPressed: () => commingSoon(context),
                      icon: const Icon(Icons.share, color: Colors.blueGrey),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// **Like/Dislike Percentage**
                      Row(
                        children: [
                          Icon(
                            studyMaterial.fans.length >=
                                    studyMaterial.haters.length
                                ? Icons.thumb_up_alt_rounded
                                : Icons.thumb_down_alt_rounded,
                            size: 16,
                            color: studyMaterial.fans.length >=
                                    studyMaterial.haters.length
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${((studyMaterial.fans.length >= studyMaterial.haters.length ? studyMaterial.fans.length : studyMaterial.haters.length) / (studyMaterial.fans.length + studyMaterial.haters.length)).toStringAsFixed(1)}% (${studyMaterial.fans.length + studyMaterial.haters.length})",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: studyMaterial.fans.length >=
                                      studyMaterial.haters.length
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),

                      /// **File Status & Size**
                      Row(
                        children: [
                          FutureBuilder(
                            future: isFileDownloaded(
                                studyMaterial.title, studyMaterial.subjectName),
                            builder: (context, snapshot) {
                              return Icon(
                                snapshot.data ?? false
                                    ? Icons.phone_android
                                    : Icons.cloud_download_outlined,
                                size: 16,
                                color: snapshot.data ?? false
                                    ? Colors.blue
                                    : Colors.grey,
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            studyMaterial.size! <= 1000
                                ? ' ${studyMaterial.size} KB'
                                : ' ${(studyMaterial.size! / 1000).toStringAsFixed(2)} MB',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
