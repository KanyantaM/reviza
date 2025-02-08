import 'dart:async';
import 'package:chat_api/src/local_storage_chat/hive/message_streamer.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:hive/hive.dart';

class HiveChatController implements ChatController {
  static const String _boxName = 'ai_chats';
  final String chatRoom;
  late final Box _box;
  late final ListNotifier<Message> _notifier;

  HiveChatController({required this.chatRoom}) {
    _box = Hive.box(_boxName);
    _notifier = ListNotifier<Message>(initialItems: messages);
  }

  final _operationsController = StreamController<ChatOperation>.broadcast();

  @override
  Future<void> insert(Message message, {int? index}) async {
    final List<Map<String, dynamic>> chatMessages = _getChatMessages();
    if (chatMessages.any((m) => m['id'] == message.id)) return;

    if (index == null) {
      chatMessages.add(message.toJson());
      _operationsController
          .add(ChatOperation.insert(message, chatMessages.length - 1));
    } else {
      chatMessages.insert(index, message.toJson());
      _operationsController.add(ChatOperation.insert(message, index));
    }

    _saveChatMessages(chatMessages);
  }

  @override
  Future<void> remove(Message message) async {
    final chatMessages = _getChatMessages();
    final index = chatMessages.indexWhere((m) => m['id'] == message.id);

    if (index > -1) {
      chatMessages.removeAt(index);
      _operationsController.add(ChatOperation.remove(message, index));
      _saveChatMessages(chatMessages);
    }
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    final chatMessages = _getChatMessages();
    final index = chatMessages.indexWhere((m) => m['id'] == oldMessage.id);

    if (index > -1) {
      chatMessages[index] = newMessage.toJson();
      _operationsController.add(ChatOperation.update(oldMessage, newMessage));
      _saveChatMessages(chatMessages);
    }
  }

  @override
  Future<void> set(List<Message> messages) async {
    _saveChatMessages(messages.map((m) => m.toJson()).toList());
    _operationsController.add(ChatOperation.set());
  }

  @override
  List<Message> get messages {
    return _getChatMessages().map((json) => Message.fromJson(json)).toList();
  }

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  Stream<List<Message>> get messagesStream => _notifier.stream;

  Future<void> deleteChats() async {
    _box.delete(chatRoom);
    _notifier.dispose();
  }

  @override
  void dispose() {
    _operationsController.close();
    _notifier.dispose();
  }

  /// Fetch messages for the given chat room from the 'ai_chats' box
  List<Map<String, dynamic>> _getChatMessages() {
    return (_box.get(chatRoom, defaultValue: []) as List)
        .cast<Map<String, dynamic>>();
  }

  /// Save messages for the given chat room in the 'ai_chats' box
  void _saveChatMessages(List<Map<String, dynamic>> messages) {
    _box.put(chatRoom, messages);
    _notifier.addItems(messages.map((json) => Message.fromJson(json)).toList());
  }
}
