import 'package:flutter/material.dart';


class rebutton extends StatefulWidget {
  const rebutton({Key? key}) : super(key: key);

  @override
  State<rebutton> createState() => _rebuttonState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _rebuttonState extends State<rebutton> {
  int _count = 0;
  bool isshow = true;

  void _decrementCount() {
    if (_count < 1) {
      return;
    }
    setState(() {
      _count--;
    });
  }

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: isshow
            ? Row(
                children: [
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      setState(() {
                        isshow = !isshow;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          HexaColor("#0E6202")),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    height: 30,
                    width: 50,
                    // child: FloatingActionButton(
                    //   child: Icon(
                    //     Icons.remove,
                    //     color: HexaColor("#0E6202"),
                    //   ),
                    //   backgroundColor: Colors.white,
                    //   onPressed: _decrementCount,
                    // ),
                    child: RaisedButton(
                      child: Icon(
                        Icons.remove,
                        color: HexaColor("#0E6202"),
                      ),
                      onPressed: _decrementCount,
                      color: HexaColor("#fdfcfa"),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${_count}",
                    style: TextStyle(
                      fontSize: 18,
                      color: HexaColor("#0E6202"),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .01,
                  ),
                  Container(
                    height: 30,
                    width: 50,
                    child: RaisedButton(
                      child: Icon(
                        Icons.add,
                        color: HexaColor("#0E6202"),
                      ),
                      onPressed: _incrementCount,
                      color: HexaColor("#fdfcfa"),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexaColor("#0E6202")),
                      ),
                      child: Text(
                        'Reorder',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 11.0),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
