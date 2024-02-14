import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_study_material_api/local_storage_study_material_api.dart';
import 'package:reviza/features/view_subjects/view/widgets/links_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/my_subject_card.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/widgets/no_data.dart';
import 'package:study_material_api/study_material_api.dart';

Widget generateCards(
    BuildContext context,
    String uid,
    String? course,
    Types? type,
    MaterialsFetchedState state,
    Function onLongPress,
    bool deleteMode,
    Function onCancel,
    Function(StudyMaterial) onAddToDeleteList,
    List<StudyMaterial> pathsToDelete,
    Function onDelete) {
  List<StudyMaterial> studyMaterials = state.filterByType(course, type);
  if (studyMaterials.isNotEmpty) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (deleteMode)
          Column(
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        onCancel();
                      },
                      icon: const Icon(Icons.cancel)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              HiveStudyMaterialRepository local =
                                  HiveStudyMaterialRepository();
                              return AlertDialog(
                                icon: const Icon(Icons.delete),
                                title: Text(
                                    'Delete ${pathsToDelete.length} file(s)'),
                                content: const Text(
                                    'Are you sure you want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Perform the deletion
                                      Navigator.pop(
                                        context,
                                      );
                                      for (StudyMaterial path
                                          in pathsToDelete) {
                                        await local.deleteStudyMaterial(path);
                                      }
                                      onDelete();
                                      // Close the dialog
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              const Divider(),
            ],
          ),
        Flexible(
          child: ListView.builder(
              // physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: studyMaterials.length,
              itemBuilder: ((context, index) {
                if (type == Types.links) {
                  return LinksCard(
                    studyMaterial: studyMaterials[index],
                  );
                }
                // print(studyMaterials[index]);
                return StudyMaterialCard(
                  studyMaterial: studyMaterials[index],
                  onTap: (studyMaterial) {
                    context.read<ViewMaterialBloc>().add(DownLoadMaterial(
                        course: studyMaterials[index], uid: uid));
                  },
                  onLongPress: onLongPress,
                  isDeleteMode: deleteMode,
                  onAddToDeleteList: onAddToDeleteList,
                  shouldBeDeleted: pathsToDelete,
                );
              })),
        ),
      ],
    );
  } else {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NoDataCuate(
            issue:
                'No ${type?.name ?? 'material'} have been found, help us by uploading some'),
      ),
    );
  }
}
