import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './Functions.dart';
import './Classes.dart';

Future<ResponseData> trySignUp(String nm, String uid, String eid, String no,
    String pwd, String loc) async {
  final response = await http.post(
    url + '/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'vSignUp'
    },
    body: jsonEncode(<String, String>{
      'Name': nm,
      'User': uid,
      'Email': eid,
      'No': no,
      'Password': pwd,
      'Location': loc,
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return ResponseData.fromJson(data);
  } else {
    throw Exception('Failed to SignUp');
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controller_nm = TextEditingController();
  final TextEditingController _controller_uid = TextEditingController();
  final TextEditingController _controller_eid = TextEditingController();
  final TextEditingController _controller_no = TextEditingController();
  final TextEditingController _controller_loc = TextEditingController();
  final TextEditingController _controller_pwd = TextEditingController();

  Future<ResponseData> _futureData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "SignUp",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green[100]],
                stops: [0.9, 1])),
        child: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_nm,
                      obscureText: false,
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText:"User Name")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "UserID",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_uid,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "UserID will be used to LogIn")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email ID",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_eid,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Email ID")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Mobile No",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      controller: _controller_no,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Mobile No.")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Location",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_loc,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Location")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Password",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_pwd,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Password")),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    print("Register Button pressed");

                    if (_controller_uid.text == "" ||
                        _controller_pwd.text == "" ||
                        _controller_no.text == "" ||
                        _controller_nm.text == "") {
                      showError(context, "Enter all details");
                    } else {
                      _futureData = trySignUp(
                          _controller_nm.text,
                          _controller_uid.text,
                          _controller_eid.text,
                          _controller_no.text,
                          _controller_pwd.text,
                          _controller_loc.text);
                    }

                    var _data, _error;
                    _futureData.then((res) {
                      _data = res.result;
                      _error = res.error;
                      print("Data:$_data  Error:$_error");
                      if (_data == 'done') {
                        Navigator.pop(context);
                        showMessage(context,
                            "User Registered Successfully!\nSign In to continue");
                      } else {
                        if (_error == "E_USER_ALREADY_EXIST")
                          showError(context,
                              "UserID already in use\nTry another one");
                        else
                          showError(context, _error);
                        print(_error);
                      }
                    });
                    _futureData = null;
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
