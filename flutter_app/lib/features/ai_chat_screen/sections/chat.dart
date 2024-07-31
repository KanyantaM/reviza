import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:reviza/features/ai_chat_screen/widgets/chat_input_box.dart';

class SectionChat extends StatefulWidget {
  const SectionChat({super.key});

  @override
  State<SectionChat> createState() => _SectionChatState();
}

class _SectionChatState extends State<SectionChat> {
  final ImagePicker picker = ImagePicker();
  Uint8List? selectedImage;
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: chats.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      reverse: true,
                      child: ListView.builder(
                        itemBuilder: chatItem,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chats.length,
                        reverse: false,
                      ),
                    ),
                  )
                : const Center(child: Text('Search something!'))),
        if (selectedImage != null)
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.memory(
                selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (loading) Lottie.asset('assets/lottie/loadingteal.json'),
        ChatInputBox(
          controller: controller,
          onClickCamera: () async {
            showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Text('Image Selection'),
                    content: const Text(
                        'Do you want to use your camera or select an image from the gallery?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // Capture a photo.
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera);

                          if (photo != null) {
                            photo.readAsBytes().then((value) => setState(() {
                                  selectedImage = value;
                                }));
                          }
                        },
                        child: const Text('Camera'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // Capture a photo.
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (photo != null) {
                            photo.readAsBytes().then((value) => setState(() {
                                  selectedImage = value;
                                }));
                          }
                        },
                        child: const Text('Gallery'),
                      ),
                    ],
                  );
                }));
          },
          onSend: () async {
            if (controller.text.isNotEmpty) {
              final searchedText = controller.text;
              if (selectedImage == null) {
                chats.add(
                    Content(role: 'user', parts: [Parts(text: searchedText)]));
                controller.clear();
                loading = true;

                gemini.chat(chats).then((value) {
                  chats.add(Content(
                      role: 'model', parts: [Parts(text: value?.output)]));
                  loading = false;
                });
              } else {
                chats.add(
                    Content(role: 'user', parts: [Parts(text: searchedText)]));
                controller.clear();
                loading = true;

                gemini.textAndImage(
                    text: searchedText, images: [selectedImage!]).then((value) {
                  chats.add(Content(
                      role: 'model', parts: [Parts(text: value?.output)]));
                  loading = false;
                  selectedImage = null;
                });
              }
            }
          },
        ),
      ],
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];
    final bool isUserMessage = content.role == 'user';

    String text = content.parts?.lastOrNull?.text ?? 'cannot generate data!';
    List<String> parts = text.split('```');

    return Card(
      elevation: 0,
      color: !isUserMessage
          ? Theme.of(context).colorScheme.inversePrimary
          : Theme.of(context).colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: isUserMessage
              ? const Radius.circular(16.0)
              : const Radius.circular(0),
          topRight: isUserMessage
              ? const Radius.circular(0)
              : const Radius.circular(16.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              content.role?.replaceAll('model', 'ReviZa AI') ?? 'role',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            isUserMessage
                ? Markdown(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: text,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parts.length,
                    itemBuilder: (BuildContext context, int i) {
                      if (i % 2 == 0) {
                        return readText(context, parts[i]);
                      } else {
                        return HighlightView(
                          parts[i].substring(parts[i].indexOf('\n') + 1),
                          language: parts[i].split('\n').first,
                          theme: githubTheme,
                          textStyle: const TextStyle(fontSize: 16.0),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget readText(BuildContext context, String text) {
    List<String> divides = text.split(RegExp(r'\$\$'));

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < divides.length; i++)
              if (i % 2 == 0)
                Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: divides[i],
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    divides[i],
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                )
          ],
        ),
      ),
    );
  }

  Widget extractInlineLatex(BuildContext context, String text) {
    List<String> divides = text.split(RegExp(r'\(|\)'));

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.inversePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < divides.length; i++)
              if (i % 2 == 0)
                Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: divides[i],
                )
              else
                Math.tex(
                  divides[i],
                  textStyle: const TextStyle(fontSize: 16.0),
                )
          ],
        ),
      ),
    );
  }
}
