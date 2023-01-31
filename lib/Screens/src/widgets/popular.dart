import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../models/barnd.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../screens/MasterCategory.dart';

class brandScreen extends StatefulWidget {
  @override
  State<brandScreen> createState() => _brandScreenState();
}

class _brandScreenState extends State<brandScreen> {
  List brand = [];
  File? brandImage;
  List brandHotels = [];

  // http://localhost:8086/api/get_brand
  Future<void> Cusine() async {
    var mapResponse;
    print("______________11111111111111__in");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8086/api/get_brand'),
    );
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      final dataa = json.decode(response.body);
      print(mapResponse['data']);
      brand = dataa["data"];
      var iniside = brand[1]['media'];
      var ki = iniside[0]['mediaDetailSno'].toString();
      var kk = iniside[0]['thumbnailUrl'];
      setState(() {
        brand = dataa["data"];
      });
      for (var t = 0; t < brand.length; t++) {
        var mediaa = brand[t]['media'];
        var thumbnail = mediaa[0]['thumbnailUrl'];
        //var mname=cuisine[t]['masterCategoryName'];
        print(thumbnail);
      }
    } else {
      throw Exception("Failed to get Restaurants");
    }
  }

  Future<void> getBrandHotel(context, brandIndex) async {
    var mapResponse;
    print("----------------------------------------getBrandHotel");
    print(brandIndex);
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/get_more_suggestion_entity?brandSno=${brandIndex['brandSno']}'),
    );
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      print("---------------------------------------------------");
      print(mapResponse["data"]);
      if (mapResponse["data"] != null) {
        setState(() {
          brandHotels = mapResponse["data"];
        });
      } else {
        setState(() {
          brandHotels = [];
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterCategory(
              hotelList: brandHotels,
              entityDetals: brandIndex,
              headerName: brandIndex['brandName'],
            ),
          ));
    } else {
      throw Exception("Failed to get Restaurants");
    }
  }

  void initState() {
    Cusine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brand.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                getBrandHotel(context, brand[index]);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.18,
                    decoration: BoxDecoration(
                        color: white,
                        //border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(100)),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          '${brand[index]["media"][0]["mediaUrl"]}'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${brand[index]['brandName']}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: black),
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
