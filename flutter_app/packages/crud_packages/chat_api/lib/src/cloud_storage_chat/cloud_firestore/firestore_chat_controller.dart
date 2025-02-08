import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class FirestoreChatController implements ChatController {
  final String chatRoom;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _chatCollection;
  final StreamController<ChatOperation> _operationsController =
      StreamController<ChatOperation>.broadcast();

  FirestoreChatController({required this.chatRoom}) {
    _chatCollection =
        _firestore.collection('chats').doc(chatRoom).collection('messages');
  }

  @override
  Future<void> insert(Message message, {int? index}) async {
    final docRef = _chatCollection.doc(message.id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set(message.toJson());
      _operationsController.add(ChatOperation.insert(message, index ?? 0));
    }
  }

  @override
  Future<void> remove(Message message) async {
    final docRef = _chatCollection.doc(message.id);
    await docRef.delete();
    _operationsController.add(ChatOperation.remove(message, 0));
  }

  @override
  Future<void> update(Message oldMessage, Message newMessage) async {
    final docRef = _chatCollection.doc(oldMessage.id);
    await docRef.update(newMessage.toJson());
    _operationsController.add(ChatOperation.update(oldMessage, newMessage));
  }

  @override
  Future<void> set(List<Message> messages) async {
    final batch = _firestore.batch();
    for (var message in messages) {
      batch.set(_chatCollection.doc(message.id), message.toJson());
    }
    await batch.commit();
    _operationsController.add(ChatOperation.set());
  }

  @override
  List<Message> get messages {
    return _chatss;
  }

  List<Message> _chatss = [];

  void getMessages() async {
    final snapshot =
        await _chatCollection.orderBy('createdAt', descending: true).get();

    _chatss = snapshot.docs
        .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<ChatOperation> get operationsStream => _operationsController.stream;

  Stream<List<Message>> get messagesStream => _chatCollection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<void> deleteChats() async {
    final batch = _firestore.batch();
    final snapshot = await _chatCollection.get();
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
