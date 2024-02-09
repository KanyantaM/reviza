import 'package:flutter/material.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_api/study_material_api.dart';

class StudyMaterialCard extends StatelessWidget {
  final StudyMaterial studyMaterial;
  final Function(StudyMaterial) onTap;

  const StudyMaterialCard({
    super.key,
    required this.studyMaterial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            // Top section with text
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () => onTap(studyMaterial),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '️🗒️',
                      textScaleFactor: 4,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
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
            ),

            const Divider(),

            // Bottom section with thumbs up and download size
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      (studyMaterial.fans.length >= studyMaterial.haters.length)? const Icon(Icons.thumb_up,color: Colors.green,):const Icon(Icons.thumb_down,color: Colors.red,),
                      Text(
                        "${(studyMaterial.fans.length/(studyMaterial.fans.length+studyMaterial.haters.length)).toStringAsFixed(1)}% (${(studyMaterial.fans.length+studyMaterial.haters.length).toString()})",
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color:(studyMaterial.fans.length >= studyMaterial.haters.length)? Colors.green: Colors.red),
                      ),
                    ],
                  ),
                  Text(
                    studyMaterial.size.toString(),
                    style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
