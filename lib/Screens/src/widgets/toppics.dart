import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../models/offer.dart';

List<offer> picslist = [
  offer(image: "bg10.png"),
  offer(image: "bg9.jpg"),
  offer(image: "bg5.jpg"),
];

class toppics extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height/6.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: picslist.length,
        itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/${picslist[index].image}',
                    width: 200.0,
                    //height: 110.0,
                    //fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Container(
// padding: const EdgeInsets.all(4),
// decoration: BoxDecoration(
// color: white,
// ),
// child: Image.asset('assets/images/${picslist[index].image}',width: 250,),),

// ('assets/images/${picslist[index].image}',width: 250,),),