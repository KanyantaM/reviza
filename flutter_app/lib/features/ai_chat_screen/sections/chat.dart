import 'package:cross_cache/cross_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reviza/features/ai_chat_screen/sections/controller/reviza_chat_controller.dart';
import 'package:uuid/uuid.dart';

import 'widgets/input_action_bar.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({
    super.key,
  });

  @override
  AIChatScreenState createState() => AIChatScreenState();
}

class AIChatScreenState extends State<AIChatScreen> {
  final _uuid = const Uuid();
  final _crossCache = CrossCache();
  final _scrollController = ScrollController();

  final _currentUser = const User(id: 'me');
  final _agent = const User(id: 'agent');

  late final ChatController _chatController;
  late final GenerativeModel _model;
  late ChatSession _chatSession;
  Message? _currentGeminiResponse;

  @override
  void initState() {
    super.initState();
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    _chatController =
        ReviZaChatRoomController(chatRoomId: ChatRoomVariable.chatRoomId);
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
    );

    _chatSession = _model.startChat(
      history: _chatController.messages
          .whereType<TextMessage>()
          .map((message) => Content.text(message.text))
          .toList(),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _crossCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Chat(
        builders: Builders(
          chatAnimatedListBuilder: (context, itemBuilder) {
            return ChatAnimatedList(
              scrollController: _scrollController,
              itemBuilder: itemBuilder,
              shouldScrollToEndWhenAtBottom: false,
            );
          },
          imageMessageBuilder: (context, message, index) =>
              FlyerChatImageMessage(message: message, index: index),
          inputBuilder: (context) => ChatInput(
            topWidget: InputActionBar(
              buttons: [
                InputActionButton(
                  icon: Icons.delete_sweep,
                  title: 'Clear all',
                  onPressed: () {
                    _chatController.set([]);
                    _chatSession = _model.startChat();
                  },
                  destructive: true,
                ),
              ],
            ),
          ),
          textMessageBuilder: (context, message, index) =>
              FlyerChatTextMessage(message: message, index: index),
        ),
        chatController: _chatController,
        crossCache: _crossCache,
        currentUserId: _currentUser.id,
        onAttachmentTap: _handleAttachmentTap,
        onMessageSend: _handleMessageSend,
        resolveUser: (id) => Future.value(
          switch (id) {
            'me' => _currentUser,
            'agent' => _agent,
            _ => null,
          },
        ),
        theme: ChatTheme.fromThemeData(theme),
      ),
    );
  }

  void _handleMessageSend(String text) async {
    await _chatController.insert(
      TextMessage(
        id: _uuid.v4(),
        authorId: _currentUser.id,
        createdAt: DateTime.now().toUtc(),
        text: text,
        isOnlyEmoji: isOnlyEmoji(text),
      ),
    );

    final content = Content.text(text);
    _sendContent(content);
  }

  void _handleAttachmentTap() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await _crossCache.downloadAndSave(image.path);

    await _chatController.insert(
      ImageMessage(
        id: _uuid.v4(),
        authorId: _currentUser.id,
        createdAt: DateTime.now().toUtc(),
        source: image.path,
      ),
    );

    final bytes = await _crossCache.get(image.path);

    final content = Content.data('image/jpeg', bytes);
    _sendContent(content);
  }

  void _sendContent(Content content) async {
    try {
      final response = _chatSession.sendMessageStream(content);

      var accumulatedText = '';
      double? initialMaxScrollExtent;
      var hasReachedTargetScroll = false;

      await for (final chunk in response) {
        if (chunk.text != null) {
          initialMaxScrollExtent ??= _scrollController.position.maxScrollExtent;

          accumulatedText += chunk.text!;

          if (_currentGeminiResponse == null) {
            _currentGeminiResponse = TextMessage(
              id: _uuid.v4(),
              authorId: _agent.id,
              createdAt: DateTime.now().toUtc(),
              text: accumulatedText,
              isOnlyEmoji: isOnlyEmoji(accumulatedText),
            );
            await _chatController.insert(_currentGeminiResponse!);
          } else {
            final newUpdatedMessage = (_currentGeminiResponse as TextMessage)
                .copyWith(text: accumulatedText);
            await _chatController.update(
              _currentGeminiResponse!,
              newUpdatedMessage,
            );
            _currentGeminiResponse = newUpdatedMessage;

            if (!hasReachedTargetScroll && initialMaxScrollExtent > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_scrollController.hasClients || !mounted) return;

                final targetScroll = (initialMaxScrollExtent ?? 0) +
                    _scrollController.position.viewportDimension -
                    MediaQuery.of(context).padding.bottom -
                    104 -
                    20;

                if (_scrollController.position.maxScrollExtent > targetScroll) {
                  _scrollController.animateTo(
                    targetScroll,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.linearToEaseOut,
                  );
                  hasReachedTargetScroll = true;
                } else {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.linearToEaseOut,
                  );
                }
              });
            }
          }
        }
      }

      _currentGeminiResponse = null;
    } on GenerativeAIException catch (error) {
      debugPrint('Generation error $error');
    }
  }
}

class ChatRoomVariable {
  static String _chatRoomId = '';

  static set updateChatRoomId(String id) => _chatRoomId = id;

  static String get chatRoomId => _chatRoomId;
}
