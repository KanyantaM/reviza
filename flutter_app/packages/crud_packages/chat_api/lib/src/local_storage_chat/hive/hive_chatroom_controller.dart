import 'package:chat_api/src/models/chat_room.dart';
import 'package:hive/hive.dart';

class HiveChatRoomController {
  static Box<ChatRoom>? _chatBox;
  static bool _isInitialized = false;

  /// Ensures Hive Box is Opened
  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (!Hive.isBoxOpen('chats')) {
      _chatBox = await Hive.openBox<ChatRoom>('chats');
    } else {
      _chatBox = Hive.box<ChatRoom>('chats');
    }

    _isInitialized = true;
  }

  /// Create or Update a Chat Room
  static Future<void> addOrUpdateChatRoom(ChatRoom room) async {
    await _ensureInitialized();
    await _chatBox!.put(room.id, room);
  }

  /// Read a Single Chat Room
  static Future<ChatRoom?> getChatRoom(String id) async {
    await _ensureInitialized();
    return _chatBox!.get(id);
  }

  /// Read All Chat Rooms
  static Future<List<ChatRoom>> getAllChatRooms() async {
    await _ensureInitialized();
    return _chatBox!.values.toList();
  }

  /// Update Chat Room Name
  static Future<void> updateChatRoomName(String id, String newName) async {
    await _ensureInitialized();
    ChatRoom? room = _chatBox!.get(id);
    if (room != null) {
      room.name = newName;
      await room.save();
    }
  }

  /// Add a Member to a Chat Room
  static Future<void> addMember(String chatRoomId, String userId) async {
    await _ensureInitialized();
    ChatRoom? room = _chatBox!.get(chatRoomId);
    if (room != null) {
      room.joinRoom(userId);
      await room.save();
    }
  }

  /// Remove a Member from a Chat Room
  static Future<void> removeMember(String chatRoomId, String userId) async {
    await _ensureInitialized();
    ChatRoom? room = _chatBox!.get(chatRoomId);
    if (room != null) {
      room.leaveGroup(userId);
      await room.save();
    }
  }

  /// Delete a Chat Room
  static Future<void> deleteChatRoom(String id) async {
    await _ensureInitialized();
    await _chatBox!.delete(id);
  }

  /// Delete All Chat Rooms
  static Future<void> clearAllChatRooms() async {
    await _ensureInitialized();
    await _chatBox!.clear();
  }

  /// Ensures Hive is initialized before performing any operation
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
