import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_class.dart';

class AddItem extends StatelessWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfefcff),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    // Provider.of<DataClass>(context, listen: false).decrementX();
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.remove,
                      color: Colors.green,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF716f72), width: 1)),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                // Consumer<DataClass>(builder: (context, data, child) {
                //   return Text(
                //     '${data.x}',
                //     style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.green),
                //   );
                // }),
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
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF716f72), width: 1)),
                  ),
                  onTap: () {
                    // context.read<DataClass>().incrementX();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Container(
// height: 40,
// //width: 200,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.green),
// child: Row(
// children: [
// GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => CheckOutP()));
// },
// child: Text(
// "${context.read<DataClass>().price}",
// style: TextStyle(fontSize: 20, color: Colors.white),
// ))
// ],
// ),
// ),
