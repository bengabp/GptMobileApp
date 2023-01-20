import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PreChatScreen extends StatefulWidget {
  @override
  State<PreChatScreen> createState() => _PreChatScreenState();
}

class _PreChatScreenState extends State<PreChatScreen> {
  String actAs = "ChatGPT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:EdgeInsets.only(top:80),
          child: Wrap(
        children: [
          SizedBox(child: Image.asset("assets/chatbot.png"),width:100,height:100)
        ],
      )),
    );
  }
}
