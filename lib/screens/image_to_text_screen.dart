import 'dart:convert';
import 'dart:io';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:flutter/material.dart';
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

  Color _conversationEntryIconColor = Color.fromARGB(255, 218, 198, 181);
  Color _conversationEntryFbBgColor = Color.fromARGB(116, 203, 109, 16);

  _extractTextFromImage(BuildContext context) async {
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container();
    //     });

    var postUri = Uri.parse("$BASEURL/ocr");
    var request = http.MultipartRequest("POST", postUri);
    String speechText = "";
    request.headers["Content-Type"] = "multipart/form-data";
    // request.fields['request_type'] = "OCR";
    request.files
        .add(await http.MultipartFile.fromPath("imageFile", imagePath));

    var response = await request.send().then((response) async {
      String server_response = await response.stream.bytesToString();
      var jsonData = jsonDecode(server_response) as Map;
      String imageText = jsonData["image_text"];
      print(imageText);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imagePath);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.file(File(imagePath), fit: BoxFit.cover),
            constraints: BoxConstraints.expand(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Extract Text",
        onPressed: () async {
          print("Extracting text from image");
          await _extractTextFromImage(context);
        },
        child: Icon(Icons.find_replace_outlined,
            color: _conversationEntryIconColor),
        backgroundColor: _conversationEntryFbBgColor,
        elevation: 10,
      ),
    );
  }
}
