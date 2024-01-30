import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_api/study_material_api.dart';

class StudyMaterialCard extends StatelessWidget {
  final StudyMaterial studyMaterial;
  final Function(StudyMaterial) onTap;
  const StudyMaterialCard(
      {super.key, required this.studyMaterial, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: 350.0, // Adjust width as needed
        height: 175.0, // Adjust height as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5.0,
              blurRadius: 7.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top section with text
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  onTap(studyMaterial);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        '🗒️',
                        textScaleFactor: 4,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studyMaterial.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "desc: ${studyMaterial.description}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          commingSoon(context);
                        },
                        icon: const Icon(Icons.share))
                  ],
                ),
              ),
            ),
            // Divider
            // Divider(
            //   height: 1.0,
            //   color: Colors.grey.withOpacity(0.5),
            // ),
            // // Download & Report buttons
            // const Padding(
            //   padding: EdgeInsets.all(15.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.arrow_upward,
            //           ),
            //           SizedBox(
            //             width: 8,
            //           ),
            //           Text(
            //             "0",
            //             style: TextStyle(
            //               fontSize: 16.0,
            //               color: Colors.grey,
            //             ),
            //           ),
            //           SizedBox(
            //             width: 8,
            //           ),
            //           Icon(
            //             Icons.arrow_downward,
            //           ),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Text(
            //             "Download",
            //             style: TextStyle(fontSize: 16.0, color: Colors.blue),
            //           ),
            //           Icon(Icons.download_rounded, color: Colors.blue),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Text(
            //             "Report",
            //             style: TextStyle(fontSize: 16.0, color: Colors.red),
            //           ),
            //           Icon(Icons.report_rounded, color: Colors.red),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
