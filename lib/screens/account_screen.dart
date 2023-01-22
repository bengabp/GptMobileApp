import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: Center(child:Text("Accounts Screen")),
    );
  }
}