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
      messageId: map['messageId'] ?? 'unknown', 
      chatId: map['chatId'] ?? 'unknown', 
      senderId: map['senderId'] ?? 'unknown', 
      message: map['message'] ?? 'No message', 
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(), 
    );
  }
}
