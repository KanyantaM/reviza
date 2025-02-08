import 'package:chat_api/src/chat_abstract.dart';
import 'package:chat_api/src/models/chat_room.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

abstract class OnlineChat implements ChatApi {
  @override
  Stream<MessageState> addMessage(
      {required Message message, required String chatRoomId});

  @override
  Future<bool> clearChatRoom({required String chatRoomId});

  @override
  Future<String> createChatRoom();

  @override
  Future<bool> deleteMessage(
      {required String chatRoomId, required Message message});

  @override
  Stream<List<Message>> listenToReplies({required String chatRoomId});

  @override
  Future<List<Message>> fetchChatRoom({required String chatRoomId});

  @override
  Future<bool> updateChatRoom({
    required String chatRoomId,
    required List<Message> chats,
  });

  @override
  Future<void> leaveRoom({required String chatRoomId});

  @override
  Future<List<ChatRoom>> fetchAllAIChatRooms({required String uid});

  @override
  Stream<ChatOperation> operationsStream({required String chatRoomId});
}
