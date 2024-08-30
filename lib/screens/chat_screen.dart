// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:note_app/const.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _openAi = OpenAI.instance.build(
//     token: OPENAI_API_KEY,
//     baseOption: HttpSetup(
//       receiveTimeout: const Duration(seconds: 5),
//     ),
//     enableLog: true,
//   );

//   final ChatUser _currentUser = ChatUser(id: '1', firstName: 'User');
//   final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'ChatGPT');

//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final List<ChatUser> _typingUsers = <ChatUser>[];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "ChatGPT",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xff212121),
//       ),
//       body: DashChat(
//           messageOptions: const MessageOptions(
//             currentUserContainerColor: Colors.black,
//           ),
//           currentUser: _currentUser,
//           // typingUsers: _typingUsers,
//           onSend: (ChatMessage m) {
//             getChatRespone(m);
//           },
//           messages: _messages),
//     );
//   }

//   Future<void> getChatRespone(ChatMessage m) async {
//     setState(() {
//       _messages.insert(0, m);
//       _typingUsers.add(_gptChatUser);
//     });
//     List<Map<String, dynamic>> _messageHistory = _messages.map((m) {
//       if (m.user == _currentUser) {
//         return {
//           'role': 'user',
//           'content': m.text,
//         };
//       } else {
//         return {
//           'role': 'assistant',
//           'content': m.text,
//         };
//       }
//     }).toList();
//     final request =
//         ChatCompleteText(model: GptTurboChatModel(), messages: _messageHistory, maxToken: 200);
//     final respone = await _openAi.onChatCompletion(request: request);
//     for (var element in respone!.choices) {
//       if (element.message != null) {
//         setState(
//           () {
//             _messages.insert(
//               0,
//               ChatMessage(
//                   user: _gptChatUser, createdAt: DateTime.now(), text: element.message!.content),
//             );
//           },
//         );
//       }
//     }
//     setState(() {
//       _typingUsers.remove(_gptChatUser);
//     });
//   }
// }
