import 'package:hive/hive.dart';

part 'chat_room.g.dart'; // This is for Hive's generated code

@HiveType(typeId: 3)
class ChatRoom extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> memberIds;

  ChatRoom({required this.id, required this.name, required this.memberIds});

  bool isMember(String uid) {
    return memberIds.contains(uid);
  }

  void joinRoom(String uid) {
    if (!memberIds.contains(uid)) {
      memberIds.add(uid);
      save(); // Saves changes in Hive
    }
  }

  void leaveGroup(String uid) {
    if (memberIds.contains(uid)) {
      memberIds.remove(uid);
      save(); // Saves changes in Hive
    }
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      memberIds: List<String>.from(json['memberIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberIds': memberIds,
    };
  }
}
