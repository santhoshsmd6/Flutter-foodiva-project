import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Payment/data_class.dart';
import 'Expansion.dart';

class FirstScreen extends StatefulWidget {
  final List hotel;
  FirstScreen({required this.hotel});
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  var entino;
  var entiname;
  String? ans;
  var supe;
  var hum;

  @override
  Widget build(BuildContext context) {
    print("_________________________Paithiyam ");
    print(widget.hotel);
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.hotel.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Dropdown(
                                check: widget.hotel[index]['entitySno'],
                                checks: widget.hotel[index]['entityName'],
                              )));
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/NV4.png"),
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
                                "${widget.hotel[index]['entityName']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 15),
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
                                padding:
                                    const EdgeInsets.only(top: 10, left: 15),
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: widget.hotel.length,
        //     itemBuilder: (_, index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        //         child: GestureDetector(
        //           onTap: () {
        //             // print(widget.hotel[index]['entityName']);
        //             // entino = widget.hotel[index]['entitySno'];
        //             // entiname = widget.hotel[index]['entityName'];
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (BuildContext context) => Expansion(
        //                           check: widget.hotel[index]['entitySno'],
        //                           checks: widget.hotel[index]['entityName'],
        //                         )));
        //           },
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 border: Border.all(
        //                   color: Colors.grey.shade300,
        //                 )),
        //             child: Row(
        //               children: <Widget>[
        //                 (widget.hotel[index]['logoMedia'] != null)
        //                     ? Container(
        //                         width: 80,
        //                         child: Image.network(
        //                           '${widget.hotel[index]['logoMedia'][0]['mediaUrl']}',
        //                           //width: 50,
        //                         ),
        //                       )
        //                     : Container(
        //                         width: 80,
        //                         child: Image.asset("assets/images/NV4.png"),
        //                       ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 15, bottom: 30),
        //                   child: Container(
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       children: [
        //                         Text(
        //                           "${widget.hotel[index]['entityName']}",
        //                           style: const TextStyle(
        //                               fontFamily: 'Outfit-Regular.ttf',
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 18),
        //                         ),
        //                         Row(
        //                           children: [
        //                             Padding(
        //                               padding: const EdgeInsets.only(top: 10),
        //                               child: Container(
        //                                 child: Row(
        //                                   children: [
        //                                     Icon(
        //                                       Icons.star,
        //                                       color: Colors.yellow,
        //                                       size: 20,
        //                                     ),
        //                                     Text(
        //                                       "3.1",
        //                                       style: TextStyle(
        //                                           color: Colors.redAccent),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),
        //                             Padding(
        //                               padding:
        //                                   EdgeInsets.only(left: 15, top: 10),
        //                               child: Text("45 min"),
        //                             )
        //                           ],
        //                         ),
        //                         Padding(
        //                           padding: EdgeInsets.only(top: 15),
        //                           child: Text(
        //                             "4140 Parker Rd, Allentown, New Mexico 31134",
        //                             style: TextStyle(fontSize: 12),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     }),
      ),
    );
  }
}
