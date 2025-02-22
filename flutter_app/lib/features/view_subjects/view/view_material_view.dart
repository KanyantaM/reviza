import 'package:flutter/material.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/view_subjects/view/repo.dart';
import 'package:reviza/features/view_subjects/view/widgets/list_generator.dart';
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
    _deleteMode = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<StudyMaterial>>>(
      future: fetchMaterials(
          isOnline: !widget.isDownloadedView, course: widget.courseName),
      builder: (context, state) {
        Widget generateCardByTypeSelector(Types? type, {String? course}) {
          return generateCards(
              context: context,
              course: course ?? widget.courseName,
              type: type,
              onLongPress: widget.isDownloadedView
                  ? () {
                      setState(() {
                        _deleteMode = true;
                      });
                    }
                  : () {},
              deleteMode: _deleteMode,
              onCancel: () {
                setState(() {
                  _deleteMode = false;
                });
              },
              onAddToDeleteList: (path) {
                setState(() {
                  if (_pathsToDelete.contains(path)) {
                    _pathsToDelete.remove(path);
                  } else {
                    _pathsToDelete.add(path);
                  }
                });
              },
              pathsToDelete: _pathsToDelete,
              onDelete: () {
                StudentCache.initCache(uid: widget.uid);
                setState(() {
                  _deleteMode = false;
                  _pathsToDelete = [];
                });
              },
              materials: state.data ?? {});
        }

        if (!widget.isDownloadedView) {
          return Scaffold(
            appBar: cloudAppBar(context, widget.courseName!.split('-').first),
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
                  child: Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                              in StudentCache.localStudyMaterial.keys.toList())
                            if (_selectedCourse.isNotEmpty &&
                                _selectedCourse == course)
                              FilterChip(
                                label: Text(course.split('-').first),
                                selected: _selectedCourse == course,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedCourse = selected ? course : '';
                                    _selectedFilter = null;
                                  });
                                },
                              )
                            else if (_selectedCourse.isEmpty)
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
                          ? Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if (_selectedFilter != null &&
                                          _selectedFilter == filter)
                                        FilterChip(
                                          label: Text(filter.name),
                                          selected: _selectedFilter == filter,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _selectedFilter =
                                                  selected ? filter : null;
                                            });
                                          },
                                        )
                                      else if (_selectedFilter == null)
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
      },
    );
  }

  AppBar appBarSelector(BuildContext context, String? courseName) {
    return (!widget.isDownloadedView)
        ? cloudAppBar(context, courseName)
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
  AppBar cloudAppBar(BuildContext context, String? courseName) {
    return AppBar(
      centerTitle: true,
      title: Text(courseName ?? 'ReviZa'),
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
    Icons.video_collection,
  ];
  final List<String> _labels = [
    "Notes",
    "Papers",
    "Books",
    "Videos",
  ];
}
