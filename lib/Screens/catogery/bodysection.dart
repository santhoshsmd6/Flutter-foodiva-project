import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mr_food1/Screens/catogery/product.dart';
import 'package:provider/provider.dart';
import '../Master Category/expansion.dart';
import '../Payment/data_class.dart';
import 'add.dart';

List<add> nearbylist = [
  add(image: 'kirai.jpeg', name: 'Adaya', rate: '4.5', min: '45 Min'),
  add(image: 'paalak.jpg', name: 'Sangeetha Hotel', rate: '3.4', min: '55 Min'),
  add(
      image: 'sambhar.jpg',
      name: 'Vegetarian Food',
      rate: '3.5',
      min: '35 Min'),
  add(
      image: 'kabab.jpg',
      name: 'Anjappar Vegetarian Hotel',
      rate: '4.0',
      min: '25 Min'),
  add(image: 'veg.jpg', name: 'Saravana Bhavan', rate: '5.0', min: '55 Min'),
];

class nearby extends StatefulWidget {
  final Position? currentPosition;
  const nearby({Key? key, required this.currentPosition}) : super(key: key);

  @override
  State<nearby> createState() => _nearbyState();
}

class _nearbyState extends State<nearby> {
  var entino;
  String? ans;
  var supe;
  var hum;
  List datain = [];

  void initState() {
    lo();
    print("++++++++++++++++++++++++++++++++++++++++++++++jothika");
    print(widget.currentPosition);
    super.initState();
  }

  Future<void> lo() async {
    print("ywdtusaydtuasydas");
    var mapResponse;
    print("in");
    final response = await http.get(
      Uri.parse(
          // Since using emulator so hidden real lat and long(fetching us loaction)
          // 'http://192.168.0.161:8084/api/get_more_suggestion_entity/?latitude=${'widget.currentPosition.Latitude'}&longitude=${'widget.currentPosition.Longitude'}'),

          //   static lat and long
          'http://192.168.0.161:8084/api/get_more_suggestion_entity/?latitude=12.9335296&longitude=80.2193408'),
    );
    mapResponse = json.decode(response.body);
    final vv = json.decode(response.body);
    print(mapResponse['data']);
    datain = vv["data"];
    print("######################333");
    print(datain[1]['entityName']);
    setState(() {
      datain = vv["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: datain.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Expansion(
                              check: datain[index]['entitySno'],
                              checks: datain[index]['entityName'],
                            )));
              },
              child: Row(
                children: <Widget>[
                  Container(
                    width: 85,
                    height: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/${nearbylist[index].image}"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 268,
                    height: 150.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              // color: Colors.grey,
                            ),
                            child: Text(
                              "${datain[index]['entityName']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 25,
                                    ),
                                    Container(
                                      child: Text('4.5'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 15),
                              child: Container(
                                child: Text("45 Min"),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Container(
                            child: Text(
                              "4140 Parker Rd,Allentown,New Mexico 31134",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //  child: Text("Selvam Chettinad",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
