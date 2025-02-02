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
  final List<Content> chats = [];

  bool get loading => _loading;
  set loading(bool set) => setState(() => _loading = set);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                        ),
                      ),
                    )
                  : const Center(child: Text('Search something!')),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    selectedImage!,
                    fit: BoxFit.cover,
                    width: constraints.maxWidth * 0.9,
                  ),
                ),
              ),
            if (loading) Lottie.asset('assets/lottie/loadingteal.json'),
            ChatInputBox(
              controller: controller,
              onClickCamera: () => _showImagePickerDialog(context),
              onSend: _sendMessage,
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Selection'),
          content: const Text('Choose an image source.'),
          actions: [
            TextButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final XFile? photo = await picker.pickImage(source: source);
    if (photo != null) {
      selectedImage = await photo.readAsBytes();
      setState(() {});
    }
  }

  void _sendMessage() async {
    if (controller.text.isNotEmpty) {
      final text = controller.text;
      controller.clear();
      chats.add(Content(role: 'user', parts: [Part.text(text)]));
      loading = true;

      if (selectedImage == null) {
        final response = await gemini.chat(chats);
        chats.add(
            Content(role: 'model', parts: [Part.text(response?.output ?? '')]));
      } else {
        final response = await gemini
            .prompt(parts: [Part.text(text), Part.uint8List(selectedImage!)]);
        chats.add(
            Content(role: 'model', parts: [Part.text(response?.output ?? '')]));
        selectedImage = null;
      }
      loading = false;
    }
  }

  Widget chatItem(BuildContext context, int index) {
    final content = chats[index];
    final isUser = content.role == 'user';
    String text = content.parts?.last is TextPart
        ? (content.parts!.last as TextPart).text
        : '';
    List<String> parts = text.split('```');

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Text(
              'ReviZa AI',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: parts.length,
            itemBuilder: (context, i) {
              if (i % 2 == 0) {
                return Markdown(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: parts[i],
                );
              } else {
                final codeText = parts[i];
                final newLineIndex = codeText.indexOf('\n');
                final language = newLineIndex != -1
                    ? codeText.substring(0, newLineIndex)
                    : '';
                final code = newLineIndex != -1
                    ? codeText.substring(newLineIndex + 1)
                    : codeText;
                return HighlightView(
                  code,
                  language: language,
                  theme: githubTheme,
                  textStyle: const TextStyle(fontSize: 16.0),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
