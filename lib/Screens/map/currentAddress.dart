import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Payment/data_class.dart';
import 'address.dart';
import 'appData.dart';

class CurrentAddressText extends StatefulWidget {
  @override
  State<CurrentAddressText> createState() => _CurrentAddressText();
}

class _CurrentAddressText extends State<CurrentAddressText>
    with TickerProviderStateMixin {
  late GoogleMapController mapController;
  late Position _currentPosition;
  late String placeAddress;

  @override
  void initState() {
    // super.initState();
    print('<<<<<<<<<<<<-------------------1--------------------------');

    getCurrentLocation(false);
  }

  getCurrentLocation(isAnimateToCurrentPosition) async {
    print('<<<<<<<<<<<<-------------------2--------------------------');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // setState(() async {
      // Store the position in the variable
      _currentPosition = position;
      // Provider.of<DataClass>(context, listen: false).position(position);

      print('<<<<<<<<<<<<<-----------------CURRENT POS: $_currentPosition');

      // For moving the camera to current location
      if (isAnimateToCurrentPosition) {
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      }
      // });
      // Places are retrieved using the coordinates
      List<Placemark> p =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Taking the most probable result
      print(p);
      Placemark place = p[0];

      // setState(() {
      // Structuring the address
      placeAddress =
          "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      print(
          '<<<<<<<<<<<<<<<<<<<<<------------------2----------------->>>>>>>>>>>>>');

      // startAddressController.text=placeAddress;
      CurrentAddress currentAddress = CurrentAddress();
      print(
          '<<<<<<<<<<<<<<<<<<<<<------------------3---------------->>>>>>>>>>>>>');

      // userPickUpAddress.latitude= position.latitude;
      // userPickUpAddress.longitute=position.longitude;
      currentAddress.currentAddress = placeAddress;
      print('<<<<<<<<<<<<---------current------->>>>>>>>>>>>$placeAddress');

      // print('<<<<<<<<<<<<---------current------->>>>>>>>>>>>${CurrentAddress().currentAddress}.');
      Provider.of<AppData>(context, listen: false)
          .updateCurrentLocationAddress(currentAddress);

// await getAddress();
    });
    //     .catchError((e) {
    //   print(
    //       '<<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>>>>' + e);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    String currentAddressString;
// double a;
//     double b;

    if (appData.currentAddressString != null) {
      currentAddressString =
          appData.currentAddressString!.currentAddress.toString();
    } else {
      currentAddressString = 'Your Location';
    }

    return Text(
      currentAddressString,
      overflow: TextOverflow.ellipsis,
    );
  }
}
