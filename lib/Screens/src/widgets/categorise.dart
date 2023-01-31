import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Master Category/pureveg.dart';
import '../../Payment/data_class.dart';
import '../helpers/colors.dart';
import '../helpers/screen_navigation.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

import '../screens/MasterCategory.dart';

class categorise extends StatefulWidget {
  const categorise({Key? key}) : super(key: key);

  @override
  State<categorise> createState() => _categoriseState();
}

class _categoriseState extends State<categorise> {
  Color HexaColor(String strcolor, {int opacity = 15}) {
    //opacity is optional value
    strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
    String stropacity =
        opacity.toRadixString(16); //convert integer opacity to Hex String
    return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
    //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
  }

  List<category> categoriseList = [];
  var supe;
  var hum;
  int inivalue = 0;
  List datain = [];
  List dname = [];
  List pricing = [];
  var testing;
  List<dynamic> Hotel = [];

  void initState() {
    lo();
    super.initState();
  }

  Future<void> lo() async {
    var mapResponse;

    print("-------------------------master Cat in ---------");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8086/api/get_master_category'),
    );
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      final dataa = json.decode(response.body);
      print(mapResponse['data']);
      datain = dataa["data"];
      var iniside = datain[1]['media'];
      var ki = iniside[0]['mediaDetailSno'].toString();
      var kk = iniside[0]['thumbnailUrl'];
      setState(() {
        datain = dataa["data"];
      });
      for (var t = 0; t < datain.length; t++) {
        var mediaa = datain[t]['media'];
        var thumbnail = mediaa[0]['thumbnailUrl'];
        var mname = datain[t]['masterCategoryName'];
        print(thumbnail);
        dname.add(thumbnail);
        categoriseList
            .add(category(name: "${mname}", image: "${thumbnail}", id: 0));
      }
    } else {
      throw Exception("Failed to get Restaurants");
    }
  }

  Future<void> HotelList(context, value) async {
    Map mapResponse;
    print("in");
    print(value['masterCategorySno']);
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/get_more_suggestion_entity/?masterCategorySno=${value['masterCategorySno']}'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      print("---------------------------------------------------");
      print(mapResponse["data"]);
      print("<<<<<<>category hotels>??????");
      if (mapResponse["data"] != null) {
        print(">>>>>>>>>>>if condition category hotels<<<<<<<<<<");
        setState(() {
          Hotel = mapResponse["data"];
        });
      } else {
        print("else condition category hotels");
        setState(() {
          Hotel = [];
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MasterCategory(
              hotelList: Hotel,
              entityDetals: value,
              headerName: value['masterCategoryName'],
              // headerImage: value['media'][0]['mediaUrl'],
            ),
          ));
    } else {
      throw Exception("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.14,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: datain.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                // Provider.of<DataClass>(context, listen: false).categoryImageTittle(
                //     datain[index]['masterCategoryName'],dname[index] );
                HotelList(context, datain[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.18,
                        decoration: BoxDecoration(
                            //F1D333
                            color: HexaColor('#F1D333'),
                            //border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100)),
                        child: Image.network(
                          '${dname[index]}',
                          //fit: BoxFit.fill,
                          // height: 90,
                          // width: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${datain[index]['masterCategoryName']}",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
