import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../models/category.dart';
import '../models/cusine.dart';
import '../screens/MasterCategory.dart';

class CusineScreen extends StatefulWidget {
  @override
  State<CusineScreen> createState() => _CusineScreenState();
}

class _CusineScreenState extends State<CusineScreen> {
  List cuisine = [];
  List cuisineImage = [];
  List pricding = [];
  List cuisineHotels = [];
  var testing;

  void initState() {
    Cusine();
    super.initState();
  }

  Future<void> Cusine() async {
    var mapResponse;
    print("______________Cuisine__in");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8086/api/get_cuisines'),
    );
    if (response.statusCode == 200) {
      print("______________________Cuisines Response");
      mapResponse = json.decode(response.body);
      final dataa = json.decode(response.body);
      print(mapResponse['data']);
      cuisine = dataa["data"];
      var iniside = cuisine[1]['media'];
      var ki = iniside[0]['mediaDetailSno'].toString();
      var kk = iniside[0]['thumbnailUrl'];
      setState(() {
        cuisine = dataa["data"];
      });
      for (var t = 0; t < cuisine.length; t++) {
        var mediaa = cuisine[t]['media'];
        var thumbnail = mediaa[0]['thumbnailUrl'];
        print(thumbnail);
        cuisineImage.add(thumbnail);
      }
    } else {
      throw Exception("Failed to get Restaurants");
    }
  }

  Future<void> getCuisineHotel(context, cuisineIndex) async {
    var mapResponse;
    print("----------------------------------------getCuisineHotel");
    print(cuisineIndex);
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/get_more_suggestion_entity?cuisinesSno=${cuisineIndex['cuisineSno']}'),
    );
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      print("---------------------------------------------------");
      print(mapResponse["data"]);
      print("<<<<<<>CuisinesHotels");
      if (mapResponse["data"] != null) {
        print(">>>>>>>>>>>if condition CuisinesHotels<<<<<<<<<<");
        setState(() {
          cuisineHotels = mapResponse["data"];
        });
      } else {
        print("CuisineHotels null");
        setState(() {
          cuisineHotels = [];
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterCategory(
              hotelList: cuisineHotels,
              entityDetals: cuisineIndex,
              headerName: cuisineIndex['cuisineName'],
            ),
          ));
    } else {
      throw Exception("Failed to get Restaurants");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cuisine.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                getCuisineHotel(context, cuisine[index]);
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
                          '${cuisine[index]["media"][0]["mediaUrl"]}'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${cuisine[index]['cuisineName']}",
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
