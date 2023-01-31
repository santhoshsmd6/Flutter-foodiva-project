import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
final String image;
final String name;


BottomNavigation({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
          children: <Widget>[
            Image.asset('assets/images/$image',width: 25,height: 25,),
            SizedBox(
              height: 5,
            ),
            Text('$name'),
          ]
      ),
    );
  }
}
