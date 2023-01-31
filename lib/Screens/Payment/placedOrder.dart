import 'dart:async';

import "package:flutter/material.dart";

import '../Login_module/LoginScreen.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({Key? key}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  void initState() {
    //super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/tick.gif",
            ),
            Center(
              child: Text(
                "Order has been place successfully",
                style: TextStyle(fontSize: 23, color: Colors.green),
              ),
            )
          ],
        ),
        // Text("Order Placed", style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
