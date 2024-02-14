import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_storage_study_material_api/local_storage_study_material_api.dart';
import 'package:lottie/lottie.dart';
import 'package:reviza/features/view_subjects/view/widgets/links_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/my_subject_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/custom_view.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:reviza/widgets/no_data.dart';
import 'package:study_material_api/study_material_api.dart';

class ViewMaterialsView extends StatefulWidget {
  const ViewMaterialsView({
    super.key,
    required this.uid,
    this.courseName,
    required this.isDownloadedView,
  });

  final String uid;
  final String? courseName;
  final bool isDownloadedView;

  @override
  State<ViewMaterialsView> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<ViewMaterialsView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  String selectedCourse = '';
  Types? selectedFilter;
  bool _deleteMode = false;
  List<StudyMaterial> _pathsToDelete = [];

  @override
  void initState() {
    super.initState();
    if (widget.isDownloadedView) {
      context.read<ViewMaterialBloc>().add(
            FetchCourseMaterials(
              course: null,
              online: false,
              uid: widget.uid,
            ),
          );
    } else {
      context.read<ViewMaterialBloc>().add(
            FetchCourseMaterials(
              course: widget.courseName,
              online: true,
              uid: widget.uid,
            ),
          );
    }
    _tabController = TabController(length: 4, vsync: this);
    _deleteMode = false;
  }

