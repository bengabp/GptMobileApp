// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:ai4study/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);
  // Color primaryTextColor = Colors.white;
  bool is_password_masked = true;
  bool show_spinner = false;
  String email = "";
  String password = "";

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
            margin: EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Account Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: CupertinoTextField(
                    placeholder: "Email",
                    padding: EdgeInsets.all(10),
                    style: TextStyle(fontSize: 18),
                    onChanged: (value) => {email = value},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: CupertinoTextField(
                    placeholder: "Password",
                    padding: EdgeInsets.all(10),
                    obscureText: is_password_masked,
                    style: TextStyle(fontSize: 20),
                    suffix: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        is_password_masked
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                      ),
                      onPressed: () => {
                        setState(
                            () => {is_password_masked = !is_password_masked})
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    onChanged: (value) => {password = value},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: TextButton.icon(
                      onPressed: () => {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen(),fullscreenDialog: true))
                      },
                      icon: Icon(Icons.lock_reset_rounded),
                      label: Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryWidgetColor),
                      )),
                ),
                CupertinoButton(
                  onPressed: show_spinner
                      ? null
                      : () => {
                            setState(() => {
                                  show_spinner = true,
                                  print("Email=${email}|Password=${password}"),
                                  Timer(
                                      Duration(seconds: 3),
                                      () => {
                                            setState(() => {
                                                  show_spinner = false,
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen()))
                                                })
                                          })
                                })
                          },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text("Login"),
                      ),
                      show_spinner
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            )
                          : Text("")
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  // padding: EdgeInsets.only(left: 50, right: 50),
                  // minSize: 40,
                  color: primaryWidgetColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

