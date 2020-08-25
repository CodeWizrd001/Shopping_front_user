import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './loginStatus.dart';
import './Classes.dart';
import './Functions.dart';

Future<ResponseData> changePassword(String cPwd, String nPwd) async {
  final response = await http.post(
    url + '/changepwd',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': user['token'],
    },
    body: jsonEncode(<String, String>{
      'User': user['uname'],
      'NewPassword':nPwd,
      'CurPassword':cPwd
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return ResponseData.fromJson(data);
  } else {
    throw Exception('Failed to SignUp');
  }
}

class ChangePwd extends StatelessWidget {
  final TextEditingController _controller_CPwd = TextEditingController();
  final TextEditingController _controller_NPwd1 = TextEditingController();
  final TextEditingController _controller_NPwd2 = TextEditingController();
  Future<ResponseData> _futureData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Change Password",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Current Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                    controller: _controller_CPwd,
                    obscureText: true,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: "Current Password")),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "New Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                    controller: _controller_NPwd1,
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: "Type New Password")),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Re-Type Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                    controller: _controller_NPwd2,
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: "Re-Type New Password")),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
              child: FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () async {
                  print("Change Button pressed");

                  if (_controller_CPwd.text == "" ||
                      _controller_NPwd1.text == "" ||
                      _controller_NPwd2.text == "") {
                    showError(context, "Enter all details");
                  } else if (_controller_NPwd1.text != _controller_NPwd2.text) {
                    showError(context, "Entered passwords does not match!");
                  } else {
                    _futureData = changePassword(
                        _controller_CPwd.text, _controller_NPwd1.text);
                  }

                  var _data, _error;
                  _futureData.then((res) {
                    _data = res.result;
                    _error = res.error;
                    print("Data:$_data  Error:$_error");
                    if (_data == 'done') {
                      Navigator.pop(context);
                      showMessage(context,
                          "Password Updated");
                    } else {
                      showError(context, _error);
                      print(_error);
                    }
                  });
                  _futureData = null;
                },
                child: Text(
                  "Update Password",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
