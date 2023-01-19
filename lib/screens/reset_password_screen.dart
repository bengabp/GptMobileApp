// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  String verification_code = "";

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
            margin: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextButton.icon(
                      onPressed: () => {Navigator.pop(context)},
                      icon: Icon(Icons.arrow_back_ios_new, size: 15),
                      label: Text(
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryWidgetColor),
                      )),
                ),
                Center(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                email_verified == false
                    ? Column(
                        children: [
                          email_sent == false
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10),
                                  child: CupertinoTextField(
                                    placeholder: "Enter your email address",
                                    padding: EdgeInsets.all(10),
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (value) => {email = value},
                                    suffix: TextButton.icon(
                                      label: Text("Send code"),
                                      icon: Icon(
                                          CupertinoIcons.arrow_right_square,
                                          size: 20),
                                      onPressed: () => {
                                        setState(() => {
                                              email_sent = true,
                                            })
                                      },
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10),
                                  child: CupertinoTextField(
                                    placeholder: "Enter verification code",
                                    maxLength: 6,
                                    keyboardType: TextInputType.numberWithOptions(),
                                    padding: EdgeInsets.all(15),
                                    style: TextStyle(fontSize: 16),
                                    onChanged: (value) =>
                                        {
                                          setState(()=>{
                                            user_verification_code = value
                                          })
                                        },
                                    suffix: user_verification_code.length < 6
                                        ? null
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                  ),
                                ),
                        ],
                      )
                    : // If Email has been verified prompt to set new password !
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: CupertinoTextField(
                          placeholder: "Enter a new password",
                          padding: EdgeInsets.all(10),
                          obscureText: is_password_masked,
                          style: TextStyle(fontSize: 18),
                          suffix: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              is_password_masked
                                  ? CupertinoIcons.eye_slash_fill
                                  : CupertinoIcons.eye_fill,
                            ),
                            onPressed: () => {
                              setState(() =>
                                  {is_password_masked = !is_password_masked})
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          onChanged: (value) => {password = value},
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
