import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './Classes.dart';
import './Functions.dart';
import './signin.dart';
import './items.dart';
import './changepwd.dart';
import './loginStatus.dart';
import './orders.dart';
import 'cart.dart';

Future<ResponseData> logout() async {
  final response = await http.post(
    url + '/logout',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': user['token'],
    },
    body: jsonEncode(<String, String>{
      'User': user['uname'],
    }),
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return ResponseData.fromJson(data);
  } else {
    throw Exception('Failed to logout');
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<ResponseData> _futureData;

  _saveLogoutStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user['isLoggedIn'] = 0;
      user['token'] = 'v';
      user['uname'] = '';
      user['name'] = "";
      user['no'] = "";
      user['email'] = "";
      prefs.setInt('isLoggedIn', 0);
      prefs.setString('token', 'v');
      prefs.setString('uname', '');
      prefs.setString('name', "");
      prefs.setString('no', "");
      prefs.setString('email', "");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user['isLoggedIn'] == 0)
      return SignIn();
    else
      return Scaffold(
        appBar: AppBar(title: Text("Home")),
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                  width: double.infinity,
                  color: Colors.green[700],
                  child: Text(
                    "Stay Home User",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
              UserThumbnail(),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              DrawerOption(
                text: "Change Password",
                icon: Icons.vpn_key,
                page: ChangePwd(),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
            ],
          ),
        ),
        body: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            HomePageButton(
              text: "Cart",
              icon: Icons.shopping_cart,
              page: Cart(),
            ),
            HomePageButton(
              text: "View Items",
              icon: Icons.update,
              page: ItemsPage(),
            ),
            HomePageButton(
                text: "Show Orders",
                icon: Icons.shopping_basket,
                page: OrderPage()),
            Container(
              padding: EdgeInsets.all(12),
              child: FlatButton(
                onPressed: () async {
                  _futureData = logout();
                  _futureData.then((data) {
                    if (data.result == 'done') {
                      _saveLogoutStatus();
                      setState(() {
                        user['isLoggedIn'] = 0;
                      });
                    } else {
                      showError(context, data.error);
                    }
                  });
                  _futureData = null;
                },
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        size: 50,
                      ),
                      Text("Logout")
                    ]),
                color: Colors.green,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      );
  }
}

class HomePageButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final dynamic page;
  HomePageButton({this.text, this.icon, this.page});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return page;
          }));
        },
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              )
            ]),
        color: Colors.green,
        textColor: Colors.white,
      ),
    );
  }
}

class UserThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.green[500],
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
              Text(
                user['uname'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
            width: double.infinity,
            color: Colors.green[500],
            child: Center(
                child: Text(
              user['name'],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )))
      ],
    );
  }
}

class DrawerOption extends StatelessWidget {
  final String text;
  final IconData icon;
  final page;
  DrawerOption({@required this.text, @required this.icon, @required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return page;
          }));
        },
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
