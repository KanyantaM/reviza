import 'dart:async';
import 'package:chat_api/src/chat_abstract.dart';
import 'package:chat_api/src/local_storage_chat/hive/hive_chat_controller.dart';
import 'package:chat_api/src/local_storage_chat/hive/hive_chatroom_controller.dart';
import 'package:chat_api/src/local_storage_chat/local_chat.dart';
import 'package:chat_api/src/models/chat_room.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';

class HiveImplementation implements LocalChat {
  @override
  Future<bool> clearChatRoom({required String chatRoomId}) async {
    try {
      await HiveChatController(chatRoom: chatRoomId).deleteChats();
      return true;
    } catch (e, stacktrace) {
      throw Exception('Error clearing chat room: $e\n$stacktrace');
    }
  }

  @override
  Future<String> createChatRoom() async {
    Uuid uuid = Uuid();
    String id = uuid.v4();
    try {
      await HiveChatController(chatRoom: id).set([]);
      return id;
    } catch (e, stacktrace) {
      throw Exception('Error creating chat room: $e\n$stacktrace');
    }
  }

  @override
  Future<bool> deleteMessage(
      {required String chatRoomId, required Message message}) async {
    try {
      await HiveChatController(chatRoom: chatRoomId).remove(message);
      return true;
    } catch (e, stacktrace) {
      throw Exception('Error deleting message: $e\n$stacktrace');
    }
  }

  @override
  Future<bool> updateChatRoom(
      {required String chatRoomId, required List<Message> chats}) async {
    try {
      HiveChatController hiveChatController =
          HiveChatController(chatRoom: chatRoomId);
      await hiveChatController.set(chats);
      return true;
    } catch (e, stacktrace) {
      throw Exception('Error updating chat room: $e\n$stacktrace');
    }
  }

  @override
  Stream<MessageState> addMessage(
      {required Message message, required String chatRoomId}) {
    final StreamController<MessageState> messageStateController =
        StreamController();
    messageStateController.add(MessageState.loading);
    HiveChatController hiveChatController =
        HiveChatController(chatRoom: chatRoomId);
    try {
      hiveChatController.insert(message);
      messageStateController.add(MessageState.sent);
    } catch (e, stacktrace) {
      throw Exception('Error adding message: $e\n$stacktrace');
    }
    return messageStateController.stream;
  }

  @override
  Future<List<Message>> fetchChatRoom({required String chatRoomId}) async {
    try {
      return HiveChatController(chatRoom: chatRoomId).messages;
    } catch (e, stacktrace) {
      throw Exception('Error fetching chat room messages: $e\n$stacktrace');
    }
  }

  @override
  Stream<List<Message>> listenToReplies({required String chatRoomId}) {
    try {
      return HiveChatController(chatRoom: chatRoomId).messagesStream;
    } catch (e, stacktrace) {
      throw Exception('Error listening to replies: $e\n$stacktrace');
    }
  }

  @override
  Future<void> leaveRoom({required String chatRoomId}) async {
    try {
      HiveChatController(chatRoom: chatRoomId).dispose();
    } catch (e, stacktrace) {
      throw Exception('Error leaving room: $e\n$stacktrace');
    }
  }

  @override
  Stream<ChatOperation> operationsStream({required String chatRoomId}) {
    try {
      return HiveChatController(chatRoom: chatRoomId).operationsStream;
    } catch (e, stacktrace) {
      throw Exception('Error getting operations stream: $e\n$stacktrace');
    }
  }

  @override
  Future<List<ChatRoom>> fetchAllAIChatRooms({required String uid}) async {
    try {
      return HiveChatRoomController.getAllChatRooms();
    } catch (e, stacktrace) {
      throw Exception('Error fetching AI chat rooms: $e\n$stacktrace');
    }
  }
}
