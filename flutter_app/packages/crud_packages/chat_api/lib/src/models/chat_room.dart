class ChatRoom {
  final String id, name;
  final List<String> memberIds;

  ChatRoom({required this.id, required this.name, required this.memberIds});

  bool isMember(String uid) {
    return memberIds.contains(uid);
  }

  void joinRoom(String uid) {
    memberIds.add(uid);
  }

  void leaveGrouop(String uid) {
    memberIds.remove(uid);
  }
}
