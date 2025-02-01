import 'package:flutter/material.dart';
import 'package:reviza/features/ai_chat_screen/bard_chat_screen.dart';
import 'package:reviza/features/edit_courses/view/home_tab_page.dart';
import 'package:reviza/features/view_subjects/view_subjects.dart';
import 'package:reviza/ui/home_screen/tabs/upload/upload_screen.dart';
import 'package:reviza/features/user_screen.dart';

class MyHomePage extends StatefulWidget {
  final String uid;
  const MyHomePage({
    super.key,
    required this.uid,
  });

  static Page<void> page(String userId) =>
      MaterialPage<void>(child: MyHomePage(uid: userId));

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  Widget _currentPage = const HomeTabPage(userId: '');
  final List<Widget> _listPages = [];

  @override
  void initState() {
    super.initState();
    _listPages
      ..add(HomeTabPage(
        userId: widget.uid,
      ))
      ..add(UploadTypeScreen(
        uid: widget.uid,
      ))
      // ..add(ViewMaterialPage(
      //   isDownloadedView: true,
      //   uid: widget.uid,
      // ));
      ..add(const AiScreen());
    _currentPage = HomeTabPage(
      userId: widget.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMaterialPage(
                            isDownloadedView: true,
                            uid: widget.uid,
                          )));
            },
            icon: const Icon(Icons.bookmark)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ReviZa'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserScreen()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => _changePage(value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload,
            ),
            label: 'upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assistant,
            ),
            label: 'reviza ai',
          ),
        ],
      ),
    );
  }

  void _changePage(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[selectedIndex];
    });
  }
}
