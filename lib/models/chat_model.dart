
class Chat {
  final String chatId;
  final String studentId;
  final String tutorId;
  final DateTime lastMessageTime;

  Chat({
    required this.chatId,
    required this.studentId,
    required this.tutorId,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'studentId': studentId,
      'tutorId': tutorId,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatId: map['chatId'],
      studentId: map['studentId'],
      tutorId: map['tutorId'],
      lastMessageTime: DateTime.parse(map['lastMessageTime']),
    );
  }
}
