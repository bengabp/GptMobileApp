// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:ai4study/screens/chat_widget.dart';
import 'package:ai4study/screens/prechat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './chat_widget.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool is_first_setup = true;
  bool is_recording = false;
  List<ChatMessage> chat_messages = [
    ChatMessage("Hi", true),
    ChatMessage("How have you been?", false),
    ChatMessage("Hey Kriss, I am doing fine dude. wbu?", false)
  ];
  String chat_text_message = "";
  ScrollController _scrollController = ScrollController();
  TextEditingController _messageController = TextEditingController();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    print("Status:$status");
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print("Recorded audio: $audioFile");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ai4Study"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => {}, icon: Icon(Icons.menu)),
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 100),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(chat_messages.length, (index) {
                      String messageText = chat_messages[index].text;
                      bool isMine = chat_messages[index].is_my_message;

                      return isMine
                          ? UserMessage(messageText, DateTime.now())
                          : BotMessage(messageText, DateTime.now());
                    })),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Camera button clicked !");
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      placeholder: "Write message...",
                      controller: _messageController,
                      padding: EdgeInsets.all(10),
                      onChanged: (value) => {chat_text_message = value.trim()},
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                      heroTag: "RecordAudioButton",
                      onPressed: () {
                        setState(() {
                          is_recording = !is_recording;
                          if (is_recording) {
                            record();
                          } else {
                            stop();
                          }
                        });
                      },
                      child: Icon(is_recording ? Icons.mic : Icons.mic_off,
                          color: Colors.white, size: 18),
                      elevation: 0),
                  FloatingActionButton(
                    heroTag: "SendButton",
                    onPressed: () {
                      if (chat_text_message.length > 0) {
                        // Send message to bot
                        ChatMessage new_chat_message =
                            ChatMessage(chat_text_message, true);
                        setState(() {
                          chat_messages.add(new_chat_message);
                          _messageController.clear();
                        });
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent + 100,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeOut);
                      }
                      print(_scrollController.offset);
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
