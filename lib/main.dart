import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './signin.dart';
import './loginStatus.dart';

import 'dart:async';



void main()=>runApp(MyApp());       //Timer(Duration(seconds: 1),run);void run() =>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user['isLoggedIn'] = (prefs.getInt('isLoggedIn') ?? 0);
      if (user['isLoggedIn'] == 1) {
        user['token'] = prefs.getString('token');
        user['uname'] = prefs.getString('uname');
        user['name'] = prefs.getString('name');
        user['email'] = prefs.getString('email');
        user['no'] = prefs.getString('no');
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StayHome Admin',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SignIn(),
    );
  }
}
