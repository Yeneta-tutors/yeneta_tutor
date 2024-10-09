class Message {
  String messageId;
  String chatId;
  String senderId; // Foreign key from users
  String message;
  DateTime createdAt;

  Message({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  // Convert a Message instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'chat_id': chatId,
      'sender_id': senderId,
      'message': message,
      'created_at': createdAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['message_id'],
      chatId: map['chat_id'],
      senderId: map['sender_id'],
      message: map['message'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
