import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
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
    if (tutorId.isEmpty) {
      throw Exception('Tutor ID cannot be empty');
    }

    final chatsRef = firestore.collection('chats');

    final existingChat = await chatsRef
        .where('studentId', isEqualTo: studentId)
        .where('tutorId', isEqualTo: tutorId)
        .get();

    if (existingChat.docs.isNotEmpty) {
      return existingChat.docs.first.id; // Return the existing chat ID
    }

    final chatDoc = chatsRef.doc(); // Generate a new document ID
    await chatDoc.set({
      'chatId': chatDoc.id, // Save chatId explicitly
      'studentId': studentId,
      'tutorId': tutorId,
      'lastMessageTime': DateTime.now().toIso8601String(),
    });

    return chatDoc.id; 
  }

  // Send a new message in a chat
  Future<void> sendMessage(String chatId, String senderId, String message) async {
    final messagesRef = firestore.collection('messages');

    await messagesRef.add({
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await firestore.collection('chats').doc(chatId).update({
      'lastMessageTime': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Message>> getMessages(String chatId) {
    final messagesRef = firestore.collection('messages');

    return messagesRef
        .where('chatId', isEqualTo: chatId)

        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

Stream<List<Chat>> getAllChats(String userId) {
  final studentChats = firestore
      .collection('chats')
      .where('studentId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList());

  final tutorChats = firestore
      .collection('chats')
      .where('tutorId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList());

  return Rx.combineLatest2(studentChats, tutorChats, (a, b) => [...a, ...b]);
}

}
