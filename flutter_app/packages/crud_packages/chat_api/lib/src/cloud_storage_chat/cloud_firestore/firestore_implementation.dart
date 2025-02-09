import 'dart:async';

import 'package:chat_api/chat_api.dart';
import 'package:chat_api/src/cloud_storage_chat/cloud_firestore/firestore_chat_controller.dart';
import 'package:chat_api/src/cloud_storage_chat/cloud_firestore/firestore_chatroom_controller.dart';
import 'package:uuid/uuid.dart';

class FirestoreImplementation implements OnlineChat {
  @override
  Future<bool> clearChatRoom({required String chatRoomId}) async {
    try {
      await FirestoreChatController(chatRoom: chatRoomId).deleteChats();
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
      await FirestoreChatController(chatRoom: id).set([]);
      return id;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> deleteMessage(
      {required String chatRoomId, required Message message}) async {
    try {
      await FirestoreChatController(chatRoom: chatRoomId).remove(message);
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
      FirestoreChatController hiveChatController = FirestoreChatController(
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

    FirestoreChatController hiveChatController =
        FirestoreChatController(chatRoom: chatRoomId);
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
      return FirestoreChatController(chatRoom: chatRoomId).messages;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<List<Message>> listenToReplies({required String chatRoomId}) {
    FirestoreChatController hiveChatController =
        FirestoreChatController(chatRoom: chatRoomId);
    return hiveChatController.messagesStream;
  }

  @override
  Future<void> leaveRoom({required String chatRoomId}) async {
    FirestoreChatController(chatRoom: chatRoomId).dispose();
  }

  @override
  Stream<ChatOperation> operationsStream({required String chatRoomId}) {
    return FirestoreChatController(chatRoom: chatRoomId).operationsStream;
  }

  @override
  Future<List<ChatRoom>> fetchAllAIChatRooms({required String uid}) {
    FirestoreChatroomController firestoreChatroomController =
        FirestoreChatroomController();
    return firestoreChatroomController.getAllChatRooms(userId: uid);
  }
}
