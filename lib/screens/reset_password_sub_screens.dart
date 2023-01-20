// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:ai4study/screens/chat_screen.dart';
import 'package:ai4study/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SetNewPassword extends StatefulWidget {
  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);
  bool setting_new_password = false;
  bool is_password_masked = true;
  String new_password = "";

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
                    "Set new password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
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
                            setState(() =>
                                {is_password_masked = !is_password_masked})
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        onChanged: (value) => {new_password = value},
                      ),
                    ),
                    CupertinoButton(
                      onPressed: setting_new_password
                          ? null
                          : () => {
                                setState(() => {
                                      setting_new_password = true,
                                      Timer(
                                          Duration(seconds: 3),
                                          () => {
                                                setState(() => {
                                                      setting_new_password =
                                                          false,
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ChatScreen()),
                                                          (r) {
                                                        return false;
                                                      })
                                                    })
                                              })
                                    })
                              },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("Confirm"),
                          ),
                          setting_new_password
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnterVerificationCode extends StatefulWidget {
  @override
  State<EnterVerificationCode> createState() => _EnterVerificationCodeState();
}

class _EnterVerificationCodeState extends State<EnterVerificationCode> {
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);

  String user_verification_code = "";

  String verification_code = "123456";

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
                // Container(
                //   alignment: Alignment.topLeft,
                //   padding: const EdgeInsets.only(bottom: 15.0),
                //   child: TextButton.icon(
                //       onPressed: () => {Navigator.pop(context)},
                //       icon: Icon(Icons.arrow_back_ios_new, size: 15),
                //       label: Text(
                //         "Back",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: primaryWidgetColor),
                //       )),
                // ),
                Center(
                  child: Text(
                    "Enter Verification Code",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 10),
                      child: CupertinoTextField(
                        placeholder: "000000",
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        padding: EdgeInsets.all(15),
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) => {
                          setState(() => {
                                user_verification_code = value,
                                if (user_verification_code == verification_code)
                                  {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                SetNewPassword())))
                                  },
                              })
                        },
                        suffix: user_verification_code.length < 6
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnterEmailScreen extends StatefulWidget {
  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  Color primaryWidgetColor = Color.fromARGB(201, 255, 119, 0);
  String email = "";

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
                // Container(
                //   alignment: Alignment.topLeft,
                //   padding: const EdgeInsets.only(bottom: 15.0),
                //   child: TextButton.icon(
                //       onPressed: () => {Navigator.pop(context)},
                //       icon: Icon(Icons.arrow_back_ios_new, size: 15),
                //       label: Text(
                //         "Back",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: primaryWidgetColor),
                //       )),
                // ),
                Center(
                  child: Text(
                    "Email Verification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 10),
                      child: CupertinoTextField(
                        placeholder: "Enter your email address",
                        padding: EdgeInsets.all(10),
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) => {email = value},
                        suffix: TextButton(
                          child: Text("Send code"),
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        EnterVerificationCode())))
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


