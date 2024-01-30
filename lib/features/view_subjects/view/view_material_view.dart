import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:reviza/features/subject_screen/subject_screen.dart';
import 'package:reviza/features/view_subjects/view/widgets/my_subject_card.dart';
import 'package:reviza/features/view_subjects/view/widgets/testing%20and%20should%20be%20deleted/custom_view.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:study_material_api/study_material_api.dart';

class SubjectDetailsScreen extends StatefulWidget {
  const SubjectDetailsScreen({super.key, required this.uid, required this.courseName});
  final String uid;
  final String courseName;

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewMaterialBloc, ViewMaterialState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        if (state is MaterialsFetchedState) {
          return Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
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
            generateCards(widget.uid, widget.courseName, Types.notes, state),
            generateCards(widget.uid, widget.courseName, Types.papers, state),
            generateCards(widget.uid, widget.courseName, Types.links, state),
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
    String uid, String? course, Types type, MaterialsFetchedState state) {
  List<StudyMaterial> studyMaterials = state.filterByType(course, type);
  return ListView.builder(
      shrinkWrap: true,
      itemCount: studyMaterials.length,
      itemBuilder: ((context, index) {
        return StudyMaterialCard(
            studyMaterial: studyMaterials[index],
            onTap: (studyMaterial) {
              context.read<ViewMaterialBloc>().add(
                  ReadStudyMaterial(studyMaterial: studyMaterial, uid: uid));
            });
      }));
}
