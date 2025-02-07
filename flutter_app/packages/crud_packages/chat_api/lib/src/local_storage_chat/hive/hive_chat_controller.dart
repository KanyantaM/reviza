import 'dart:async';

import 'package:chat_api/src/local_storage_chat/hive/message_streamer.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:hive/hive.dart';

class HiveChatController implements ChatController {
  final String chatRoom;
  late final Box _box;
  late final ListNotifier<Message> _notifier;

  HiveChatController({required this.chatRoom}) {
    _box = Hive.box(chatRoom);
    _notifier = ListNotifier<Message>(initialItems: messages);
  }

  final _operationsController = StreamController<ChatOperation>.broadcast();

  @override
  Future<void> insert(Message message, {int? index}) async {
    if (_box.containsKey(message.id)) return;

    if (index == null) {
      _box.put(message.id, message.toJson());
      _operationsController.add(
        ChatOperation.insert(message, _box.length - 1),
      );
    } else {
      _box.putAt(index, message.toJson());
      _operationsController.add(ChatOperation.insert(message, index));
    }

    _notifier.addItems(messages);
  }

  @override
  Future<void> remove(Message message) async {
    final index = _box.values
        .map((json) => Message.fromJson(json))
        .toList()
        .indexOf(message);

    if (index > -1) {
      _box.deleteAt(index);
      _operationsController.add(ChatOperation.remove(message, index));
    }
    _notifier.addItems(messages);
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    if (oldMessage == newMessage) return;

    final index = _box.values
        .map((json) => Message.fromJson(json))
        .toList()
        .indexOf(oldMessage);

    if (index > -1) {
      _box.putAt(index, newMessage.toJson());
      _operationsController.add(ChatOperation.update(oldMessage, newMessage));
    }

    _notifier.addItems(messages);
  }

  @override
  Future<void> set(List<Message> messages) async {
    _box.clear();
    if (messages.isEmpty) {
      _operationsController.add(ChatOperation.set());
      return;
    } else {
      _box.putAll(
        messages
            .map((message) => {message.id: message.toJson()})
            .toList()
            .reduce((acc, map) => {...acc, ...map}),
      );
      _operationsController.add(ChatOperation.set());
    }
    _notifier.addItems(messages);
  }

  @override
  List<Message> get messages {
    return _box.values.map((json) => Message.fromJson(json)).toList();
  }

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  Stream<List<Message>> get messagesStream => _notifier.stream;

  Future<void> deleteChats() async {
    _box.clear();
    _notifier.dispose();
  }

  @override
  void dispose() {
    _operationsController.close();
    _notifier.dispose();
  }
}
