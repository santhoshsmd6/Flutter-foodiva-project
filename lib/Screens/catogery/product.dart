import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Login_module/LoginScreen.dart';
import '../Payment/data_class.dart';
import '../Payment/paymentCheckout .dart';
import 'bodysection.dart';

class foodMenulist {
  final String name;
  final String image;

  foodMenulist({required this.name, required this.image});
}

List<foodMenulist> menulist = [
  foodMenulist(image: "NV1.png", name: "Chicken Button Masala"),
  foodMenulist(image: "NV2.png", name: "Bread Omlet"),
  foodMenulist(image: "NV3.png", name: "Mutton Chukka"),
  foodMenulist(image: "NV4.png", name: "Chicken Kabab"),
  foodMenulist(image: "NV5.png", name: "Brocoli Rice")
];

class Product extends StatefulWidget {
  late String check;
  Product({required this.check});

  @override
  State<Product> createState() => _ProductState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _ProductState extends State<Product> {
  List iii = [];
  List jjj = [];
  List jjk = [];

  Future<void> FoodList() async {
    var kk;
    var tt = 6;

    final response = await http.get(
      Uri.parse(
          'http://192.168.0.149:8084/api/get_entity_product?skip=0&limit=5&entitySno=${widget.check}'),
    );
    if (response.statusCode == 200) {
      final vv = json.decode(response.body);
      kk = json.decode(response.body);
      iii = vv["data"];
      print(iii.length);
      setState(() {
        iii = vv["data"];
      });
      for (var t = 0; t < iii.length; t++) {
        var uuu = iii[t]['prodcutList'];
        var iui = uuu['data'][0];
        var hin = iui['productName'];
        var nih = iui['sellingPrice'].toString();
        print(hin);
        print(nih);
        jjj.add(hin);
        jjk.add(nih);
      }
      print(jjj[0]);
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    FoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fetch Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: ListView(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextButton.icon(
                        onPressed: () {
                          // Navigator.pop(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => nearby()),
                          // );
                        },
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Back',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    child: Text(
                      'name',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                height: 700,
                child: ListView.builder(
                    itemCount: iii.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          height: 170,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                width: 100,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // width: 100,
                                child: Image.asset(
                                  'assets/images/${menulist[index].image}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 36,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(color: Colors.red)),
                                      child: Text(
                                        "${jjj[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      height: 36,
                                      width: 150,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(color: Colors.red)),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 36,
                                            // decoration: BoxDecoration(
                                            //     border: Border.all(color: Colors.red)),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              height: 36,
                                              alignment: Alignment.center,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(color: Colors.red)),
                                              child: Text(
                                                '4.5',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 40, top: 9),
                                            child: Container(
                                              height: 36,
                                              alignment: Alignment.topRight,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(color: Colors.red)),
                                              child: Text(
                                                '45Min',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 36,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(color: Colors.red)),
                                      child: Text(
                                        '\u{20B9} ${jjk[index]}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Consumer<DataClass>(
                                        builder: (context, data, child) {
                                      return ((data.count[index] == 0)
                                          ? Container(
                                              child: ElevatedButton(
                                                child: Text('Add'),
                                                onPressed: () {
                                                  setState(() {
                                                    data.getLoginRes.length != 0
                                                        ? context
                                                            .read<DataClass>()
                                                            .incrementX(
                                                                iii[index],
                                                                index)
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginScreen()));
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          HexaColor("#0E6202")),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              child: Row(children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      Provider.of<DataClass>(
                                                              context,
                                                              listen: false)
                                                          .decrementX(
                                                              iii[index],
                                                              index);
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: Colors.green,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFF716f72),
                                                            width: 1)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Consumer<DataClass>(builder:
                                                    (context, data, child) {
                                                  return Text(
                                                    '${data.count[index]}',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                  );
                                                }),
                                                // Text('$_count'),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                GestureDetector(
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFF716f72),
                                                            width: 1)),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      context
                                                          .read<DataClass>()
                                                          .incrementX(
                                                              iii[index],
                                                              index);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CheckOutP(
                                                                    productValue:
                                                                        iii[
                                                                            index],
                                                                    productIndex:
                                                                        index)));
                                                  },
                                                  child: Text('Place Order'),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                HexaColor(
                                                                    "#0E6202")),
                                                  ),
                                                )
                                              ]),
                                            ));
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
              // Padding(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: Container(
              //     // width: double.infinity,
              //     height: 580,
              //     child: Container(child: Text("ssss")),
              //   ),
              // )
            ],
          ),
        ));
  }
}
