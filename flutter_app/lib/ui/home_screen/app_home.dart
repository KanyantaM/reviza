import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.io) 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:reviza/features/ai_chat_screen/sections/chat.dart';
import 'package:reviza/features/edit_courses/view/home_tab_page.dart';
import 'package:reviza/features/upload_pdf/upload_pdf.dart';
import 'package:reviza/features/view_subjects/view_subjects.dart';
import 'package:reviza/features/user_screen.dart';

class MyHomePage extends StatefulWidget {
  final String uid;
  const MyHomePage({super.key, required this.uid});

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
      ..add(HomeTabPage(userId: widget.uid))
      ..add(UploadPdfPage(uid: widget.uid))
      ..add(AIChatScreen(
        userId: widget.uid,
      ))
      ..add(ViewMaterialPage(isDownloadedView: true, uid: widget.uid))
      ..add(UserScreen());
    _currentPage = HomeTabPage(userId: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : shouldUseBottomNavBar()
              ? AppBar(
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
                  title: const Text('ReviZa'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserScreen()));
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                )
              : null,
      body: Row(
        children: [
          if (shouldShowSidebar(context)) buildSidebar(),
          Expanded(child: _currentPage),
        ],
      ),
      bottomNavigationBar: shouldUseBottomNavBar()
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _changePage,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.upload), label: 'Upload'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assistant), label: 'Reviza AI'),
              ],
            )
          : null,
      drawer: shouldUseDrawer(context) ? buildDrawer() : null,
    );
  }

  void _changePage(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[selectedIndex];
    });
  }

  bool shouldUseBottomNavBar() {
    if (kIsWeb) return false; // Web should NOT use bottom nav bar
    return Platform.isAndroid || Platform.isIOS;
  }

  bool shouldShowSidebar(BuildContext context) {
    return !shouldUseBottomNavBar() && MediaQuery.of(context).size.width > 800;
  }

  bool shouldUseDrawer(BuildContext context) {
    return kIsWeb && MediaQuery.of(context).size.width <= 800;
  }

  Widget buildSidebar() {
    return NavigationRail(
      selectedIndex: _currentIndex,
      onDestinationSelected: _changePage,
      labelType: NavigationRailLabelType.all,
      minWidth: 72, // Adjusts sidebar width
      backgroundColor: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest, // Stylish background
      leading: Column(
        children: [
          const SizedBox(height: 16), // Top spacing
          Image.asset(
            'assets/images/logo.jpeg',
            width: 50, // Larger, better visibility
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            'ReviZA',
            style: Theme.of(context).textTheme.titleMedium, // Themed text
          ),
          const SizedBox(height: 16),
          const Divider(), // Separates logo from menu
        ],
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.upload_outlined),
          selectedIcon: Icon(Icons.upload),
          label: Text('Upload'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assistant_outlined),
          selectedIcon: Icon(Icons.assistant),
          label: Text('Reviza AI'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bookmark_outline),
          selectedIcon: Icon(Icons.bookmark),
          label: Text('Downloads'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text("Menu", style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => _changePage(0),
          ),
          ListTile(
            leading: Icon(Icons.upload),
            title: Text("Upload"),
            onTap: () => _changePage(1),
          ),
          ListTile(
            leading: Icon(Icons.assistant),
            title: Text("Reviza AI"),
            onTap: () => _changePage(2),
          ),
        ],
      ),
    );
  }
}
