import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';
import 'package:yeneta_tutor/features/chat/repository/chat_repository.dart';
import 'package:yeneta_tutor/models/chat_model.dart';
import 'package:yeneta_tutor/models/message_model.dart';

// Chat controller provider
final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepository chatRepository;
  final AuthRepository authRepository;
  final Ref ref;

  ChatController({
    required this.chatRepository,
    required this.authRepository,
    required this.ref,
  });

  // Create a new chat between student and tutor
  Future<String> createChat(String tutorId) async {
    // Fetch the current logged-in user's ID (studentId)
    final String? studentId = authRepository.getCurrentUserId();

    if (studentId == null) {
      throw Exception('Student not signed in');
    }

    return await chatRepository.createChat(studentId, tutorId);
  }

  // Send a message in a chat
  Future<void> sendMessage(String chatId, String message) async {
    // Fetch the current logged-in user's ID (senderId)
    final String? senderId = authRepository.getCurrentUserId();

    if (senderId == null) {
      throw Exception('User not signed in');
    }

    await chatRepository.sendMessage(chatId, senderId, message);
  }

  // Fetch all chats for the current logged-in user
  Stream<List<Chat>> getUserChats() {
    final String? userId = authRepository.getCurrentUserId();

    if (userId == null) {
      throw Exception('User not signed in');
    }

    return chatRepository.getUserChats(userId);
  }

  // Fetch all messages for a specific chat
  Stream<List<Message>> getMessages(String chatId) {
    return chatRepository.getMessages(chatId);
  }
}
