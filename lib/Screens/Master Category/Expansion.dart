import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Login_module/LoginScreen.dart';
import '../Payment/data_class.dart';
import '../Payment/paymentCheckout .dart';

class Dropdown extends StatefulWidget {
  late int check;
  late String checks;

  Dropdown({required this.check, required this.checks});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  Color HexaColor(String strcolor, {int opacity = 15}) {
    //opacity is optional value
    strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
    String stropacity =
        opacity.toRadixString(16); //convert integer opacity to Hex String
    return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
    //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
  }

  var catname;
  List datain = [];
  List catName = [];
  List catCount = [];

  List fullPoduct = [];
  List categoryList = [];
  List productName = [];
  List productCount = [];
  List productPrice = [];
  int selected = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("${widget.checks}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    )),
                background: Row(
                  children: <Widget>[
                    Spacer(),
                    CircleAvatar(
                      radius: 55.0,
                      backgroundImage: NetworkImage(
                        "https://placeimg.com/640/480/animals",
                      ),
                    ),
                    Spacer(),
                  ],
                )),
            expandedHeight: 230,
            backgroundColor: Colors.grey[200],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              tooltip: 'Menu',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: searchpage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: Key('builder ${selected.toString()}'),
                  itemCount: catName.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        ExpansionTile(
                            textColor: Colors.black,
                            iconColor: Colors.black,
                            collapsedIconColor: Colors.black,
                            key: Key(index.toString()),
                            //attention
                            initiallyExpanded: index == selected,
                            title: Row(
                              children: [
                                Text(
                                  "${catName[index]}",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: 10,
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
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 5, right: 5),
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    )),
                                                width: 103,
                                                child: Image.asset(
                                                  'assets/images/NV1.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, bottom: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${categoryList[index]['productName']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8),
                                                            child: Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.yellow,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    top: 8),
                                                            child: Container(
                                                              child: Text(
                                                                '4.5',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 8),
                                                            child: Container(
                                                              child: Text(
                                                                '45Min',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5, top: 8),
                                                      child: Text(
                                                        '\u{20B9}  ${categoryList[index]['sellingPrice']}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Consumer<DataClass>(builder:
                                                        (context, data, child) {
                                                      return ((data.count[
                                                                  index] ==
                                                              0)
                                                          ? Container(
                                                              child:
                                                                  ElevatedButton(
                                                                child:
                                                                    Text('Add'),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    data.getLoginRes.length !=
                                                                            0
                                                                        ? context.read<DataClass>().incrementX(
                                                                            categoryList[
                                                                                index],
                                                                            index)
                                                                        : Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => LoginScreen()));
                                                                  });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                          Color>(
                                                                      HexaColor(
                                                                          "#0E6202")),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              child: Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          Provider.of<DataClass>(context, listen: false).decrementX(
                                                                              categoryList[index],
                                                                              index);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border: Border.all(color: Color(0xFF716f72), width: 1)),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Consumer<DataClass>(builder:
                                                                        (context,
                                                                            data,
                                                                            child) {
                                                                      return Text(
                                                                        '${data.count[index]}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
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
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border: Border.all(color: Color(0xFF716f72), width: 1)),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          context.read<DataClass>().incrementX(
                                                                              categoryList[index],
                                                                              index);
                                                                        });
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => CheckOutP(productValue: fullPoduct[index], productIndex: index)));
                                                                      },
                                                                      child: Text(
                                                                          'Place Order'),
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(HexaColor("#0E6202")),
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ));
                                                    })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                            onExpansionChanged: ((newState) {
                              if (newState)
                                setState(() {
                                  Duration(seconds: 20000);
                                  selected = index;
                                });
                              else
                                setState(() {
                                  selected = -1;
                                });
                            }))
                      ],
                    );
                  }),
              childCount: catName.length,
            ),
          )
        ],
      ),
    ));
  }
}

class searchpage extends StatefulWidget {

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  TextEditingController controller = new TextEditingController();
   List searchList = [];

  Future<void> SearchList(String value) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.161:8084/api/search_entity_and_product'),
    );
    if (response.statusCode == 200) {
      final List = json.decode(response.body);
      print(">>>>>>>>>>>>>>>>>>>>>>>Nanba");
      print(searchList);
         setState(() {
        searchList = List["data"];
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.arrow_back),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
                controller: controller,
               onChanged: (value) {
                 SearchList(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class reslist extends StatefulWidget {
//   const reslist({Key? key}) : super(key: key);
//
//   @override
//   State<reslist> createState() => _reslistState();
// }
//
// class _reslistState extends State<reslist> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(15),
//         child: Container(
//           height: MediaQuery.of(context).size.height / 12,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(16)),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 5),
//             child: Row(
//             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//             Text('Anjappar Chettinad',
//             // '${widget.checks}',
//             style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold),),
//             ],
//             ),
//             ),
//             Padding(padding: const EdgeInsets.only(left: 10),
//             child: Row(
//             children: [
//             Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Container(
//             child: Row(
//             children: [
//             Icon(
//             Icons.star,
//             color: Colors.yellow,
//             size: 20,
//             ),
//             SizedBox(
//             width: 3,
//             ),
//             Text(
//             "3.1",
//             style: TextStyle(
//             color: Colors.redAccent),
//             ),
//             ],
//             ),
//             ),
//             ),
//             Padding(
//             padding: const EdgeInsets.only(
//             left: 15, top: 10),
//             child: Text("45 min"),
//             )
//             ],
//             ),
//             ),
//             ],
//             ),
//             )
//             );
//   }
// }
