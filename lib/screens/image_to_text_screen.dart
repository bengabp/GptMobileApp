// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ImageToTextScreen extends StatefulWidget {
  String imagePath = "";

  ImageToTextScreen(this.imagePath);

  @override
  State<ImageToTextScreen> createState() => _ImageToTextScreenState(imagePath);
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  String imagePath;

  _ImageToTextScreenState(this.imagePath);

  Color _conversationEntryIconColor = Colors.orange;
  Color _conversationEntryFbBgColor = Colors.white;
  bool _is_sending = false;

  _extractTextFromImage(BuildContext context) async {
    setState(() {
      _is_sending = true;
    });
    var postUri = Uri.parse("$BASEURL/ocr");
    var request = http.MultipartRequest("POST", postUri);
    String speechText = "";
    request.headers["Content-Type"] = "multipart/form-data";
    // request.fields['request_type'] = "OCR";
    request.files
        .add(await http.MultipartFile.fromPath("imageFile", imagePath));

    await request.send().then((response) async {
      String server_response = await response.stream.bytesToString();
      var jsonData = jsonDecode(server_response) as Map;
      String imageText = jsonData["image_text"];

      LineSplitter lineSplitter = LineSplitter();
      List<String> _lines = lineSplitter.convert(imageText);
      List<String> _linesCopy = [];
      _lines.forEach((line) {
        if (line.isNotEmpty) {
          _linesCopy.add(line.trim());
        }
      });

      _lines = _linesCopy;

      setState(() {
        _is_sending = false;
      });

      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 3),
                          child: Text("Extracted Text",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        ..._lines.map((line) => TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      _conversationEntryFbBgColor)),
                              child: Text(line, textAlign: TextAlign.center),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: line))
                                    .then((_) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(text: line)),
                                      (route) => false);
                                });
                              },
                            ))
                      ],
                    ))),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.file(File(imagePath), fit: BoxFit.cover),
            constraints: BoxConstraints.expand(),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (_is_sending)
              Padding(
                padding: const EdgeInsets.all(1),
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  strokeWidth: 8,
                ),
              ),
            FloatingActionButton(
              tooltip: "Extract Text",
              onPressed: _is_sending
                  ? null
                  : () async {
                      print("Extracting text from image");
                      await _extractTextFromImage(context);
                    },
              child: Icon(Icons.find_replace_outlined,
                  color: _conversationEntryIconColor),
              backgroundColor: _conversationEntryFbBgColor,
              elevation: 20,
            ),
          ],
        ),
      ),
    );
  }
}
