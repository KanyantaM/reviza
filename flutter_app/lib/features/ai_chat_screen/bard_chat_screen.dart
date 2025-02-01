import 'package:flutter/material.dart';
import 'package:reviza/features/ai_chat_screen/sections/chat.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AiScreen> {
  // final int _selectedItem = 2;

  final _sections = <SectionItem>[
    SectionItem(2, 'chat', const SectionChat()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   centerTitle: true,
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(_selectedItem == 2
      //       ? 'ReviZa AI'
      //       : _sections[_selectedItem].title),
      // ),
      body: IndexedStack(
        index: 0,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
