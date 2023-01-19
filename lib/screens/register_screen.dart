// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Ai4Study | Register")),
      body:Column(children: [
        Center(child:Text("Register !"))
      ],)
    );
  }
}