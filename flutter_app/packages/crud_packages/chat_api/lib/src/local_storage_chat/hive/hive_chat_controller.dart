import 'dart:async';
import 'package:chat_api/src/local_storage_chat/hive/message_streamer.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:hive/hive.dart';

class HiveChatController implements ChatController {
  static const String _boxName = 'ai_chats';
  final String chatRoom;
  static Box? _box;
  static bool _isInitialized = false;

  late final ListNotifier<Message> _notifier;
  final _operationsController = StreamController<ChatOperation>.broadcast();

  HiveChatController({required this.chatRoom}) {
    _notifier = ListNotifier<Message>(initialItems: messages);
    _ensureInitialized();
  }

  /// Ensures Hive Box is Opened
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox(_boxName);
      } else {
        _box = Hive.box(_boxName);
      }
      _isInitialized = true;
    } catch (e, stackTrace) {
      throw Exception("Error initializing Hive: $e\n$stackTrace");
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  @override
  Future<void> insert(Message message, {int? index}) async {
    await _ensureInitialized();
    try {
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
    } catch (e, stackTrace) {
      throw Exception("Error inserting message: $e\n$stackTrace");
    }
  }

  @override
  Future<void> remove(Message message) async {
    await _ensureInitialized();
    try {
      final chatMessages = _getChatMessages();
      final index = chatMessages.indexWhere((m) => m['id'] == message.id);

      if (index > -1) {
        chatMessages.removeAt(index);
        _operationsController.add(ChatOperation.remove(message, index));
        _saveChatMessages(chatMessages);
      }
    } catch (e, stackTrace) {
      throw Exception("Error removing message: $e\n$stackTrace");
    }
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    await _ensureInitialized();
    try {
      final chatMessages = _getChatMessages();
      final index = chatMessages.indexWhere((m) => m['id'] == oldMessage.id);

      if (index > -1) {
        chatMessages[index] = newMessage.toJson();
        _operationsController.add(ChatOperation.update(oldMessage, newMessage));
        _saveChatMessages(chatMessages);
      }
    } catch (e, stackTrace) {
      throw Exception("Error updating message: $e\n$stackTrace");
    }
  }

  @override
  Future<void> set(List<Message> messages) async {
    await _ensureInitialized();
    try {
      _saveChatMessages(messages.map((m) => m.toJson()).toList());
      _operationsController.add(ChatOperation.set());
    } catch (e, stackTrace) {
      throw Exception("Error setting messages: $e\n$stackTrace");
    }
  }

  @override
  List<Message> get messages {
    try {
      final List<Message> messages =
          _getChatMessages().map((json) => Message.fromJson(json)).toList();
      return messages;
    } catch (e, stackTrace) {
      throw Exception("Error geting chat: $e\n$stackTrace");
    }
  }

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  Stream<List<Message>> get messagesStream => _notifier.stream;

  Future<void> deleteChats() async {
    await _ensureInitialized();
    try {
      _box?.delete(chatRoom);
      _notifier.dispose();
    } catch (e, stackTrace) {
      throw Exception("Error deleting chat: $e\n$stackTrace");
    }
  }

  @override
  void dispose() {
    _operationsController.close();
    _notifier.dispose();
  }

  List<Map<String, dynamic>> _getChatMessages() {
    try {
      final data = _box?.get(chatRoom);
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } catch (e, stackTrace) {
      throw Exception("Error getting chat messages: $e\n$stackTrace");
    }
  }

  /// Save messages for the given chat room in the 'ai_chats' box
  void _saveChatMessages(List<Map<String, dynamic>> messages) {
    try {
      _box?.put(chatRoom, messages);
      _notifier
          .addItems(messages.map((json) => Message.fromJson(json)).toList());
    } catch (e, stackTrace) {
      throw Exception("Error saving messages: $e\n$stackTrace");
    }
  }
}
