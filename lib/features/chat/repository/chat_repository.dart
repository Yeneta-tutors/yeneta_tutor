
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';
import 'package:yeneta_tutor/models/chat_model.dart';
import 'package:yeneta_tutor/models/message_model.dart';


// Chat repository provider
final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final AuthRepository authRepository;

  ChatRepository({
      required this.firestore,
      required this.authRepository,
  });

Future<String> createChat(String studentId, String tutorId) async {
  final chatsRef = firestore.collection('chats');

  // Check if a chat between the student and tutor already exists
  final existingChat = await chatsRef
      .where('studentId', isEqualTo: studentId)
      .where('tutorId', isEqualTo: tutorId)
      .get();

  if (existingChat.docs.isNotEmpty) {

    return existingChat.docs.first.id;
  }

  // If chat doesn't exist, create a new one
  final chatDoc = await chatsRef.add({
    'studentId': studentId,
    'tutorId': tutorId,
    'lastMessageTime': DateTime.now().toIso8601String(),
  });

  return chatDoc.id; // Return the new chat ID
}
Future<void> sendMessage(String chatId, String senderId, String message) async {
  final messagesRef = firestore.collection('messages');

  // Create a new message in the chat
  await messagesRef.add({
    'chatId': chatId,
    'senderId': senderId,
    'message': message,
    'createdAt': DateTime.now().toIso8601String(),
  });

  // Update the lastMessageTime in the chat document
  await firestore.collection('chats').doc(chatId).update({
    'lastMessageTime': DateTime.now().toIso8601String(),
  });
}

Stream<List<Message>> getMessages(String chatId) {
  final messagesRef = firestore.collection('messages');

  // Fetch and listen for new messages in the specific chat
  return messagesRef
      .where('chatId', isEqualTo: chatId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
}

Stream<List<Chat>> getUserChats(String userId) {
  final chatsRef = firestore.collection('chats');

  // Fetch all chats where the user is either the student or the tutor
  return chatsRef
      .where('studentId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList());
}

Stream<List<Chat>> getTutorChats(String tutorId) {
  final chatsRef = firestore.collection('chats');

  // Fetch all chats where the user is a tutor
  return chatsRef
      .where('tutorId', isEqualTo: tutorId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList());
}


}