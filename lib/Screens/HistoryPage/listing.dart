import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'rebutton.dart';

class listing extends StatefulWidget {
  final List orders;
  const listing({Key? key, required this.orders}) : super(key: key);

  @override
  State<listing> createState() => _listingState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _listingState extends State<listing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.orders != null
          ? ListView.builder(
              itemCount: widget.orders.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                  child: Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   color: Colors.grey.shade200,
                      // )
                      //     border: Border.all(
                      //   color: Colors.grey.shade200,
                      // )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          child: ClipRRect(
                            // border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(18.0),
                            // width: 100,
                            child: Image.asset(
                              'assets/images/kabab.jpg',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 36,
                                alignment: Alignment.center,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: Colors.red)),
                                child: Text(
                                  "${widget.orders[index]['orderDetails'][0]['productName']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  '#Order Number-${widget.orders[index]['orderSno']}',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 170,
                                    child: Text(
                                      '1901 Thornridge Cir.Shiloh, Hawali 81603',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      width: 50,
                                      child: Text(
                                        'Yesterday',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: HexaColor("#0E6202"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  // width: 220,
                                  // width: MediaQuery.of(context).size.width * 0.001,
                                  child: rebutton(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text("loading"),
            ),
    );
  }
}
