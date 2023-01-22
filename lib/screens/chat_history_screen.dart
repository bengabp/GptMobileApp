import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatefulWidget {
  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat History"),
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: Center(child: Text("Chat history screen")),
    );
  }
}
