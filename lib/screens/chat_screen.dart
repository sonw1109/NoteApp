import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'User');
  final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'ChatGPT');

  final List<ChatMessage> _messages = <ChatMessage>[];

  Future<void> getChatRespone(ChatMessage messages) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ChatGPT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff212121),
      ),
      body: DashChat(
          currentUser: _currentUser,
          onSend: (ChatMessage messages) {
            getChatRespone(messages);
          },
          messages: _messages),
    );
  }
}
