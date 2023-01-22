// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:ai4study/screens/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool is_first_setup = true;
  bool is_recording = false;
  List<ChatMessage> chat_messages = [];
  String chat_text_message = "";
  ScrollController _scrollController = ScrollController();
  TextEditingController _messageController = TextEditingController();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  var fakePath;
  final String audioUploadUrl = "http://139.162.220.59:8000/transcribe";
  bool is_transcribing = false;

  SnackBar _createSnackBar(String text) {
    return SnackBar(
        content: Text(text),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 80, left: 20, right: 20));
  }

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
    return audioFile;
  }

  Future _makeNetworkRequest() async {
    print("making network request");
    final response =
        await http.get(Uri.parse('http://139.162.220.59:8000/testapi'));
    var decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  Future _getBotResponse(String userMessage) async {
    final response = await http.get(
        Uri.parse("http://139.162.220.59:8000/chat/text?text=$userMessage"));
    var decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    String textResponse = decodedJson["botReply"];
    return textResponse;
  }

  _scrollToBottom() {
    try {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 50,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut);
    } on AssertionError {}
  }

  _transcribeAudio(File audioFile) async {
    setState(() {
      is_transcribing = true;
    });
    var postUri = Uri.parse(audioUploadUrl);
    var request = new http.MultipartRequest("POST", postUri);
    String speechText = "";
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields['something'] = "this is some thing";
    request.files
        .add(await http.MultipartFile.fromPath("audioFile", audioFile.path));
    request.send().then((response) async {
      String server_response = await response.stream.bytesToString();
      var jsonData = jsonDecode(server_response) as Map;
      speechText = jsonData["speech_text"];
      setState(() {
        print(speechText);
        is_transcribing = false;
        _messageController.text = speechText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Reloaded");
    return Scaffold(
      appBar: AppBar(
        title: Text("Ai4Study"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => {}, icon: Icon(Icons.menu)),
        toolbarHeight: 70,
        actions: [
          Container(
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/chatbot.png"),
                backgroundColor: Colors.transparent,
                radius: 23,
              ),
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(top: 10)),
        ],
      ),
      body: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: chat_messages.length <= 0
                ? Center(
                    child: Text(
                      "No messages yet",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )
                : SingleChildScrollView(
                    physics: ScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 100),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                              List.generate(chat_messages.length, (index) {
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
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 50,
                    width: 40,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        if (is_transcribing) Padding(
                          padding: const EdgeInsets.all(1),
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(213, 223, 113, 10),
                            strokeWidth: 2,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "RecordAudioButton",
                          onPressed:is_transcribing ? null : () async {
                            setState(() {
                              is_recording = !is_recording;
                            });
                            if (is_recording) {
                              record();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _createSnackBar("Recording..."));
                            } else {
                              File audioFile = await stop();
                              await _transcribeAudio(audioFile);
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     _createSnackBar(
                              //         "Stopped Recording...PATH:$fakePath"));
                            }
                          },
                          child: Icon(is_recording ? Icons.mic : Icons.mic_off,
                              color: Color.fromARGB(255, 214, 103, 12),
                              size: 18),
                          elevation: 0,
                          backgroundColor: Color.fromARGB(57, 255, 128, 0),
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "SendButton",
                    onPressed: () async {
                      if (_messageController.text.length > 0) {
                        ChatMessage new_chat_message =
                            ChatMessage(_messageController.text, true, "text");
                        setState(() {
                          chat_messages.add(new_chat_message);
                          _messageController.clear();
                        });
                        _scrollToBottom();

                        // Get Bot Response
                        String botReply =
                            await _getBotResponse(_messageController.text);
                        ChatMessage new_bot_message =
                            ChatMessage(botReply, false, "text");
                        setState(() {
                          chat_messages.add(new_bot_message);
                          // currentChatMessage = CurrentChatMessage();
                        });
                        _scrollToBottom();
                      }
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
