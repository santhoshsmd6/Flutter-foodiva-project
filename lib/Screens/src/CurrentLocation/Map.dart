import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


/// This Widget is the main application widget.


class MapScreen extends StatefulWidget {

  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  String Address = 'search';

  // late LatLng currentPostion;
  // void _getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //   setState(() {
  //     currentPostion = LatLng(position.latitude, position.longitude);
  //   });
  // }
  late bool myLocationEnabled;

  late GoogleMapController _googleMapController;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    // target: LatLng(13.0827, 80.2707),
      target: LatLng(12.9667812, 80.0954725),
      zoom: 12);
  Set<Marker> markers = {};

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  // Future<Type> currentLocation() async {
  //
  //   Position position = await _determinePosition();
  //   _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
  //
  //
  //       CameraPosition(
  //           target: LatLng(position.latitude, position.longitude),
  //           zoom: 14)
  //
  //   ));
  //
  //   markers.clear();
  //
  //   markers.add(Marker(
  //       markerId: const MarkerId('Current location'),
  //       position: LatLng(position.latitude, position.longitude)));
  //   setState(() {});
  //
  //
  // }

  // @override
  // void dispose() {
  //   _googleMapController.dispose();
  //   super.dispose();
  // }
  //
  //
  // late LatLng _center ;
  // late Position currentLocation;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getUserLocation();
  // }
  //
  // Future<Position> locateUser() async {
  //   return Geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }
  //
  // getUserLocation() async {
  //   currentLocation = await locateUser();
  //   setState(() {
  //     _center = LatLng(currentLocation.latitude, currentLocation.longitude);
  //   });
  //   print('center $_center');
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(
      //   children: [
      // Text('${Address}'),
      // ElevatedButton(
      //     onPressed: () async {
      //       Position position = await _determinePosition();
      //       // location ='Lat: ${position.latitude} , Long: ${position.longitude}';
      //       GetAddressFromLatLong(position);
      //     },
      //     child: Text('Get Location')),
      body:GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        // initialCameraPosition: _initialCameraPosition,
        initialCameraPosition: _initialCameraPosition,
        markers: markers,
        myLocationEnabled: true,
        // myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) =>
        _googleMapController = controller,
      ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Colors.black,
        onPressed: () async {
          Position position = await _determinePosition();
          // GetAddressFromLatLong(position);
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.clear();

          markers.add(Marker(
              markerId: const MarkerId('Current location'),
              position: LatLng(position.latitude, position.longitude)));
          setState(() {});
        },

        //label: const Text('current'),
        child: const Icon(Icons.center_focus_strong,color: Colors.black,),
        backgroundColor: Colors.white,

      ),
      // child: Icon(Icons.center_focus_strong),
      // ),
    );
  }

  Future<Position> _determinePosition() async {
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
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}