import 'package:chat_repository/chat_repository.dart';

class ReviZaChatRoomController implements ChatController {
  final String chatRoomId;
  late final ChatRepository _chatRepository;

  ReviZaChatRoomController({required this.chatRoomId}) {
    _chatRepository = ChatRepository(
        localChat: HiveImplementation(), onlineChat: FirestoreImplementation());
  }

  @override
  void dispose() {
    _chatRepository.leaveChatRoom(chatRoomId);
  }

  @override
  Future<void> insert(Message message, {int? index}) async {
    _chatRepository.sendMessage(message, chatRoomId);
  }

  List<Message> _chats = [];

  Future<void> _loadChats() async {
    _chats = await _chatRepository.fetchChatRoom(chatRoomId);
  }

  @override
  List<Message> get messages {
    _loadChats();
    return _chats;
  }

  @override
  Stream<ChatOperation> get operationsStream =>
      _chatRepository.fetchChatRoomOperations(chatRoomId);

  @override
  Future<void> remove(Message message) async {
    await _chatRepository.deleteMessage(message, chatRoomId);
  }

  @override
  Future<void> set(List<Message> messages) async {
    await _chatRepository.updateChatRoom(
        chatRoomId: chatRoomId, chats: messages);
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    //todo:
    UnimplementedError('Not implemented');
  }

  Future<List<ChatRoom>> fetchChatRooms() async {
    return ChatRepository(
            localChat: HiveImplementation(),
            onlineChat: FirestoreImplementation())
        .fetchAllChatRooms(chatRoomId);
  }
}
