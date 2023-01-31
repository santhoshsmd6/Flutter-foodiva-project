import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({Key? key}) : super(key: key);
  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {

  List<Product> Adlist = [];
  int numb = 0;
  List adver = [];
  List display = [];

  Future<void> adv() async {
    var mapResponse;
    print("_____________Ranjiths");
    print("in");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8087/api/get_advertisement'),
    );

    mapResponse = json.decode(response.body);
    final getting = json.decode(response.body);
    adver = getting["data"];
    var category = adver[1]['media'];
    var delivery = category[0]['mediaDetailSno'].toString();
    print(delivery);
    var fifty = category[0]['thumbnailUrl'];
    print(delivery);
    print(fifty + "super");
    setState(() {
      adver = getting["data"];
    });
    print(adver.length.toString() + "ddddd");

    for (var rate = 0; rate < adver.length; rate++) {
      var offer = adver[rate]['media'];
      var express = offer[0]['thumbnailUrl'];
      var answer = adver[rate]['advertisementName'];
      print(express);
      display.add(express);
      Adlist.add(Product(url: 'adver'));
    }
  }

  void initState() {
    print("_____________Ranjith");
    adv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: adver.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15,top: 10,right: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    '${display[index]}',
                     width: 150.0,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final String url;

  Product({
    required this.url,
  });
}

