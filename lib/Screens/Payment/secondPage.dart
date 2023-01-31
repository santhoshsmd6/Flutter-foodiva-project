import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:provider_test/home_page.dart';

import 'data_class.dart';

class SecondPage extends StatelessWidget {
  final price = 300;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfefcff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                // if (Provider.of<DataClass>(context, listen: false).x <= 0) {
                //   Get.snackbar("Item", "Can not decrease more",
                //       backgroundColor: Colors.black,
                //       colorText: Colors.white,
                //       // titleText: Text(
                //       //   "Item",
                //       //   style: TextStyle(fontSize: 40, color: Colors.white),
                //       // ),
                //       messageText: Text(
                //         "Can not reduce more",
                //         style: TextStyle(fontSize: 20, color: Colors.white),
                //       ));
                // } else {
                //   // Provider.of<DataClass>(context, listen: false).decrementX();
                // }
              },
              child: Container(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.remove,
                  color: Colors.green,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF716f72), width: 1)),
              ),
            ),
            // Consumer<DataClass>(builder: (context, data, child) {
            //   return Text(
            //     '${data.x}',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.green,
            //     ),
            //   );
            // }),
            GestureDetector(
              child: Container(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF716f72), width: 1)),
              ),
              onTap: () {
                // if (context.read<DataClass>().x >= 10) {
                //   Get.snackbar("Item", "Can not more than this",
                //       backgroundColor: Colors.black,
                //       colorText: Colors.white,
                //       titleText: Text(
                //         "Item",
                //         style: TextStyle(fontSize: 40, color: Colors.white),
                //       ),
                //       messageText: Text(
                //         "Can not be more than this",
                //         style: TextStyle(fontSize: 20, color: Colors.white),
                //       ));
                // } else {
                //   // context.read<DataClass>().incrementX();
                // }
              },
            ),
            Spacer(),
            // Consumer<DataClass>(builder: (context, data, child) {
            //   return Text(
            //     '${(data.x) * price}',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.green,
            //     ),
            //   );
            // }),
            Container(
              height: 40,
              // width: 190,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.green),
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          // Get.to(() => AddItem(),
                          // transition: Transition.upToDown,
                          // duration: Duration(seconds: 1));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            "Previous page",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.skip_previous, color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
