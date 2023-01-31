import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  bool isAdded = true;

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
        child: isAdded
            ? Row(
                children: [
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      setState(() {
                        isAdded = !isAdded;
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
                    width: 40,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.remove,
                        color: HexaColor("#0E6202"),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: _decrementCount,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Text(
                    "${_count}",
                    style: TextStyle(
                      fontSize: 18,
                      color: HexaColor("#0E6202"),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    height: 30,
                    width: 40,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        color: HexaColor("#0E6202"),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: _incrementCount,
                    ),
                  ),
                  // SizedBox(
                  //   width: 30,
                  // ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 100,
                              color: Colors.amber,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text('Modal BottomSheet'),
                                    ElevatedButton(
                                      child: const Text('Next'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const Reorder()),
                        // );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexaColor("#0E6202")),
                      ),
                      child: Text(
                        'Place Order',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
