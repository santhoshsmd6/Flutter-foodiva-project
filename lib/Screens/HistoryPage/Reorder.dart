import 'package:flutter/material.dart';
import 'listing.dart';

class Reorder extends StatefulWidget {
  final List orders;
  const Reorder({Key? key, required this.orders}) : super(key: key);

  @override
  State<Reorder> createState() => _ReorderState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _ReorderState extends State<Reorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: TextButton.icon(
                    onPressed: () => {Navigator.pop(context)},
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10),
            child: Container(
                child: Text(
              'Order History',
              style: TextStyle(
                  color: HexaColor("#0E6202"),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              // width: double.infinity,
              height: 690,
              child: Container(child: listing(orders: widget.orders)),
            ),
          )
          // Container(
          //   child: listing(),
          // ),
        ],
      ),
    );
  }
}
