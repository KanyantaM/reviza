import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:reviza/features/view_subjects/view/widgets/list_generator.dart';
import 'package:reviza/features/view_subjects/view/widgets/custom_view.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_repository/study_material_repository.dart';

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

  String _selectedCourse = '';
  Types? _selectedFilter;
  bool _deleteMode = false;
  List<StudyMaterial> _pathsToDelete = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _deleteMode = false;
    _tabController.addListener(() {
      setState(() {});
    });
    // Listen for swipe gestures and update animationValue
    _tabController.animation!.addListener(() {
      setState(() {
        _animationValue = _tabController.animation!.value;
      });
    });
  }

  double _animationValue = 0.0;

  @override
  void dispose() {
    // context.read<ViewMaterialBloc>().close();
    _deleteMode = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///when the screen just loads fetched the data
    if (widget.isDownloadedView) {
      context.read<ViewMaterialBloc>().add(
            FetchCourseMaterials(
              course: null,
              online: false,
            ),
          );
    } else {
      context.read<ViewMaterialBloc>().add(
            FetchCourseMaterials(
              course: widget.courseName,
              online: true,
            ),
          );
    }
    return BlocConsumer<ViewMaterialBloc, ViewMaterialState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MaterialsFetchedState) {
          Widget generateCardByTypeSelector(Types? type, {String? course}) {
            return generateCards(
                context,
                widget.uid,
                course ?? widget.courseName,
                type,
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
                },
                state.courseToMaterialsMap);
          }

          if (!widget.isDownloadedView) {
            return Scaffold(
              appBar: cloudAppBar(context),
              body: TabBarView(controller: _tabController, children: <Widget>[
                generateCardByTypeSelector(Types.notes,
                    course: widget.courseName),
                generateCardByTypeSelector(Types.papers,
                    course: widget.courseName),
                generateCardByTypeSelector(Types.books,
                    course: widget.courseName),
                generateCardByTypeSelector(Types.links,
                    course: widget.courseName),
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
                            for (String course
                                in state.courseToMaterialsMap.keys.toList())
                              FilterChip(
                                label: Text(course.split('-').first),
                                selected: _selectedCourse == course,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedCourse = selected ? course : '';
                                    _selectedFilter = null;
                                  });
                                },
                              ),
                          ],
                        ),
                        (_selectedCourse.isNotEmpty)
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
                                          selected: _selectedFilter == filter,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _selectedFilter =
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
                    child: generateCardByTypeSelector(
                      _selectedFilter,
                      course: _selectedCourse,
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.7, // Responsive width
                          height: MediaQuery.of(context).size.height *
                              0.3, // Responsive height
                          child: LottieBuilder.asset(
                            'assets/lottie/downloading_cloud.json',
                            fit: BoxFit.contain, // Prevent overflow
                          ),
                        ),
                        BlocBuilder(
                            bloc: downLoadProgressCubit,
                            builder: (context, ownloadProgressCubit) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.9,
                                  ),
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: LinearProgressIndicator(
                                            value: downLoadProgressCubit.state,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${(downLoadProgressCubit.state * 100).toStringAsFixed(1)} %',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      ),
                    );
              } else {
                context.read<ViewMaterialBloc>().add(
                      FetchCourseMaterials(
                        course: widget.courseName,
                        online: true,
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
                        vote: true,
                      ),
                    );
              },
              onDownVote: () {
                context.read<ViewMaterialBloc>().add(
                      VoteMaterial(
                        material: state.originalStudyMaterial,
                        vote: false,
                      ),
                    );
              },
              onReport: () {
                context.read<ViewMaterialBloc>().add(
                      ReportMaterial(
                        material: state.originalStudyMaterial,
                      ),
                    );
              },
              uid: widget.uid,
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
      title: const Text('Downloads'),
    );
  }

  /// Custom AppBar with Smooth Animated Tabs
  AppBar cloudAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text('ReviZa'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return _buildTab(index, _icons[index], _labels[index]);
            }),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            commingSoon(context);
          },
          icon: const Icon(Icons.notifications),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  /// Custom Tab with Smooth Resizing
  Widget _buildTab(int index, IconData icon, String label) {
    double selectedFactor =
        (1 - (_animationValue - index).abs()).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: 10 + (10 * selectedFactor), vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: selectedFactor * 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20 + (10 * selectedFactor), color: Colors.white),
            if (selectedFactor > 0.5) ...[
              SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12 + (4 * selectedFactor),
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }

  final List<IconData> _icons = [
    Icons.note,
    Icons.question_answer,
    Icons.book,
    Icons.link,
  ];
  final List<String> _labels = [
    "Notes",
    "Papers",
    "Books",
    "Links",
  ];
}
