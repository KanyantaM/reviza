import 'package:flutter/material.dart';
import 'package:reviza/features/ai_chat_screen/sections/chat.dart';
import 'package:reviza/features/ai_chat_screen/sections/embed_batch_contents.dart';
import 'package:reviza/features/ai_chat_screen/sections/embed_content.dart';
import 'package:reviza/features/ai_chat_screen/sections/response_widget_stream.dart';
import 'package:reviza/features/ai_chat_screen/sections/stream.dart';
import 'package:reviza/features/ai_chat_screen/sections/text_and_image.dart';
import 'package:reviza/features/ai_chat_screen/sections/text_only.dart';

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
  final int _selectedItem = 2;

  final _sections = <SectionItem>[
    SectionItem(0, 'Stream text', const SectionTextStreamInput()),
    SectionItem(1, 'textAndImage', const SectionTextAndImageInput()),
    SectionItem(2, 'chat', const SectionChat()),
    SectionItem(3, 'text', const SectionTextInput()),
    SectionItem(4, 'embedContent', const SectionEmbedContent()),
    SectionItem(5, 'batchEmbedContents', const SectionBatchEmbedContents()),
    SectionItem(
        6, 'response without setState()', const ResponseWidgetSection()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_selectedItem == 2
            ? 'ReviZa AI'
            : _sections[_selectedItem].title),
      ),
      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}