  @override
  void dispose() {
    // context.read<ViewMaterialBloc>().close();
    _deleteMode = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewMaterialBloc, ViewMaterialState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MaterialsFetchedState) {
          if (!widget.isDownloadedView) {
            return Scaffold(
              appBar: cloudAppBar(context),
              body: TabBarView(controller: _tabController, children: <Widget>[
                generateCards(
                    context,
                    widget.uid,
                    widget.courseName,
                    Types.notes,
                    state,
                    () {
                      setState(() {
                        _deleteMode = true;
                      });
                    },
                    _deleteMode,
                    () {
                      setState(() {
                        _deleteMode = false;
                      });
                    },
                    (path) {
                      setState(() {
                        if (_pathsToDelete.contains(path)) {
                          _pathsToDelete.remove(path);
                        } else {
                          _pathsToDelete.add(path);
                        }
                      });
                    },
                    _pathsToDelete,
                    () {
                      setState(() {
                        _deleteMode = false;
                        _pathsToDelete = [];
                      });
                    }),
                generateCards(
                    context,
                    widget.uid,
                    widget.courseName,
                    Types.papers,
                    state,
                    () {
                      setState(() {
                        _deleteMode = true;
                      });
                    },
                    _deleteMode,
                    () {
                      setState(() {
                        _deleteMode = false;
                      });
                    },
                    (path) {
                      setState(() {
                        if (_pathsToDelete.contains(path)) {
                          _pathsToDelete.remove(path);
                        } else {
                          _pathsToDelete.add(path);
                        }
                      });
                    },
                    _pathsToDelete,
                    () {
                      setState(() {});
                    }),
                generateCards(
                    context,
                    widget.uid,
                    widget.courseName,
                    Types.books,
                    state,
                    () {
                      setState(() {
                        _deleteMode = true;
                      });
                    },
                    _deleteMode,
                    () {
                      setState(() {
                        _deleteMode = false;
                      });
                    },
                    (path) {
                      setState(() {
                        if (_pathsToDelete.contains(path)) {
                          _pathsToDelete.remove(path);
                        } else {
                          _pathsToDelete.add(path);
                        }
                      });
                    },
                    _pathsToDelete,
                    () {
                      setState(() {
                        _deleteMode = false;
                        _pathsToDelete = [];
                      });
                    }),
                generateCards(
                    context,
                    widget.uid,
                    widget.courseName,
                    Types.links,
                    state,
                    () {
                      setState(() {
                        _deleteMode = true;
                      });
                    },
                    _deleteMode,
                    () {
                      setState(() {
                        _deleteMode = false;
                      });
                    },
                    (path) {
                      setState(() {
                        if (_pathsToDelete.contains(path)) {
                          _pathsToDelete.remove(path);
                        } else {
                          _pathsToDelete.add(path);
                        }
                      });
                    },
                    _pathsToDelete,
                    () {
                      setState(() {
                        _deleteMode = false;
                        _pathsToDelete = [];
                      });
                    }),
              ]),
            );
          } else {
            return Scaffold(
              appBar: localAppBar(context),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Select Course:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            for (String course in state.courses)
                              FilterChip(
                                label: Text(course.split('-').first),
                                selected: selectedCourse == course,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedCourse = selected ? course : '';
                                    selectedFilter = null;
                                  });
                                },
                              ),
                          ],
                        ),
                        (selectedCourse.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Select Type:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8.0,
                                    children: [
                                      for (Types filter in Types.values)
                                        FilterChip(
                                          label: Text(filter.name),
                                          selected: selectedFilter == filter,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedFilter =
                                                  selected ? filter : null;
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    child: generateCards(
                        context,
                        widget.uid,
                        selectedCourse,
                        selectedFilter,
                        state,
                        () {
                          setState(() {
                            _deleteMode = true;
                          });
                        },
                        _deleteMode,
                        () {
                          setState(() {
                            _deleteMode = false;
                          });
                        },
                        (path) {
                          setState(() {
                            if (_pathsToDelete.contains(path)) {
                              _pathsToDelete.remove(path);
                            } else {
                              _pathsToDelete.add(path);
                            }
                          });
                        },
                        _pathsToDelete,
                        () {
                          setState(() {
                            _deleteMode = false;
                            _pathsToDelete = [];
                          });
                        }),
                  ),
                ],
              ),
            );
          }
        }
        if (state is LoadingState) {
          return Scaffold(
            appBar: appBarSelector(context),
            body: const SizedBox(
                child: Center(child: CircularProgressIndicator())),
          );
        }
        if (state is DownloadingCourses) {
          // Show download progress UI
          return Scaffold(
              appBar: appBarSelector(context),
              body: SizedBox(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LottieBuilder.asset(
                              'assets/lottie/downloading_cloud.json'),
                        ),
                        BlocBuilder(
                            bloc: downLoadProgressCubit,
                            builder: (context, ownloadProgressCubit) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Wrap(
                                  children: [
                                    LinearProgressIndicator(
                                      value: downLoadProgressCubit.state,
                                    ),
                                    Text(
                                        '${(downLoadProgressCubit.state * 100).toStringAsFixed(1)} %')
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ));
        }
        if (state is StudyMaterialOpened) {
          return WillPopScope(
            onWillPop: () async {
              // Show a confirmation dialog before allowing the pop.
              if (widget.isDownloadedView) {
                context.read<ViewMaterialBloc>().add(
                      FetchCourseMaterials(
                        course: null,
                        online: false,
                        uid: widget.uid,
                      ),
                    );
              } else {
                context.read<ViewMaterialBloc>().add(
                      FetchCourseMaterials(
                        course: widget.courseName,
                        online: true,
                        uid: widget.uid,
                      ),
                    );
              }
              return false;
            },
            child: CustomPDFViewer(
              state: state,
              viewOnline: true,
              onUpVote: () {
                context.read<ViewMaterialBloc>().add(
                      VoteMaterial(
                        material: state.originalStudyMaterial,
                        uid: state.uid,
                        vote: true,
                      ),
                    );
              },
              onDownVote: () {
                context.read<ViewMaterialBloc>().add(
                      VoteMaterial(
                        material: state.originalStudyMaterial,
                        uid: state.uid,
                        vote: false,
                      ),
                    );
              },
              onReport: () {
                context.read<ViewMaterialBloc>().add(
                      ReportMaterial(
                        material: state.originalStudyMaterial,
                        uid: state.uid,
                      ),
                    );
              },
            ),
          );
        }

        return Scaffold(
          appBar: appBarSelector(context),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!widget.isDownloadedView)
                      ? ((state is ErrorState &&
                              state.message.contains('[connection error]'))
                          ? const Icon(
                              Icons.cloud_off_outlined,
                              size: 120,
                            )
                          : Image.asset('assets/images/error404.png'))
                      : const CircularProgressIndicator.adaptive(),
                  (state is ErrorState)
                      ? ((state.message.contains('[connection error]'))
                          ? const Text(
                              'Failed to download due to poor or bad network connectivity',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700))
                          : Text(state.message))
                      : const Text(''),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar appBarSelector(BuildContext context) {
    return (!widget.isDownloadedView)
        ? cloudAppBar(context)
        : localAppBar(context);
  }

  AppBar localAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Downloads'),
    );
  }

  AppBar cloudAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('ReviZa'),
      bottom: TabBar(controller: _tabController, tabs: const [
        Tab(
          child: Icon(Icons.note),
        ),
        Tab(
          icon: Icon(Icons.question_answer),
        ),
        Tab(
          child: Icon(Icons.book),
        ),
        Tab(
          icon: Icon(Icons.link),
        ),
      ]),
      actions: [
        IconButton(
            onPressed: () {
              commingSoon(context);
            },
            icon: const Icon(Icons.notifications)),
        SizedBox(
          width: 12.h,
        )
      ],
    );
  }
}

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
