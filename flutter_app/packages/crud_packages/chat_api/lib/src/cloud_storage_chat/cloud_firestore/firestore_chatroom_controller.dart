import 'package:chat_api/src/models/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreChatroomController {
  final CollectionReference chatRoomsCollection =
      FirebaseFirestore.instance.collection('chat_rooms');

  /// Create or Update a Chat Room
  Future<void> addOrUpdateChatRoom(ChatRoom room) async {
    await chatRoomsCollection.doc(room.id).set(room.toJson());
  }

  /// Read a Single Chat Room
  Future<ChatRoom?> getChatRoom(
    String id,
  ) async {
    DocumentSnapshot doc = await chatRoomsCollection.doc(id).get();
    if (doc.exists) {
      return ChatRoom.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<ChatRoom>> getAllChatRooms({required String userId}) async {
    QuerySnapshot snapshot = await chatRoomsCollection.get();

    return snapshot.docs
        .map((doc) => ChatRoom.fromJson(doc.data() as Map<String, dynamic>))
        .where((chatRoom) => chatRoom.isMember(userId))
        .toList();
  }

  /// Update Chat Room Name
  Future<void> updateChatRoomName(String id, String newName) async {
    await chatRoomsCollection.doc(id).update({'name': newName});
  }

  /// Add a Member to a Chat Room
  Future<void> addMember(String chatRoomId, String userId) async {
    DocumentReference chatRoomRef = chatRoomsCollection.doc(chatRoomId);
    await chatRoomRef.update({
      'memberIds': FieldValue.arrayUnion([userId])
    });
  }

  /// Remove a Member from a Chat Room
  Future<void> removeMember(String chatRoomId, String userId) async {
    DocumentReference chatRoomRef = chatRoomsCollection.doc(chatRoomId);
    await chatRoomRef.update({
      'memberIds': FieldValue.arrayRemove([userId])
    });
  }

  /// Delete a Chat Room
  Future<void> deleteChatRoom(String id) async {
    await chatRoomsCollection.doc(id).delete();
  }

  /// Listen to Chat Room Changes (Real-time Updates)
  Stream<List<ChatRoom>> listenToChatRooms() {
    return chatRoomsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatRoom.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
