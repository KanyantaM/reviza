import 'package:chat_api/src/models/chat_room.dart';
import 'package:hive/hive.dart';

class HiveChatRoomController {
  static final Box<ChatRoom> _chatBox = Hive.box<ChatRoom>('ai_chats');

  /// Create or Update a Chat Room
  Future<void> addOrUpdateChatRoom(ChatRoom room) async {
    await _chatBox.put(room.id, room);
  }

  /// Read a Single Chat Room
  static ChatRoom? getChatRoom(String id) {
    return _chatBox.get(id);
  }

  /// Read All Chat Rooms
  List<ChatRoom> getAllChatRooms() {
    return _chatBox.values.toList();
  }

  /// Update Chat Room Name
  Future<void> updateChatRoomName(String id, String newName) async {
    ChatRoom? room = _chatBox.get(id);
    if (room != null) {
      room.name = newName;
      await room.save();
    }
  }

  /// Add a Member to a Chat Room
  Future<void> addMember(String chatRoomId, String userId) async {
    ChatRoom? room = _chatBox.get(chatRoomId);
    if (room != null) {
      room.joinRoom(userId);
      await room.save();
    }
  }

  /// Remove a Member from a Chat Room
  Future<void> removeMember(String chatRoomId, String userId) async {
    ChatRoom? room = _chatBox.get(chatRoomId);
    if (room != null) {
      room.leaveGroup(userId);
      await room.save();
    }
  }

  /// Delete a Chat Room
  Future<void> deleteChatRoom(String id) async {
    await _chatBox.delete(id);
  }

  /// Delete All Chat Rooms
  Future<void> clearAllChatRooms() async {
    await _chatBox.clear();
  }
}
