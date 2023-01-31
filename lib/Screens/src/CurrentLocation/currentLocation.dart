import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentLocation extends StatefulWidget {
  final Widget child;

  const CurrentLocation({Key? key, required this.child}) : super(key: key);

  static _CurrentLocationState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MapInheritedWidget>()!
        .data;
  }

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String _Address = 'Your Location';
  // bool getAddress = false;

  String get Address => _Address;

  void initState() {
    super.initState();
    GetAddressFromLatLong();
    // getAddress=true;
    _loadAddress();
  }

  _loadAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      // getAddress=false;
      _Address = (pref.getString('address') )!;
    });
  }

  GetAddressFromLatLong() async {
    // print("<<<----Tesing Address value --->>>"+_Address);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() async {
      // getAddress = true;
      Position position = await _determinePosition();
// setState(() async {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      _Address =
      '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      // print("<<<----Tesing Address value --->>>"+_Address);
      // setState(() {});
      pref.setString('address', _Address);
      while(_Address=='Your Location')
      {
        print("<<<----Tesing Address value --->>>"+_Address);
        Container (
          height: MediaQuery.of(context).size.height * 0.95,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      print("<<<----Tesing Address value while --->>>"+_Address);

    });
//     setState((){
// getAddress=false;
//     });
    // return Address;
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
    // setState(() {});

    return position;
  }

  // void location() async {
  //   setState(() {});
  //   //Position position = await _determinePosition();
  //   _Address = GetAddressFromLatLong() as String;
  // }

  @override
  Widget build(BuildContext context) {
    return MapInheritedWidget(
      data: this,
      child: widget.child,
    );
  }


}

class MapInheritedWidget extends InheritedWidget {
  final _CurrentLocationState data;

  MapInheritedWidget({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class MyContainer extends StatelessWidget {
  final Widget child;

  MyContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  void onPressed(BuildContext context) async {
    // Position position= CurrentLocation.of(context)._determinePosition() ;
    CurrentLocation.of(context).GetAddressFromLatLong();
  }

  // void location () async{
  //   Position position = await _determinePosition();
  //   _Address= GetAddressFromLatLong(position) as String;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(context);
      },
      child: child,
    );
  }
}

class LocationAddress extends StatefulWidget {
  // LocationAddress(TextStyle textStyle);

  @override
  State<StatefulWidget> createState() {
    return LocationAddressState();
  }
}

class LocationAddressState extends State<LocationAddress> {
  late String Address;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _CurrentLocationState data = CurrentLocation.of(context);
    Address = data.Address;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$Address',
      style: TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    );
  }
}