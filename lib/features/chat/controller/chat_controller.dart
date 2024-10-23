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

  Future<String> createChat(String tutorId) async {
    final String studentId = authRepository.getCurrentUserId();
    
    return await chatRepository.createChat(studentId, tutorId);
  }

  Future<void> sendMessage(String chatId, String message) async {
    final String senderId = authRepository.getCurrentUserId();

    if (senderId == null) {
      throw Exception('User not signed in');
    }

    await chatRepository.sendMessage(chatId, senderId, message);
  }

  Stream<List<Chat>> getUserChats() {
    final String userId = authRepository.getCurrentUserId();

    return chatRepository.getUserChats(userId);
  }

  Stream<List<Message>> getMessages(String chatId) {
    return chatRepository.getMessages(chatId);
  }
}
