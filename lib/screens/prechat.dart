// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'chat_screen.dart';

class PreChatScreen extends StatefulWidget {
  @override
  State<PreChatScreen> createState() => _PreChatScreenState();
}

class _PreChatScreenState extends State<PreChatScreen> {
  String actAs = "ChatGPT";
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15, right: 15, top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      child: Image.asset("assets/chatbot.png"),
                      width: 150,
                      height: 150),
                  Text("Hi there !",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 40.0),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "I am your AIassistant to answer all your questions. You can write, speak or upload a Picture.Tell me how i should act, ",
                            speed: Duration(milliseconds: 80),
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(fontSize: 16),
                            cursor: "❚",
                          )
                        ],
                        totalRepeatCount: 1,
                        repeatForever: false,
                        isRepeatingAnimation: false,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CupertinoTextField(
                      placeholder:
                          "The default is Act as ChatGPT - Try it out!",
                      padding: EdgeInsets.all(10),
                      style: TextStyle(fontSize: 15),
                      onChanged: (value) => {actAs = value},
                    ),
                  ),
                  CupertinoButton(
                      child: Text("Let's Go !"),
                      onPressed: () => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()),
                                (route) => false)
                          },
                      color: primaryWidgetColor)
                ],
              )),
        ),
      ),
    );
  }
}
