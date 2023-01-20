// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:async';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './reset_password_sub_screens.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);
  // Color primaryTextColor = Colors.white;
  bool is_password_masked = true;
  bool verify_email_spinner = false;
  bool reset_password_spinner = false;
  String email = "";
  String password = "";
  bool email_verified = false;
  bool email_sent = false;
  String user_verification_code = "";
  String verification_code = "123456";

  TextEditingController email_editing_controller = TextEditingController();
  TextEditingController verification_code_editing_controller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return EnterEmailScreen();
  }
}
