import 'package:chat_api/chat_api.dart';

class ChatRepository {
  final LocalChat _localChat;
  final OnlineChat _onlineChat;

  ChatRepository({
    required LocalChat localChat,
    required OnlineChat onlineChat,
  })  : _localChat = localChat,
        _onlineChat = onlineChat;

  String _uuid = '';

  /// Cache-first fetching of messages
  Future<List<Message>> fetchChatRoom(String chatRoomId) async {
    if (chatRoomId.isEmpty) {
      _uuid = await _localChat.createChatRoom();

      await _onlineChat.fetchChatRoom(chatRoomId: _uuid);

      return [];
    }
    List<Message> cachedMessages =
        await _localChat.fetchChatRoom(chatRoomId: chatRoomId);

    if (cachedMessages.isNotEmpty) {
      return cachedMessages;
    } else {
      List<Message> onlineMessages =
          await _onlineChat.fetchChatRoom(chatRoomId: chatRoomId);

      if (onlineMessages.isNotEmpty) {
        await _localChat.updateChatRoom(
          chatRoomId: chatRoomId,
          chats: onlineMessages,
        );
      }
      return onlineMessages;
    }
  }

  /// Sends a message, caching it first, then syncing online
  Stream<MessageState> sendMessage(Message message, String chatRoomId) {
    Stream<MessageState> state = _localChat.addMessage(
        message: message,
        chatRoomId: (chatRoomId.isEmpty) ? _uuid : chatRoomId);
    // _onlineChat
    //     .addMessage(message: message, chatRoomId: chatRoomId)
    //     .listen((state) {
    //   if (state == MessageState.failure) {
    //     // Handle failure (e.g., mark as unsynced)
    //   }
    // });
    return state;
  }

  /// Deletes a message from cache first, then from online storage
  Future<bool> deleteMessage(Message message, String chatRoomId) async {
    bool deletedLocally = await _localChat.deleteMessage(
        chatRoomId: chatRoomId, message: message);

    if (deletedLocally) {
      return await _onlineChat.deleteMessage(
          chatRoomId: chatRoomId, message: message);
    }

    return false;
  }

  /// Listen to chat updates, prioritizing cache
  Stream<List<Message>> listenToChat(String chatRoomId) {
    return _localChat
        .listenToReplies(chatRoomId: chatRoomId)
        .asyncExpand((cachedMessages) async* {
      yield cachedMessages;

      List<Message> onlineMessages =
          await _onlineChat.fetchChatRoom(chatRoomId: chatRoomId);
      if (onlineMessages.isNotEmpty) {
        await _localChat.updateChatRoom(
            chatRoomId: chatRoomId, chats: onlineMessages);
        yield onlineMessages;
      }
    });
  }

  /// Cache-first fetching of messages
  Future<void> leaveChatRoom(String chatRoomId) async {
    String chatId = (chatRoomId.isEmpty) ? _uuid : chatRoomId;
    List<Message> cachedMessages =
        await _localChat.fetchChatRoom(chatRoomId: chatId);

    if (cachedMessages.isNotEmpty) {
      _localChat.leaveRoom(chatRoomId: chatId);
    }

    List<Message> onlineMessages =
        await _onlineChat.fetchChatRoom(chatRoomId: chatId);

    if (onlineMessages.isNotEmpty) {
      _onlineChat.leaveRoom(chatRoomId: chatRoomId);
    }
  }

  Stream<ChatOperation> fetchChatRoomOperations(String chatRoomId) {
    return _localChat.operationsStream(chatRoomId: chatRoomId);
  }

  //getting all chatrooms with a cached first approach
  Future<List<ChatRoom>> fetchAllChatRooms(String chatRoomId,
      {String? uid}) async {
    List<ChatRoom> cachedRooms =
        await _localChat.fetchAllAIChatRooms(uid: uid ?? '');

    if (cachedRooms.isNotEmpty) {
      return cachedRooms;
    }

    List<ChatRoom> onlineRooms =
        await _onlineChat.fetchAllAIChatRooms(uid: uid ?? '');

    if (onlineRooms.isNotEmpty) {
      return onlineRooms;
    }

    return [];
  }

  Future<void> updateChatRoom(
      {required String chatRoomId, required List<Message> chats}) async {
    try {
      _localChat.updateChatRoom(chatRoomId: chatRoomId, chats: chats);
    } catch (e) {
      throw Exception(e);
    }
    try {
      _onlineChat.updateChatRoom(chatRoomId: chatRoomId, chats: chats);
    } catch (e) {
      throw Exception(e);
    }
  }
}
