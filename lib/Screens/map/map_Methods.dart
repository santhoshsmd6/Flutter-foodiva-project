import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'address.dart';
import 'appData.dart';

class MapMethods {
  static Future<Uint8List> getMarker(String fileName, context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/Map.png");
    return byteData.buffer.asUint8List();
  }

  static Future<String> pickOriginPositionOnMap(
      LatLng position, context) async {
    // try {
    String placeAddress = '';
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

    Address userPickUpAddress = Address();
    userPickUpAddress.latitude = position.latitude;
    userPickUpAddress.longitute = position.longitude;
    userPickUpAddress.placeName = placeAddress;
    Provider.of<AppData>(context, listen: false)
        .updatePickUpLocationAddress(userPickUpAddress);
    return placeAddress;

    // Update the text of the TextField
    // startAddressController.text = placeAddress;
    //
    // // Setting the user's present location as the starting address
    // _startAddress = _currentAddress;
    // });
    // } catch (e) {
    //   print(e);
    // }
  }

  static Future<bool> checkIfLocationPermissionEnabled() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location disabled');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Again location denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('location denied permanently');
    }
    return serviceEnabled;
  }

  static Future<LatLng> pickLocationOnMap(
      CameraPosition _onCameraMovePosition, context) async {
    LatLng onCameraMoveLatLng = _onCameraMovePosition.target;
    // Circle pinCircle = Circle(
    //     circleId: CircleId('0'),
    //     radius: 1,
    //     zIndex: 1,
    //     strokeColor: Colors.red,
    //     center: onCameraMoveLatLng,
    //     fillColor: Colors.green);
    // circlesSet.add(pinCircle);
    return onCameraMoveLatLng;
  }
}
