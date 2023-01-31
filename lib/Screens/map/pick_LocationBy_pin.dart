import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_food1/Screens/map/pinned_Address.dart';

import 'appData.dart';
import 'map_Methods.dart';

class PickLocationByPin extends StatefulWidget {
  const PickLocationByPin({Key? key}) : super(key: key);

  @override
  State<PickLocationByPin> createState() => _PickLocationByPinState();
}

class _PickLocationByPinState extends State<PickLocationByPin> {
  static LatLng? _initialPosition;
  Position? userCurrentPosition;
  Set<Circle> circlesSet = {};

  // List<Marker> myMarker = [];
  late LatLng onCameraMoveEndLatLng;
  bool isPinMarkerVisible = true;
  Uint8List pickUpMarker = Uint8List.fromList([]);
  String userPickUpMarker = 'Map';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Visibility(
            visible: isPinMarkerVisible,
            child: Image.memory(
              pickUpMarker,
              height: 40,
              width: 40,
              alignment: Alignment.center,
              frameBuilder: (context, child, fame, wasSynchronouslyLoaded) {
                return Transform.translate(
                  offset: Offset(0, -15),
                  child: child,
                );
              },
            )),
      ),

      // body:
      // _initialPosition == null
      //     ? Center(child: Text('Loading map.....'))
      //     :
      //   body: Center(
      //       child: Stack(alignment: Alignment.center, children: [
      //         Stack(
      //           children: [
      //             Visibility(
      //                 visible: isPinMarkerVisible,
      //                 child: Image.memory(
      //                   pickUpMarker,
      //                   height: 40,
      //                   width: 40,
      //                   alignment: Alignment.center,
      //                   frameBuilder: (context, child, fame, wasSynchronouslyLoaded) {
      //                     return Transform.translate(
      //                       offset: Offset(0, -15),
      //                       child: child,
      //                     );
      //                   },
      //                 )),
      PinnedAddressContainer(child: PinnedAddress())
      // Positioned(
      //        bottom: 0.0,
      //        left: 0,
      //        right: 0,
      //        child:
      //        Container(
      //          decoration: BoxDecoration(
      //              borderRadius: BorderRadius.circular(8), color: Colors.black12),
      //          height: 130,
      //          child: Padding(
      //              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      //              child: Column(
      //                children: [
      //                  PinnedAddressContainer(child: PinnedAddress(),),
      //                  const SizedBox(
      //                    height: 4,
      //                  ),
      //                  TextButton(
      //                    onPressed: () async {
      //                      pickUpMarker = await MapMethods.getMarker(
      //                          userPickUpMarker, context);
      //                      setState(() {
      //                        isPinMarkerVisible = true;
      //                      });
      //                    },
      //                    child: const Text('pick location',style: TextStyle(color: Colors.black),),
      //                  )
      //                ],
      //              )),
      //        )
      //    )
      //   ],
      // )
    ]
        //     )

        // ],
        );
  }
}
