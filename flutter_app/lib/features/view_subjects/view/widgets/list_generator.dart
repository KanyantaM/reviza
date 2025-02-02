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
    return LayoutBuilder(
      builder: (context, constraints) {
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
                          onPressed: () => onCancel(),
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
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          for (StudyMaterial path
                                              in pathsToDelete) {
                                            await local
                                                .deleteStudyMaterial(path);
                                          }
                                          onDelete();
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
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (constraints.maxWidth > 600) ? 2 : 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (constraints.maxWidth > 600) ? 3.5 : 2.5,
                ),
                itemCount: studyMaterials.length,
                itemBuilder: (context, index) {
                  return type == Types.links
                      ? LinksCard(studyMaterial: studyMaterials[index])
                      : StudyMaterialCard(
                          studyMaterial: studyMaterials[index],
                          onTap: (studyMaterial) {
                            context.read<ViewMaterialBloc>().add(
                                  DownLoadMaterial(
                                      course: studyMaterials[index], uid: uid),
                                );
                          },
                          onLongPress: onLongPress,
                          isDeleteMode: deleteMode,
                          onAddToDeleteList: onAddToDeleteList,
                          shouldBeDeleted: pathsToDelete,
                        );
                },
              ),
            ),
          ],
        );
      },
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
