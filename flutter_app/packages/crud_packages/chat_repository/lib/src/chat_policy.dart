import 'package:chat_api/chat_api.dart';

class ChatRepository {
  final LocalChat _localChat;
  final OnlineChat _onlineChat;

  ChatRepository({
    required LocalChat localChat,
    required OnlineChat onlineChat,
  })  : _localChat = localChat,
        _onlineChat = onlineChat;

  /// Cache-first fetching of messages
  Future<List<Message>> fetchChatRoom(String chatRoomId) async {
    List<Message> cachedMessages =
        await _localChat.fetchChatRoom(chatRoomId: chatRoomId);

    if (cachedMessages.isNotEmpty) {
      return cachedMessages;
    }

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

  /// Sends a message, caching it first, then syncing online
  Stream<MessageState> sendMessage(Message message, String chatRoomId) {
    Stream<MessageState> state =
        _localChat.addMessage(message: message, chatRoomId: chatRoomId);
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

      var onlineMessages =
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
    List<Message> cachedMessages =
        await _localChat.fetchChatRoom(chatRoomId: chatRoomId);

    if (cachedMessages.isNotEmpty) {
      _localChat.leaveRoom(chatRoomId: chatRoomId);
    }

    List<Message> onlineMessages =
        await _onlineChat.fetchChatRoom(chatRoomId: chatRoomId);

    if (onlineMessages.isNotEmpty) {
      _onlineChat.leaveRoom(chatRoomId: chatRoomId);
    }
  }

  Stream<ChatOperation> fetchChatRoomOperations(String chatRoomId) async* {
    Stream<ChatOperation> cachedStream =
        _localChat.operationsStream(chatRoomId: chatRoomId);
    bool hasCache = await cachedStream.isEmpty.then((isEmpty) => !isEmpty);

    if (hasCache) {
      yield* cachedStream;
    } else {
      Stream<ChatOperation> onlineStream =
          _onlineChat.operationsStream(chatRoomId: chatRoomId);

      await for (var operation in onlineStream) {
        //todo: Store data in cache (assuming _localChat has a method to save operations)
        yield operation;
      }
    }
  }
}
