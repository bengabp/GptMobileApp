import 'package:ai4study/screens/prechat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool is_first_setup = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ai4Study")),
      body: Column(
        children: [Text("Chat Screen")],
      ),
    );
  }
}
