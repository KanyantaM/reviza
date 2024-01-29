import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectDetailsScreen extends StatefulWidget {
  const SubjectDetailsScreen({super.key});

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
  Widget build(BuildContext context) {
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
          Tab(child: Icon(Icons.book),),
          Tab(
            icon: Icon(Icons.link),
          ),
        ]),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          SizedBox(
            width: 12.h,
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
        const MyCard(),
        ExpandingCard(
            title: 'This is a Youtube link to Tutor Stephs Channel',
            subtitle: 'A video on Fourier Series',
            onToggle: (value) {}),SimilarSubjectsWidget(
        similarSubjects: ['Mathematics', 'Physics', 'Chemistry', 'Biology'],
      ),
      ]),
      
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "UNIT 4",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Author: NO NAME",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Upload Date: 01/10/21",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share))
                  ],
                ),
              ),
              // Divider
              Divider(
                height: 1.0,
                color: Colors.grey.withOpacity(0.5),
              ),
              // Download & Report buttons
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.arrow_downward,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Download",
                          style: TextStyle(fontSize: 16.0, color: Colors.blue),
                        ),
                        Icon(Icons.download_rounded, color: Colors.blue),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Report",
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        ),
                        Icon(Icons.report_rounded, color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandingCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool isOpen) onToggle;

  const ExpandingCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<ExpandingCard> createState() => _ExpandingCardState();
}

class _ExpandingCardState extends State<ExpandingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightFactorAnimation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactorAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _animationController.forward() : _animationController.reverse();
      widget.onToggle(isOpen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 350.0,
          height: isOpen ? 250.0 : 160.0,
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
          child: InkWell(
            onTap: _toggleCard,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🌐',
                        textScaleFactor: 3.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              'Tap to see more',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: !isOpen ? Colors.grey : Colors.amberAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _heightFactorAnimation,
                      builder: (context, child) {
                        return ClipRect(
                          child: Align(
                            heightFactor: _heightFactorAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Description:\t',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Open Link'),
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimilarSubjectsWidget extends StatelessWidget {
  final List<String> similarSubjects;
  final String title = "SIMILAR SUBJECTS";

  SimilarSubjectsWidget({required this.similarSubjects});

  @override
  Widget build(BuildContext context) {
    // final primary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        // collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // expandedBackgroundColor: Colors.white.withOpacity(0.91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    // color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note:",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                        // ?.copyWith(color: primary),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "These subjects are recommended based on similarity with the subject name.",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GenericSubjectTileView(
                    similarSubjects: similarSubjects,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenericSubjectTileView extends StatelessWidget {
  final List<String> similarSubjects;

  const GenericSubjectTileView({super.key, required this.similarSubjects});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: similarSubjects.map((subject) {
        return ListTile(
          title: Text(subject),
        );
      }).toList(),
    );
  }


}