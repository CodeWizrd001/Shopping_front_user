import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Classes.dart';
import 'loginStatus.dart';
import 'package:http/http.dart' as http;

List<Item_> cart = [];

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0.0;

  void edit(item) {
    Alert(
      title: "Edit Item",
      desc: "Not Implemented",
      context: context,
    ).show();
  }

  List<Widget> getList() {
    total = 0.0;
    List<Widget> temp = [];
    for (int i = 0; i < cart.length; i += 1) {
      Container tTile = Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen[100],
          border: Border.all(
            color: Colors.green,
          ),
        ),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 20,
                child: Text(
                  cart[i].name,
                  overflow: TextOverflow.clip,
                ),
              ),
              Center(
                child: Text(cart[i].total.toString()),
              )
            ],
          ),
          trailing: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
              print(constraint.maxHeight);
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: constraint.maxHeight / 3 - 1,
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text("Edit"),
                      onPressed: () {
                        edit(cart[i]);
                        print("Edit Pressed $i");
                      },
                    ),
                  ), // Edit Option To Be added
                  SizedBox(
                    height: constraint.maxHeight / 8,
                  ),
                  SizedBox(
                    height: constraint.maxHeight / 3 - 1,
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text("Remove"),
                      onPressed: () {
                        setState(
                          () {
                            cart.remove(cart[i]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
      temp.add(tTile);
      temp.add(
        SizedBox(
          height: 5,
        ),
      );
      total += cart[i].total;
      print(cart[i].name);
      print(cart[i].price);
    }
    return temp;
  }

  List<Map<String, dynamic>> getCart() {
    List<Map<String, dynamic>> tempList = [];
    for (int i = 0; i < cart.length; i += 1) {
      Map<String, dynamic> temp = {
        'Code': cart[i].code,
        'Name': cart[i].name,
        'Type': cart[i].type,
        'Qty': cart[i].total/cart[i].price,
        'Price': cart[i].price,
        'vId': cart[i].vId,
      };
      tempList.add(temp);
    }
    return tempList;
  }

  Future<int> placeOrder() async {
    final response = await http.post(url + '/order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': user['token'],
        },
        body: jsonEncode(<String, dynamic>{'User':user['uname'],'Cart': getCart()}));

    if (response.statusCode == 200) {
      Map<String, dynamic> x = jsonDecode(response.body);
      print(x);
      try {
        if (x['status'] == 'done') return 1;
      } catch (e) {
        return 0;
      }
    } else {
      return 0;
    }
    print(response.statusCode);
    return 0;
  }

  void order() {
    Alert(
      title: "Status",
      context: context,
      buttons: [
        DialogButton(
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          width: 120,
        )
      ],
      content: Container(
        child: Container(
          child: FutureBuilder<int>(
            future: placeOrder(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 1)
                  return Container(
                    child: Text("Order Placed"),
                  );
                else
                  return Container(
                    child: Text("Order Failed"),
                  );
              } else
                return Container(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ),
      ),
    ).show();
    print("Order Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: getList(),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Total : $total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Center(
              child: RaisedButton(
                child: Text("Order"),
                onPressed: order,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
