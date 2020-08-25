import 'package:flutter/material.dart';
import 'dart:ffi';

var url = 'http://192.168.1.35:8000/user';

class ResponseData {
  final String result;
  final String error;

  ResponseData({this.result, this.error});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(result: json['status'], error: json['ERROR']);
  }
}

class LoginData {
  final String name;
  final String user;
  final String email;
  final String no;
  final String token;
  final String error;

  LoginData(
      {this.name, this.user, this.email, this.no, this.token, this.error});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    print("Login");
    print(json);
    return LoginData(
        name: json['Name'],
        user: json['User'],
        email: json['Email'],
        no: json['No'].toString(),
        token: json['token'],
        error: json['ERROR']);
  }
}

class Item {
  String code;
  String name;
  String type;
  double qty;
  double price;
  String vId;

  Item({this.code, this.name, this.type, this.qty, this.price, this.vId});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      code: json['Code'].toString(),
      name: json['Name'].toString(),
      type: json['Type'].toString(),
      qty: json['Qty'].toDouble(),
      price: json['Price'].toDouble(),
      vId: json['vId'].toString(),
    );
  }
}

class Item_ {
  String code;
  String name;
  String type;
  double qty;
  double price;
  String vId;
  double total;

  Item_(
      {this.code,
      this.name,
      this.type,
      this.qty,
      this.price,
      this.total,
      this.vId});
}

class Order {
  String orderId;
  String time;
  String from;
  List<String> to;
  List<Item> items;
  double total;

  Order({this.time, this.from, this.to, this.items, this.total, this.orderId});

  factory Order.fromJson(Map<String, dynamic> json) {
    var toData = json['To'];
    List<String> toList = List<String>.from(toData);

    var itemData = json['Items'];
    var parsedItems = itemData.cast<Map<String, dynamic>>();
    List<Item> itemList =
        parsedItems.map<Item>((j) => Item.fromJson(j)).toList();
    return Order(
      time: json['Time'].toString(),
      from: json['From'].toString(),
      to: toList,
      items: itemList,
      total: json['Total'].toDouble(),
      orderId: json['OrderID'].toString(),
    );
  }
}

class OrderStatus {
  List<Order> pending;
  List<Order> confirmed;
  List<Order> completed;

  OrderStatus({this.pending, this.confirmed, this.completed});

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    var pnd = json['Pending'];
    var parsedPnd = pnd.cast<Map<String, dynamic>>();
    List<Order> pndOrd =
        parsedPnd.map<Order>((j) => Order.fromJson(j)).toList();

    var cnf = json['Confirmed'];
    var parsedCnf = cnf.cast<Map<String, dynamic>>();
    List<Order> cnfOrd =
        parsedCnf.map<Order>((j) => Order.fromJson(j)).toList();

    var cmp = json['Completed'];
    var parsedCmp = cmp.cast<Map<String, dynamic>>();
    List<Order> cmpOrd =
        parsedCmp.map<Order>((j) => Order.fromJson(j)).toList();
    return OrderStatus(pending: pndOrd, confirmed: cnfOrd, completed: cmpOrd);
  }
}
