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
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> createChatRoom() async {
    Uuid uuid = Uuid();

    String id = uuid.v4();

    try {
      await HiveChatController(chatRoom: id).set([]);
      return id;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> deleteMessage(
      {required String chatRoomId, required Message message}) async {
    try {
      await HiveChatController(chatRoom: chatRoomId).remove(message);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> updateChatRoom({
    required String chatRoomId,
    required List<Message> chats,
  }) async {
    try {
      HiveChatController hiveChatController = HiveChatController(
        chatRoom: chatRoomId,
      );
      await hiveChatController.set(chats);
      return true;
    } catch (e) {
      Exception(e);
      return false;
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
      return messageStateController.stream;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Message>> fetchChatRoom({required String chatRoomId}) async {
    try {
      return HiveChatController(chatRoom: chatRoomId).messages;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<List<Message>> listenToReplies({required String chatRoomId}) {
    HiveChatController hiveChatController =
        HiveChatController(chatRoom: chatRoomId);
    return hiveChatController.messagesStream;
  }

  @override
  Future<void> leaveRoom({required String chatRoomId}) async {
    HiveChatController(chatRoom: chatRoomId).dispose();
  }

  @override
  Stream<ChatOperation> operationsStream({required String chatRoomId}) {
    return HiveChatController(chatRoom: chatRoomId).operationsStream;
  }

  @override
  Future<List<ChatRoom>> fetchAllAIChatRooms({required String uid}) async {
    HiveChatRoomController hiveChatRoomController = HiveChatRoomController();
    return hiveChatRoomController.getAllChatRooms();
  }
}
