import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './loginStatus.dart';
import './signup.dart';
import './home.dart';
import './Classes.dart';
import './Functions.dart';

Future<LoginData> _makePostRequest(String _userName, String _password) async {
  var response = await http.post(
    url + '/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'vSignIn'
    },
    body:
        jsonEncode(<String, String>{'User': _userName, 'Password': _password}),
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return LoginData.fromJson(data);
  } else {
    throw Exception('Failed to SignUp');
  }
}

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  var _userName;
  var _password;

  final idCont = TextEditingController();
  final passCont = TextEditingController();

  Future<LoginData> _futureData;

  _saveLoginStatus(LoginData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user['isLoggedIn'] = 1;
      user['token'] = data.token;
      user['uname'] = data.user;
      user['name'] = data.name;
      user['no'] = data.no;
      user['email'] = data.email;
      prefs.setInt('isLoggedIn', 1);
      prefs.setString('token', data.token);
      prefs.setString('uname', data.user);
      prefs.setString('name', data.name);
      prefs.setString('no', data.no);
      prefs.setString('email', data.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user['isLoggedIn'] == 1)
      return Home();
    else
      return Scaffold(
          appBar: AppBar(
            title: Text("Stay Home Admin"),
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.green[100]],
                    stops: [0.9, 1])),
            child: Center(
              child: ListView(shrinkWrap: false, children: <Widget>[
                SizedBox(height: 10),
                Image.asset('assets/images/logo240.png',
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.30),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(45, 0, 45, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //        Text('UserID',
                      //            style: TextStyle(
                      //              color: Colors.black,
                      //              fontWeight: FontWeight.bold,
                      //              fontFamily: 'OpenSans',
                      //            )),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                        child: TextField(
                            controller: idCont,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              hintText: 'UserID',
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(45, 10, 45, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //        Text('Password',
                      //            style: TextStyle(
                      //              color: Colors.black,
                      //              fontWeight: FontWeight.bold,
                      //              fontFamily: 'OpenSans',
                      //            )),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: TextField(
                            controller: passCont,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(45, 20, 45, 10),
                    width: double.infinity,
                    child: FlatButton(
                      padding: EdgeInsets.all(8),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (idCont.text == "" || passCont.text == "") {
                          showError(context, "Enter Username and Password");
                        } else {
                          _userName = idCont.text;
                          _password = passCont.text;
                          print('Login Button Pressed');

                          _futureData = _makePostRequest(_userName, _password);
                          var _error, _data;
                          _futureData.then((res) {
                            _error = res.error;
                            _data = res;
                            if (_error != null) {
                              showError(context, _error);
                            } else {
                              _saveLoginStatus(_data);
                              idCont.clear();
                              passCont.clear();
                            }
                          });

                          _futureData = null;
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 1.5,
                        ),
                      ),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignUp();
                      }));
                    },
                    child: Text(
                      "New user? SignUp",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans'),
                    ))
              ]),
            ),
          ));
  }
}
