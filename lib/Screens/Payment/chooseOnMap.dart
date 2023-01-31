import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mr_food1/Screens/map/map_Screen.dart';
import '../map/pinned_Address.dart';

class ChooseOnMap extends StatefulWidget {
  const ChooseOnMap({Key? key}) : super(key: key);

  @override
  State<ChooseOnMap> createState() => _ChooseOnMapState();
}

class _ChooseOnMapState extends State<ChooseOnMap> {
  final StreamController<bool> thisStreamWillEmitEvents = StreamController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      MapView(/*isAddressAutoComplete:  thisStreamWillEmitEvents.stream */),
      PinIcon(),
      Align(
        alignment: Alignment.bottomLeft,
        child: TextButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PaymentCheckout()));
            },
            child: Text(
              'Back',
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
      ),

      //     TextButton(onPressed: (){
      //       thisStreamWillEmitEvents.add(true);
      //   setState((){
      //     // currentAddressBool=true;
      //     print('<<<<<<<<<<<<<<<<<---------currentAddressBool-----');
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ChooseOnMap()));
      //
      //   });
      //   // CurrentAddressText();
      // },
      // child: Text('Choose on Map')),
      // AddressAutoComplete()
    ]));
  }
}
