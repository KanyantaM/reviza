import 'package:chat_api/src/models/chat_room.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

///bacically you should be able to perform crud operations:

abstract class ChatApi {
  /// this takes in the message to be added the the database
  Stream<MessageState> addMessage({
    required Message message,
    required String chatRoomId,
  });

  ///Listens to replies, that is chat's been added to the database.
  ///This means that the app should first save the data to the storage before showing it to the user.
  Stream<List<Message>> listenToReplies({
    required String chatRoomId,
  });

  ///This function should create a chat room and return to the user a string of the chat room id
  Future<String> createChatRoom();

  ///this is used to set an entire chat room, this is a bulk operation
  Future<bool> updateChatRoom({
    required String chatRoomId,
    required List<Message> chats,
  });

  ///bulk fetch chats from a chat room
  Future<List<Message>> fetchChatRoom({
    required String chatRoomId,
  });

  ///fetch all chat rooms
  Future<List<ChatRoom>> fetchAllAIChatRooms({
    required String uid,
  });

  ///clears an entire chat (chat room)
  Future<bool> clearChatRoom({
    required String chatRoomId,
  });

  /// deletes a single message
  Future<bool> deleteMessage({
    required String chatRoomId,
    required Message message,
  });

  /// leaving a chat room, but not deleting it
  Future<void> leaveRoom({required String chatRoomId});

  //todo: understand this
  Stream<ChatOperation> operationsStream({required String chatRoomId});
}

///This is the status of the message communication that
enum MessageState { typing, sent, recieved, read, loading, failed }
