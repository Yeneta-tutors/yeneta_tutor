class Message {
  final String messageId;
  final String chatId;
  final String senderId;
  final String message;
  final DateTime createdAt;

  Message({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
