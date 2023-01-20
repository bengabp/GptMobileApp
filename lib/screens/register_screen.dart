// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';

import 'package:ai4study/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chat_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "";
  String password = "";
  bool show_spinner = false;
  bool is_password_masked = true;
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);

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
                    "Create an Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextButton.icon(
                    onPressed: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                  fullscreenDialog: true))
                        },
                    icon: Icon(Icons.lock_reset_rounded),
                    label: Text(
                      "Already have an account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
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
                CupertinoButton(
                    onPressed: show_spinner
                        ? null
                        : () => {
                              setState(() => {
                                    show_spinner = true,
                                    print(
                                        "Email=${email}|Password=${password}"),
                                    Timer(
                                        Duration(seconds: 3),
                                        () => {
                                              setState(() => {
                                                    show_spinner = false,
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChatScreen()),
                                                        (route) => false)
                                                  })
                                            })
                                  })
                            },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("Create Account"),
                        ),
                        show_spinner
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange)),
                              )
                            : Text("")
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    color: primaryWidgetColor
                    // padding: EdgeInsets.only(left: 50, right: 50),
                    // minSize: 40
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
