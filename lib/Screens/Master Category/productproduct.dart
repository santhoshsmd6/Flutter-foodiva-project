import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mr_food1/Screens/catogery/product.dart';

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

class Products extends StatefulWidget {
  late String check;
  late String checks;

  Products({required this.check, required this.checks});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var catname;
  List datain = [];
  List dname = [];
  List priceing = [];

  Future<void> lo() async {

    final response = await http.get(
      Uri.parse(
          'http://192.168.0.149:8084/api/get_entity_product?skip=0&limit=5&entitySno=${widget.check}'),
    );
    if (response.statusCode == 200) {
      final vv = json.decode(response.body);
      //kk = json.decode(response.body);
      datain = vv["data"];
      print(datain.length);
      setState(() {
        datain = vv["data"];
      });
      for (var t = 0; t < datain.length; t++) {
        var uuu = datain[t]['categoryName'];
        dname.add(uuu);
      }
      print(dname[0]);
      //print(widget.check + "superpaaku");
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    lo();
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
                          Navigator.pop(context);
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
                    //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Text(
                      '${widget.checks}',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                height: 700,
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: dname.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            catname = dname[index];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Product(
                                          check: widget.check,

                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height:100,
                              decoration: BoxDecoration(
                                 color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                       child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${dname[index]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,color:Color(0xFF557B2F)),
                                          ),
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 250),
                                    child: Icon(Icons.arrow_forward_ios,color: Color(0xFF557B2F)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
