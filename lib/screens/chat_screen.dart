// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:ai4study/custom_widgets/select_ocr_image_widget.dart';
import 'package:ai4study/screens/chat_widget.dart';
import 'package:ai4study/screens/navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import './image_to_text_screen.dart';

String BASEURL = "http://192.168.132.25:5000";

class ChatScreen extends StatefulWidget {
  String text = "";

  ChatScreen({this.text: ""});

  @override
  State<ChatScreen> createState() => _ChatScreenState(text);
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool is_first_setup = true;
  bool is_recording = false;
  List<ChatMessage> chat_messages = [];
  String chat_text_message = "";
  ScrollController _scrollController = ScrollController();
  String text;
  TextEditingController _messageController =
      TextEditingController();

  CupertinoTextField conversationTextField = CupertinoTextField();

  _ChatScreenState(this.text) {
    print("TEXT:$text");
    conversationTextField = CupertinoTextField(
      placeholder: "Write message...",
      controller: _messageController,
      padding: EdgeInsets.all(10),
      onChanged: (value) {
        setState(() {});
      },
    );
    if (text.isNotEmpty) {
      _messageController.text = text;
    }
  }

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  var fakePath;
  final String audioUploadUrl = "$BASEURL/transcribe";
  bool is_sending = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Color _conversationEntryIconColor = Color.fromARGB(255, 214, 103, 12);
  Color _conversationEntryFbBgColor = Color.fromARGB(57, 255, 128, 0);

  final ImagePicker _picker = ImagePicker();
  bool previewImage = false;

  SnackBar _createSnackBar(String text) {
    return SnackBar(
      content: Text(
        text,
        style: TextStyle(color: _conversationEntryIconColor),
      ),
      duration: Duration(milliseconds: 1000),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 70, left: 20, right: 20),
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      backgroundColor: _conversationEntryFbBgColor,
    );
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
    final response = await http.get(Uri.parse('$BASEURL/testapi'));
    var decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  Future _getBotResponse(String userMessage) async {
    final response =
        await http.get(Uri.parse("$BASEURL/chat/text?text=$userMessage"));
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
      is_sending = true;
    });
    var postUri = Uri.parse(audioUploadUrl);
    var request = new http.MultipartRequest("POST", postUri);
    String speechText = "";
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields['something'] = "this is some thing";
    request.files
        .add(await http.MultipartFile.fromPath("audioFile", audioFile.path));

    var response = await request.send().then((response) async {
      String server_response = await response.stream.bytesToString();
      var jsonData = jsonDecode(server_response) as Map;
      speechText = jsonData["speech_text"];
      setState(() {
        print(speechText);
        is_sending = false;
        _messageController.text = speechText;
      });
    });
  }

  void _selectImage(BuildContext context, ImageSource source) async {
    XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageToTextScreen(pickedImage.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Reloaded");
    // is_sending = false;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            Container(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/chatbot.png"),
                  backgroundColor: Colors.transparent,
                ),
                decoration: BoxDecoration(),
                margin: EdgeInsets.only(top: 10)),
            Text("Ai4Study")
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () => {_key.currentState!.openDrawer()},
            icon: Icon(Icons.menu)),
        toolbarHeight: 70,
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
                      "I am help you do many things,just ask, I am not perfect however",
                      textAlign: TextAlign.center,
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
              padding: EdgeInsets.all(5),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child: conversationTextField),
                  SizedBox(
                    width: 5,
                  ),
                  SelectImageSourceButton(previewImage, _selectImage),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        if (is_sending)
                          Padding(
                            padding: const EdgeInsets.all(1),
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(213, 223, 113, 10),
                              strokeWidth: 2,
                            ),
                          ),
                        _messageController.text.isEmpty
                            ? FloatingActionButton(
                                heroTag: "RecordAudioButton",
                                onPressed: is_sending
                                    ? null
                                    : () async {
                                        setState(() {
                                          is_recording = !is_recording;
                                        });
                                        if (is_recording) {
                                          record();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(_createSnackBar(
                                                  "Recording..."));
                                        } else {
                                          File audioFile = await stop();
                                          try {
                                            await _transcribeAudio(audioFile);
                                          } on SocketException {
                                            // print("Error:$e");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(_createSnackBar(
                                                    "Could not connect to server!"));
                                            setState(() {
                                              is_sending = false;
                                            });
                                          }
                                        }
                                      },
                                child: Icon(
                                    is_recording ? Icons.mic : Icons.mic_off,
                                    color: _conversationEntryIconColor,
                                    size: 18),
                                elevation: 0,
                                backgroundColor: _conversationEntryFbBgColor,
                              )
                            : FloatingActionButton(
                                heroTag: "SendButton",
                                onPressed: () async {
                                  String _message =
                                      _messageController.text.trim();
                                  if (_message.length > 0) {
                                    ChatMessage new_chat_message =
                                        ChatMessage(_message, true, "text");
                                    setState(() {
                                      chat_messages.add(new_chat_message);
                                      _messageController.clear();
                                    });
                                    _scrollToBottom();

                                    bool failed = false;

                                    // Get Bot Response
                                    try {
                                      String botReply =
                                          await _getBotResponse(_message);
                                      ChatMessage new_bot_message =
                                          ChatMessage(botReply, false, "text");
                                      setState(() {
                                        chat_messages.add(new_bot_message);
                                      });
                                      _scrollToBottom();
                                    } on SocketException {
                                      setState(() {
                                        _messageController.text =
                                            new_chat_message.text;
                                        _messageController.selection =
                                            TextSelection.collapsed(
                                                offset: _messageController
                                                    .text.length);
                                        chat_messages.remove(new_chat_message);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_createSnackBar(
                                              "Could not connect to server!"));
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  color: _conversationEntryIconColor,
                                  size: 18,
                                ),
                                elevation: 0,
                                backgroundColor: _conversationEntryFbBgColor,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      drawer: NavigationDrawer(),
    );
  }
}
