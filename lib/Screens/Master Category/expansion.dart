import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Login_module/LoginScreen.dart';
import '../Payment/data_class.dart';
import '../Payment/paymentCheckout .dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class Expansion extends StatefulWidget {
  late int check;
  late String checks;

  Expansion({required this.check, required this.checks});

  @override
  State<Expansion> createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> {
  var catname;
  List datain = [];
  List catName = [];
  List catCount = [];

  List fullPoduct = [];
  List categoryList = [];
  List productName = [];
  List productCount = [];
  List productPrice = [];

  Future<void> manuList() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/get_entity_product?skip=0&limit=5&entitySno=${widget.check}'),
    );
    if (response.statusCode == 200) {
      final ManuList = json.decode(response.body);
      datain = ManuList["data"];
      print(datain.length);
      setState(() {
        datain = ManuList["data"];
      });
      for (var t = 0; t < datain.length; t++) {
        var uuu = datain[t]['categoryName'];
        var productCount = datain[t]['productCount']['productCount'];
        catName.add(uuu);
        catCount.add(productCount);
      }
      print("<<<<<<<<<<<<OFFICE>>>>>>>>>>>>>");
      print(catName.length);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> FoodList() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/get_entity_product?skip=0&limit=5&entitySno=${widget.check}'),
    );
    if (response.statusCode == 200) {
      final ProductList = json.decode(response.body);
      fullPoduct = ProductList["data"];
      print("___________________waterbottle");
      print(fullPoduct);
      print(fullPoduct[0]['prodcutList']['data'].length);
      setState(() {
        fullPoduct = ProductList["data"];
      });
      for (var t = 0; t < fullPoduct.length; t++) {
        var products = fullPoduct[t]['prodcutList'];
        print("<<<<<<<<<<<<SANDHIYA>>>>>>>>>>>>");
        print(fullPoduct[t]['prodcutList']['data']);
        categoryList = fullPoduct[t]['prodcutList']['data'];
        print(categoryList[1]['productName']['data']);
        var dish = products['data'][0];
        var hin = dish['productName'];
        var nih = dish['sellingPrice'].toString();
        print(hin);
        print(nih);
        productName.add(hin);
        productPrice.add(nih);
      }
      print(">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<Checked");
      print(productName);
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    manuList();
    FoodList();
    super.initState();
  }

  Color HexaColor(String strcolor, {int opacity = 15}) {
    strcolor = strcolor.replaceAll("#", "");
    String stropacity = opacity.toRadixString(16);
    return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Expanded(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 4.5,
                    decoration: BoxDecoration(
                        color: HexaColor('#F3F3F3'),
                        //border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              alignment: Alignment.centerRight,
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: (BoxDecoration(
                                color: HexaColor('#F3F3F3'),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              )),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/search.png'),
                                      fit: BoxFit.contain,
                                      width: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: const TextField(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Outfit-Regular",
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${widget.checks}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "3.1",
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10),
                                        child: Text("45 min"),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: catName.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                textColor: Colors.black,
                                iconColor: Colors.black,
                                collapsedIconColor: Colors.black,
                                key: Key(index.toString()),
                                initiallyExpanded: true,
                                title: Row(
                                  children: [
                                    Text(
                                      "${catName[index]}",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${catCount[index]}Items",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  SingleChildScrollView(
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: categoryList.length,
                                        itemBuilder: (_, index) {
                                          return Column(
                                            children: [
                                              // Text('${categoryList[index]['productName']}'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                          )),
                                                      width: 103,
                                                      child: Image.asset(
                                                        'assets/images/NV1.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${categoryList[index]['productName']}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              // Text("${productCount[index]}")
                                                            ],
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8),
                                                                  child: Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .yellow,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      top: 8),
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      '4.5',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      top: 8),
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      '45Min',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    top: 8),
                                                            child: Text(
                                                              '\u{20B9}  ${categoryList[index]['sellingPrice']}',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Consumer<DataClass>(
                                                              builder: (context,
                                                                  data, child) {
                                                            return ((data.count[
                                                                        index] ==
                                                                    0)
                                                                ? Container(
                                                                    child:
                                                                        ElevatedButton(
                                                                      child: Text(
                                                                          'Add'),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          data.getLoginRes.length != 0
                                                                              ? context.read<DataClass>().incrementX(fullPoduct[index], index)
                                                                              : Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                                                        });
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(HexaColor("#0E6202")),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    child: Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                Provider.of<DataClass>(context, listen: false).decrementX(fullPoduct[index], index);
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 25,
                                                                              height: 25,
                                                                              child: Icon(
                                                                                Icons.remove,
                                                                                color: Colors.green,
                                                                              ),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFF716f72), width: 1)),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Consumer<DataClass>(builder: (context,
                                                                              data,
                                                                              child) {
                                                                            return Text(
                                                                              '${data.count[index]}',
                                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                                                                            );
                                                                          }),
                                                                          // Text('$_count'),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          GestureDetector(
                                                                            child:
                                                                                Container(
                                                                              width: 25,
                                                                              height: 25,
                                                                              child: Icon(
                                                                                Icons.add,
                                                                                color: Colors.green,
                                                                              ),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFF716f72), width: 1)),
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                context.read<DataClass>().incrementX(fullPoduct[index], index);
                                                                              });
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOutP(productValue: fullPoduct[index], productIndex: index)));
                                                                            },
                                                                            child:
                                                                                Text('Place Order'),
                                                                            style:
                                                                                ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all<Color>(HexaColor("#0E6202")),
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
                                                // ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              ))
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomNavigationBar() {
    return Consumer<DataClass>(builder: (context, data, child) {
      return data.orderCount != 0
          ? Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => CheckOutP(productValue: fullPoduct[index], productIndex: index)));
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '${data.orderCount} Item',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  '\u{20B9} ${data.totalCost}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    color: HexaColor('#0E6202'),
                                    child: Text(
                                      'Place Order',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HexaColor("#0E6202")),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                // side: BorderSide(color: Colors.red),
                              ),
                            ),
                          )
                          //   primary: HexaColor('#0E6202'),
                          ),
                    ),
                  ],
                ),
              ),
            )
          : Text("");
    });
  }
}
