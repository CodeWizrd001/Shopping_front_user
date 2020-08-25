import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './loginStatus.dart';
import './Classes.dart';
import './Functions.dart';

Future<ResponseData> addCart(
    String cd, String nm, String typ, String qty, String mrp, Item old) async {
  var oldData = {
    'Code': old.code,
    'Name': old.name,
    'Type': old.type,
    'Qty': old.qty,
    'Price': old.price,
    'vId': old.vId
  };

  var newData = {
    'Code': cd,
    'Name': nm,
    'Type': typ,
    'Qty': qty,
    'Price': mrp,
    'vId': old.vId
  };

  final response = await http.post(
    url + '/edititem',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': user['token'],
    },
    body: jsonEncode(<String, dynamic>{
      'User': user['uname'],
      'Old': oldData,
      'New': newData,
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return ResponseData.fromJson(data);
  } else {
    throw Exception('Failed to SignUp');
  }
}

class AddCart extends StatefulWidget {
  final Item item;
  AddCart(this.item);
  @override
  _AddCartState createState() => _AddCartState(item);
}

class _AddCartState extends State<AddCart> {
  final Item old;
  _AddCartState(this.old);

  final TextEditingController _controller_Cd = TextEditingController();
  final TextEditingController _controller_Nm = TextEditingController();
  final TextEditingController _controller_Qty = TextEditingController();
  final TextEditingController _controller_Mrp = TextEditingController();
  String typValue;

  List<String> typList = [
    '--Select--',
    'Rice',
    'Cereals',
    'Oil',
    'Spices',
    'Flours and Powders',
    'Nuts',
    'Tolilet items',
    'Cleaning aids'
  ];

  initState() {
    super.initState();
    typValue = old.type;
    _controller_Cd.text = old.code;
    _controller_Nm.text = old.name;
    _controller_Mrp.text = old.price.toString();
    _controller_Qty.text = old.qty.toString();
  }

  Future<ResponseData> _futureData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Item")),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green[100]],
                stops: [0.9, 1])),
        height: double.infinity,
        child: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Text(
                "Update Item Details",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 25, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Item Name",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      maxLength: 70,
                      controller: _controller_Nm,
                      obscureText: false,
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Item Name")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Item Code",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      controller: _controller_Cd,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Old Item Code:${old.code}")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Item Type",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Select"),
                    value: typValue,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.green,
                    ),
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    underline: Container(height: 2, color: Colors.green),
                    onChanged: (String newValue) {
                      setState(() {
                        typValue = newValue;
                      });
                    },
                    items: typList.map((String val) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          '$val',
                          style: TextStyle(fontSize: 16),
                        ),
                        value: val,
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Stock",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      keyboardType: TextInputType.number,
                      controller: _controller_Qty,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Enter new stock")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Price",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                      keyboardType: TextInputType.number,
                      controller: _controller_Mrp,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Enter new Price")),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    print("Button pressed");
                    setState(() {
                      if (_controller_Nm.text == "" ||
                          _controller_Cd.text == "" ||
                          typValue == '--Select--' ||
                          _controller_Qty.text == "" ||
                          _controller_Mrp.text == "") {
                        showError(context, "Enter all details");
                      } else {
                        _futureData = addCart(
                            _controller_Cd.text,
                            _controller_Nm.text,
                            typValue,
                            _controller_Qty.text,
                            _controller_Mrp.text,
                            old);
                      }
                    });
                    String _data, _error;
                    _futureData.then((res) {
                      _data = res.result;
                      _error = res.error;
                      print("Data:$_data  Error:$_error");
                      if (_data == 'done') {
                        Navigator.pop(context);
                        showMessage(
                            context, "Item details Updated Successfully");
                      } else {
                        showError(context, _error);
                        print(_error);
                      }
                    });
                    _futureData = null;
                  },
                  child: Text(
                    "Update",
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
