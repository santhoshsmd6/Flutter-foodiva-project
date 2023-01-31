import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'coupon.dart';

List<coupon> coupons = [
  coupon(image: 'mcdonalds.png',
      brand: 'McDonald\'s',
      amount: '577',
      validity: 'Valid until 30 September 2022'),
  coupon(image: 'starbucks.png',
      brand: 'starbucks.png',
      amount: '786',
      validity: 'Valid until 31 July 2022'),
  coupon(image: 'pepsi.png',
      brand: 'pepsi.png',
      amount: '254',
      validity: 'Valid until 31 July 2022'),
  coupon(image: 'mcdonalds.png',
      brand: 'McDonald\'s',
      amount: '577',
      validity: 'Valid until 30 September 2022'),

];

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity = opacity.toRadixString(
      16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}
class couponScreen extends StatefulWidget {


  @override
  State<couponScreen> createState() => _couponScreenState();
}

class _couponScreenState extends State<couponScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My couponScreen',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        // leadingWidth: 20,
        // leading:TextButton(
        //   child:
        //   Icon(
        //     Icons.arrow_back,
        //     size: 17,
        //     color: Colors.black,),
        //   onPressed: () {print('Hi');},
        // ),
        leading: GestureDetector(
          onTap: () {
            /* Write listener code here */
          },
          child: ElevatedButton.icon(
              onPressed: () => {
              Navigator.pop(
              context,
         ),
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  )),
              icon: Icon(
                Icons.arrow_back_outlined,
                size: 15,
                color: Colors.black,
              ),
              label: Text(
                'Back',
                style: TextStyle(fontSize: 12, color: Colors.black),
              )),
        ),
        leadingWidth: 80,

        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: ListView.builder(
          itemCount: coupons.length,
          itemBuilder: (_, index) {
            return
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //           // Padding(
                    //           //   padding: const EdgeInsets.only(right: 30),
                    //           //   child: Container(
                    //           //     height: MediaQuery.of(context).size.height * 0.09,
                    //           //     width: MediaQuery.of(context).size.height * 0.09,
                    //           //     decoration:  BoxDecoration(
                    //           //         border: Border.all(color: Colors.blueAccent),
                    //           //         borderRadius: BorderRadius.all(Radius.circular(50))),
                    //           //     // child: const Image(
                    //           //     //   image: AssetImage('assets/logos/user.png'),
                    //           //     //   fit: BoxFit.cover,
                    //           //     //   //alignment: Alignment.bottomRight,
                    //           //     //   height: 10,
                    //           //     //   width: 10,
                    //           //     // ),
                    //           //   ),
                    //           // ),
                    //   CustomPaint(
                    //       painter: paint(),
                    //   size: Size(diameter, diameter),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.16,
                        // width: MediaQuery.of(context).size.height * 0.39,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                            color: HexaColor('#ECE9EC'),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                        child: Row(
                          children: <Widget>[
                             Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Image.asset(
                                ("assets/images/${coupons[index].image}"),
                                    // fit: BoxFit.fill,
                                     height: 65,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: DottedLine(
                                direction: Axis.vertical,
                                // lineLength: double.infinity,
                                lineThickness: 2.0,
                                dashLength: 10.0,
                                dashColor: HexaColor('#D1D1D6'),
                                // dashGradient: [Colors.red, Colors.blue],
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                // dashGapColor: Colors.transparent,
                                // dashGapGradient: [Colors.red, Colors.blue],
                                dashGapRadius: 0.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                   Text(
                                    '${coupons[index].brand}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text('\u{20B9} ',
                                          style: TextStyle(
                                            fontSize: 36,
                                          )),
                                      Text('${coupons[index].amount}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      Text('    ' + 'coupon',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                   Text('${coupons[index].validity}',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}
