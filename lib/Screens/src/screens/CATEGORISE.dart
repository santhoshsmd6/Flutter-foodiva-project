// import 'package:flutter/material.dart';
// import 'package:mr_food/src/screens/Home.dart';
// import '../helpers/colors.dart';
// import '../models/category.dart';
// import '../swetha/pureveg.dart';
//
// class CATEGORISE extends StatefulWidget {
//   final category Category;
//   CATEGORISE({required this.Category});
//
//   @override
//   State<CATEGORISE> createState() => _CATEGORISEState();
// }
//
// class _CATEGORISEState extends State<CATEGORISE> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       body: SafeArea(
//         child: Padding(
//             padding: const EdgeInsets.only(top: 2),
//             child: ListView(children: <Widget>[
//               //App Bar
//               Container(
//                 height: 120,
//                 decoration: const BoxDecoration(
//                   // border: Border.all(color: Colors.black),
//                     image: DecorationImage(
//                         image: AssetImage("assets/appBarBG.png"),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(45),
//                         topLeft: Radius.circular(5),
//                         bottomRight: Radius.circular(5),
//                         bottomLeft: Radius.circular(45))),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Text(
//                       "${widget.Category.name}",
//                       style: TextStyle(
//                           fontSize: 30.0, height: 1.4, fontWeight: FontWeight.w600),
//                     ),
//                     Container(
//                       //padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
//                       child:
//                       Image.asset('assets/images/${widget.Category.image}',width: 60,),                    ),
//                     // Container(),
//                   ],
//                 ),
//               ),
//
//               //NavBar
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(
//                         context,
//                         MaterialPageRoute(builder: (context) => Home()),);
//                     },
//                     child: Row(
//                       children: [
//                         IconButton(
//                           alignment: Alignment.centerRight,
//                           icon: const Icon(
//                             Icons.arrow_back,
//                             size: 18,
//                           ),
//                           onPressed: () {},
//                         ),
//                         Text(
//                           'Back',
//                           style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 178),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Text(
//                           'sort by',
//                           style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           alignment: Alignment.centerLeft,
//                           icon: const Icon(
//                             Icons.arrow_downward,
//                             size: 18,
//                           ),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               //Menu List
//               PUREVEG(id: widget.Category.id),
//               //NONVEG(id: widget.Category.id),
//             ])),
//       ),
//     );
//   }
// }
//
