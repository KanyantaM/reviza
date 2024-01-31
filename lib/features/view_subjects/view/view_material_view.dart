import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reviza/features/view_subjects/view/widgets/my_subject_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/custom_view.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
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
  }

  @override
  void dispose() {
    context.read<ViewMaterialBloc>().close();
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
              appBar: AppBar(
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
              ),
              body: TabBarView(controller: _tabController, children: <Widget>[
                generateCards(
                    widget.uid, widget.courseName, Types.notes, state),
                generateCards(
                    widget.uid, widget.courseName, Types.papers, state),
                generateCards(
                    widget.uid, widget.courseName, Types.links, state),
                // SimilarSubjectsWidget(
                //   similarSubjects: const [
                //     'Mathematics',
                //     'Physics',
                //     'Chemistry',
                //     'Biology'
                //   ],
                // ),
              ]),
            );
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: SearchBar(
                        hintText: 'search downloads',
                        leading: Icon(Icons.search),
                      ),
                    ),
                    const Text(
                      'Filter:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        for (String course in state.courses)
                          FilterChip(
                            label: Text(course),
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
                    if (selectedCourse.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Select Filter:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                      selectedFilter = selected ? filter : null;
                                    });
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Apply Filters'),
                          ),
                          generateCards(
                              widget.uid, selectedCourse, selectedFilter, state)
                        ],
                      ),
                  ],
                ),
              ),
            );
          }
        }
        if (state is LoadingState) {
          return const CircularProgressIndicator.adaptive();
        }
        if (state is StudyMaterialOpened) {
          return CustomPDFViewer(state: state, viewOnline: true);
        }
        return const Wrap();
      },
    );
  }
}

Widget generateCards(
    String uid, String? course, Types? type, MaterialsFetchedState state) {
  List<StudyMaterial> studyMaterials = state.filterByType(course, type);
  return ListView.builder(
      shrinkWrap: true,
      itemCount: studyMaterials.length,
      itemBuilder: ((context, index) {
        if (type == Types.links) {
          // return ExpandingCard(title: title, subtitle: subtitle, onToggle: onToggle)
        }
        return StudyMaterialCard(
            studyMaterial: studyMaterials[index],
            onTap: (studyMaterial) {
              context.read<ViewMaterialBloc>().add(
                  ReadStudyMaterial(studyMaterial: studyMaterial, uid: uid));
            });
      }));
}
