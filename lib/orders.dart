import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './Classes.dart';
import './loginStatus.dart';
import './orderdetails.dart';

Future<OrderStatus> fetchOrders() async {
  final response = await http.post(url + '/status',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': user['token'],
      },
      body: jsonEncode(<String, dynamic>{'User': user['uname']}));

  if (response.statusCode == 200) {
    return await compute(parseOrders, response.body);
  } else {
    throw Exception("Unable to fetch order details");
  }
}

Future<OrderStatus> parseOrders(String responseBody) async {
  Map<String,dynamic> data = jsonDecode(responseBody);
  OrderStatus status = OrderStatus.fromJson(data);
  return status;
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  
  Future<OrderStatus> _refresh() {
    Future<OrderStatus> _orderStatus;
    setState(() {
      _orderStatus = fetchOrders();
    });
    return _orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Orders"),
            bottom: TabBar(tabs: [
              Tab(
                text: "Pending",
                icon: Icon(Icons.access_time),
              ),
              Tab(
                text: "Confirmed",
                icon: Icon(Icons.done),
              ),
              Tab(
                text: "Completed",
                icon: Icon(Icons.done_all),
              )
            ]),
          ),
          body: TabBarView(children: [
            RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<OrderStatus>(
                future: _refresh(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else
                    return (snapshot.hasData)
                        ? OrderList(
                            orders: snapshot.data.pending,
                            edit: 1,
                          )
                        : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<OrderStatus>(
                future: _refresh(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else
                    return (snapshot.hasData)
                        ? OrderList(
                            orders: snapshot.data.confirmed,
                            edit: 0,
                          )
                        : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<OrderStatus>(
                future: _refresh(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Icon(Icons.error));
                  } else
                    return (snapshot.hasData)
                        ? OrderList(
                            orders: snapshot.data.completed,
                            edit: 0,
                          )
                        : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]),
        ));
  }
}

class OrderList extends StatelessWidget {
  final int edit;
  final List<Order> orders;

  OrderList({this.orders, this.edit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderView(order: orders[index], edit: edit);
      },
    );
  }
}

class OrderView extends StatelessWidget {
  final int edit;
  final Order order;
  OrderView({this.order, this.edit});
  final _style =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.green[100],
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("OrderID : ${order.orderId}", style: _style),
                    Text("UserID : ${user['uname']}", style: _style),
                    Text("Time : ${order.time}", style: _style),
                    Text("No. of Items : ${order.items.length}", style: _style),
                    Text("Total Price : ${order.total}", style: _style),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OrderDetails(order, edit);
                    }));
                  },
                  child: Text("View"),
                  color: Colors.blue[600],
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
