// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  String text = "";
  bool is_my_message;
  String messageType = "text";
  var audioFile;

  ChatMessage(this.text, this.is_my_message, this.messageType);
}

class UserMessage extends StatefulWidget {
  String text_message = "";
  DateTime date = DateTime.now();

  UserMessage(@required this.text_message, this.date);

  @override
  State<UserMessage> createState() => _UserMessageState(text_message, date);
}

class _UserMessageState extends State<UserMessage> {
  String text_message = "";
  DateTime date = DateTime.now();

  _UserMessageState(@required this.text_message, this.date);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          constraints: BoxConstraints(maxWidth: 200),
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            text_message,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Color.fromARGB(241, 242, 237, 230),
          )),
    );
  }
}

class BotMessage extends StatefulWidget {
  String text_message = "";
  DateTime date = DateTime.now();

  BotMessage(@required this.text_message, this.date);

  @override
  State<BotMessage> createState() => _BotMessageState(text_message, date);
}

class _BotMessageState extends State<BotMessage> with TickerProviderStateMixin {
  String text_message = "";
  DateTime date = DateTime.now();
  bool _show_date = false;

  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this);

  late final Animation<double> _animation =
      CurvedAnimation(curve: Curves.easeIn, parent: _controller);

  _BotMessageState(@required this.text_message, this.date);

  @override
  Widget build(BuildContext context) {
    String readableDate = DateFormat("H:m - MMM d, y").format(date);
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/chatbot.png"),
              backgroundColor: Colors.transparent,
              radius: 18,
            ),
            decoration: BoxDecoration(),
            margin:EdgeInsets.only(top:10)
          ),
          GestureDetector(
            onTap: () => {
              setState(() {
                print("Show date:$_show_date");
                _show_date = true;
              }),
            },
            child: AnimatedSize(
              duration: Duration(milliseconds: 100),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 180),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        text_message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_show_date)
                        AnimatedTextKit(
                          animatedTexts: [
                            FadeAnimatedText(
                              readableDate,
                              textAlign: TextAlign.right,
                              textStyle: TextStyle(
                                  color: Color.fromARGB(182, 44, 43, 43),
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12),
                            )
                          ],
                          isRepeatingAnimation: false,
                          onFinished: (() {
                            setState(() {
                              _show_date = false;
                            });
                          }),
                        ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color.fromARGB(40, 255, 153, 0),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
