import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Drop Order",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          ),
          Container(
            height: 75,
            width: 30,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black),
                image: DecorationImage(
                    image:
                    AssetImage('assets/images/Drop.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }
}
