import 'dart:collection';
// import 'dart:html';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DataClass extends ChangeNotifier {
  late Position _positionLatLong;
  Position get positionLatLong => _positionLatLong;

  List _count = List.filled(1000, 0);
  Map _selectedItem = {} as Map;
  Map get selectedItem => _selectedItem as Map;
  List get count => _count;
  int price = 300;
  int product = 9;
  int i = 0;
  String _entiname = "";
  String _entino = "";
  String _CustomerFirstName = "";
  String _CustomerLastName = "";
  String _CustomerEmail = "";
  String _phoneNumber = "";
  String _hotelNames = "";
  String _identifier = "";
  // late File _categoryImage;
  String get identifier => _identifier;
  // File get categoryImage => _categoryImage;
  String get hotelNames => _hotelNames;
  String get PhoneNumber => _phoneNumber;
  String get CustomerFirstName => _CustomerFirstName;
  String get CustomerLastName => _CustomerLastName;
  String get CustomerEmail => _CustomerEmail;
  String get entiname => _entiname;
  String get entino => _entino;

  Map _getLoginRes = {} as Map;
  Map get getLoginRes => _getLoginRes as Map;

  int subItemCount = 0;
  int _orderCount = 0;
  int get orderCount => _orderCount;
  int totalCost = 0;

  addItem(int itemValue) {
    print("swetha");
    print(itemValue);
    subItemCount = subItemCount + itemValue;
    print("testssssss");
    print(subItemCount);
  }

  void setLoginRes(loginResponse, deviceId) {
    _getLoginRes = loginResponse;
    _identifier = deviceId;
  }

  void incrementX(productValue, productndex) {
    _orderCount = 0;
    if (_count[productndex] == 0) {
      _selectedItem[(i++).toString()] = productValue;
    }
    _count[productndex]++;
    print('<<<<<---------inc------>>>>>>>>>>>>$i');
    totalCost = totalCost +
        productValue['prodcutList']['data'][0]['sellingPrice'] as int;
    print('<<<<<---------inc------>>>>>>>>>>>>$totalCost');
    for (int i = 0; i < _count.length; i++) {
      _orderCount = _orderCount + _count[i] as int;
    }
  }

  void decrementX(productValue, productndex) {
    _orderCount = _orderCount - 1;
    if (_count[productndex] > 0) {
      _count[productndex]--;
    }
    if (_count[productndex] == 0) {
      print("<<<<<----rem--------->>>>");
      i--;
      _selectedItem.removeWhere(
        (key, value) => value == productValue || key == null,
      );
    }
    totalCost = totalCost +
        productValue['prodcutList']['data'][0]['sellingPrice'] as int;
    print('<<<<<---------dec------>>>>>>>>>>>>$i');
  }

  void setUserDetails(value1, value2, value3) {
    print("________________________________paithikara roobaan");
    print(value1);
    _CustomerFirstName = value1;
    _CustomerLastName = value2;
    _CustomerEmail = value3;
  }

  void userMobileNumber(value4) {
    print(value4);
    _phoneNumber = value4;
  }

  void FoodList(value4, value5) {
    print(value5);
  }

  void hotelName(value6) {
    print(value6);
  }

  void position(position) {
    print("rathipriya current position");
    print(position);
    _positionLatLong = position;
  }
}
