import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import './loginStatus.dart';
import './Classes.dart';
import './Functions.dart';
import 'cart.dart' ;

Future<List<Item>> fetchItems() async {
  final response = await http.post(url + '/listitems',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': user['token'],
      },
      body: jsonEncode(<String, String>{'User': user['uname']}));
  if (response.statusCode == 200) {
    return compute(parseItems, response.body);
  } else {
    throw Exception("Failed to fetch items");
  }
}

List<Item> parseItems(String responseBody) {
  var data = jsonDecode(responseBody);
  data = data["Items"];
  final parsed = data.cast<Map<String, dynamic>>();
  List<Item> items = parsed.map<Item>((json) => Item.fromJson(json)).toList();
  items.sort((a, b) => a.name.compareTo(b.name));
  return items;
}

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items")),
      body: FutureBuilder<List<Item>>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print(
              snapshot.error,
            );

          return snapshot.hasData
              ? _ItemsList(items: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  final List<Item> items;

  _ItemsList({this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ItemView(items[index]);
      },
    );
  }
}

class _ItemView extends StatelessWidget {
  final Item it;
  _ItemView(this.it);
  final _style =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.lightGreen[100],
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    it.code,
                    style: _style,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(it.name,
                        style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ),
                  Text(it.type, style: _style),
                  Text('Price: ${it.price}', style: _style),
                  Text('Stock: ${it.qty}', style: _style),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddCart(it);
                        }));
                      },
                      child: Text("Add"),
                      color: Colors.blue[600],
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5)
      ],
    );
  }
}

/*


Next Part 
Add Cart


*/



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

  String Cd_text;
  String Nm_text;
  String Qty_text;
  double Mrp_text;
  TextEditingController Qty_cont = TextEditingController();
  double total;
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
    Cd_text = old.code;
    Nm_text = old.name;
    Mrp_text = old.price;
    Qty_text = "0";
    Qty_cont.text = "0";
    total = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
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
                "Add Item To Cart",
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
                  Text(
                    Nm_text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
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
                  Text(
                    Cd_text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
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
                  Text(
                    Nm_text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Quantity",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: Qty_cont,
                    obscureText: false,
                    onChanged: (text) {
                      setState(() {
                        total = Mrp_text * double.parse(text);
                        if(total<0) 
                          total = 0 ;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        hintText: "Enter Quantity"),
                  ),
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
                  Text(
                    Mrp_text.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    total.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: (){
                    print("Button pressed");
                    setState(
                      () {
                        if (total == 0.0) {
                          showError(context, "Enter Correct Quantity");
                        } else {
                          Item_ item_ = Item_(
                              code: Cd_text,
                              name: Nm_text,
                              type: typValue,
                              qty: double.parse(Qty_text),
                              price: Mrp_text ,
                              total: Mrp_text * double.parse(Qty_cont.text),
                              vId: old.vId,);
                          print(cart) ;
                          print("MRP $Mrp_text") ;
                          print(item_.price) ;
                          cart.add(item_);
                          Alert(
                            title: "Item Added To Cart",
                            context: context,
                          ).show();
                        }
                      },
                    );
                  },
                  child: Text(
                    "Add To Cart",
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
