import 'package:flutter/material.dart';
import 'dart:convert';

import './Classes.dart';

showError(BuildContext context, String error) {
  var alert = AlertDialog(
  //  backgroundColor: Colors.red[100],
    title: Text(
      '$error',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
      ),
    ),
    actions: <Widget>[
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Back"))
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

showMessage(BuildContext context, String msgTitle) {
  var alert = AlertDialog(
    title: Text('$msgTitle',textAlign: TextAlign.center,),
    content: Icon(
      Icons.done,
      color: Colors.green,
    ),
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

List<Order> parseOrders(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}
