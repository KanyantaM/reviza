import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/view_subjects/view/widgets/links_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/my_subject_card.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/widgets/no_data.dart';
import 'package:study_material_repository/study_material_repository.dart';

Widget generateCards({
  required BuildContext context,
  required String? course,
  required Types? type,
  required Function onLongPress,
  required bool deleteMode,
  required Function onCancel,
  required Function(StudyMaterial) onAddToDeleteList,
  required List<StudyMaterial> pathsToDelete,
  required Function onDelete,
  required Map<String, List<StudyMaterial>> materials,
}) {
  return BlocBuilder<ViewMaterialBloc, ViewMaterialState>(
    builder: (context, state) {
      return FutureBuilder<List<StudyMaterial>>(
        future: filter(materials, courseName: course, type: type),
        builder: (context, snapshot) {
          List<StudyMaterial> studyMaterials = snapshot.data ?? [];

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
                                          return AlertDialog(
                                            icon: const Icon(Icons.delete),
                                            title: Text(
                                                'Delete ${pathsToDelete.length} file(s)'),
                                            content: const Text(
                                                'Are you sure you want to delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  for (StudyMaterial path
                                                      in pathsToDelete) {
                                                    await StudyMaterialRepo(
                                                            uid: StudentCache
                                                                .tempStudent
                                                                .userId)
                                                        .deleteLocalMaterial(
                                                            material: path);
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
                          childAspectRatio:
                              (constraints.maxWidth > 600) ? 3.5 : 2.5,
                        ),
                        itemCount: studyMaterials.length,
                        itemBuilder: (context, index) {
                          return type == Types.links
                              ? LinksCard(studyMaterial: studyMaterials[index])
                              : StudyMaterialCard(
                                  studyMaterial: studyMaterials[index],
                                  onTap: (studyMaterial) async {
                                    bool isDownloaded =
                                        await studyMaterial.isOnDevice;

                                    if (isDownloaded) {
                                      if (!context.mounted) return;

                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Material Already Downloaded'),
                                          content: const Text(
                                            'You have already downloaded this material.\n\n'
                                            'Check your downloads within the app to access it.',
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      if (!context.mounted) return;
                                      context.read<ViewMaterialBloc>().add(
                                            DownLoadMaterial(
                                                course: studyMaterials[index]),
                                          );
                                    }
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
        },
      );
    },
  );
}
