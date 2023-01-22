// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ai4study/screens/account_screen.dart';
import 'package:ai4study/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'chat_history_screen.dart';
import 'settings_screen.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    Image.asset("assets/user.png"),
                    Wrap(
                      spacing: 5,
                      direction: Axis.vertical,
                      children: [
                        Text("AiBuddy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(
                            child: Text("greg38@gmailsadsadsfadsfadfadf.com"),
                            width: 130)
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_box_outlined),
                title: Text("Account"),
                horizontalTitleGap: -5,
                style: ListTileStyle.list,
                enableFeedback: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => AccountScreen())));
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("Chat History"),
                horizontalTitleGap: -5,
                style: ListTileStyle.list,
                enableFeedback: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatHistoryScreen())));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text("Settings"),
                horizontalTitleGap: -5,
                style: ListTileStyle.list,
                enableFeedback: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => SettingsScreen())));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                horizontalTitleGap: -5,
                style: ListTileStyle.list,
                enableFeedback: true,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.8);
  }
}
