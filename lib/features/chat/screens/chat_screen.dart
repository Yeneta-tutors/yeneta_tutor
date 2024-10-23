import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/chat/controller/chat_controller.dart';
import 'package:yeneta_tutor/models/message_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String tutorId;

  ChatScreen({required this.tutorId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String? chatId;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initChat();
  }

  Future<void> initChat() async {
    chatId = await ref.read(chatControllerProvider).createChat(
          widget.tutorId,
        );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Tutor'),
      ),
      body: chatId == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Messages List
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    stream:
                        ref.read(chatControllerProvider).getMessages(chatId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final messages = snapshot.data ?? [];
                      if (messages.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId ==
                              ref
                                  .read(chatControllerProvider)
                                  .authRepository
                                  .getCurrentUserId();

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(message.message),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Message Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          final messageText = messageController.text.trim();
                          if (messageText.isNotEmpty && chatId != null) {
                            await ref
                                .read(chatControllerProvider)
                                .sendMessage(chatId!, messageText);
                            messageController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
