import 'package:flutter/material.dart';
import 'package:jsps_depo/base_state.dart';
import 'package:jsps_depo/pages/gemini/api_services/api_keys.dart';
import 'package:jsps_depo/pages/gemini/components/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.title, super.key});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      body: const ChatWidget(
        apiKey: apiKey,
      ), // Change this to the appropriate API key
    );
  }
}
