import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class FirestoreChatController implements ChatController {
  final String chatRoom;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _messagesCollection;

  FirestoreChatController({required this.chatRoom}) {
    _messagesCollection =
        _firestore.collection('chatRooms').doc(chatRoom).collection('messages');
  }

  final _operationsController = StreamController<ChatOperation>.broadcast();

  @override
  Future<void> insert(Message message, {int? index}) async {
    final docRef = _messagesCollection.doc(message.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) return;

    await docRef.set(message.toJson());
    _operationsController
        .add(ChatOperation.insert(message, 0)); // Firestore has no fixed index
  }

  @override
  Future<void> remove(Message message) async {
    final docRef = _messagesCollection.doc(message.id);
    await docRef.delete();
    _operationsController.add(ChatOperation.remove(message, 0));
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    if (oldMessage == newMessage) return;
    final docRef = _messagesCollection.doc(oldMessage.id);
    await docRef.update(newMessage.toJson());
    _operationsController.add(ChatOperation.update(oldMessage, newMessage));
  }

  @override
  Future<void> set(List<Message> messages) async {
    final batch = _firestore.batch();
    for (var message in messages) {
      final docRef = _messagesCollection.doc(message.id);
      batch.set(docRef, message.toJson());
    }
    await batch.commit();
    _operationsController.add(ChatOperation.set());
  }

  List<Message> _cachedMessages = [];

  @override
  List<Message> get messages => _cachedMessages;

  Future<void> fetchMessages() async {
    final snapshot =
        await _messagesCollection.orderBy('createdAt', descending: true).get();
    _cachedMessages = snapshot.docs
        .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Message>> get messagesStream {
    return _messagesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  Future<void> deleteChats() async {
    final batch = _firestore.batch();
    final snapshot = await _messagesCollection.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  void dispose() {
    _operationsController.close();
  }
}
