// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/prechat.dart';


void main() {
  runApp(Ai4Study());
}

class Ai4Study extends StatefulWidget {
  const Ai4Study({Key? key}) : super(key: key);

  @override
  State<Ai4Study> createState() => _Ai4StudyState();
}

class _Ai4StudyState extends State<Ai4Study> {
  bool isLoggedIn = false;

  _Ai4StudyState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn == true ? PreChatScreen() : LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        textTheme:GoogleFonts.signikaTextTheme()
      ),
    );
  }
}
