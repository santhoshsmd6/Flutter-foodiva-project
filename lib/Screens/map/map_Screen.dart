import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mr_food1/Screens/map/pinned_Address.dart';
import 'package:mr_food1/Screens/map/secrets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'dart:math' show cos, sqrt, asin;

import 'address.dart';
import 'appData.dart';
import 'map_Methods.dart';

class MapView extends StatefulWidget {
  //  final Stream<bool>  isAddressAutoComplete ;
  // // final Widget child;
//    bool? isAddressAutoComplete;
// MapView(this.isAddressAutoComplete );
  // MapView( {Key? key,  this.isAddressAutoComplete }) : super(key: key);

  @override
  MapViewState createState() => MapViewState(/*isAddressAutoComplete*/);
}

class MapViewState extends State<MapView> with TickerProviderStateMixin {
  // Future<String> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }
  //  final Stream<bool>  isAddressAutoComplete ;
  // late StreamSubscription _streamSubscription;
  //  bool _closeMe = false;
  //  _MapViewState(this.isAddressAutoComplete);

  @override
  void initState() {
    super.initState();
    super.initState();
    // _streamSubscription = isAddressAutoComplete.listen((shouldClose) { // here we listen for new events coming down the pipe
    //   setState(() {
    //     _closeMe = shouldClose; // we got a new "droplet"
    //   });
    // });
    MapMethods.checkIfLocationPermissionEnabled();
    getCurrentLocation(true);
    print(
        '<<<<<<<<<<<<<<<<<<<<<------------------1----------------->>>>>>>>>>>>>');
    // final appData = Provider.of<AppData>(context);
    // LatLng? currentLatLng;
    // if (appData.pinnedLocationOnMap != null) {
    //   currentLatLng = appData.pinnedLocationOnMap!.currentPosition as LatLng?;
    // }

    // MapMethods.pickOriginPositionOnMap(currentLatLng, context);

    // startAddressController.text = _currentAddress;
    _startAddress = _currentAddress;
    // animateCamera(context);
    // startAddressController.addListener(() {
    //   _onChanged();
    // });
    // _getId().then((id) {
    //   String deviceId = id;
    //   print('<<<<<<<<<<<<<<<<<<<<--------ID---------->>>>>>>>>>>>>>>>>>>>>>>');
    //   print(deviceId);
    // });
  }

  // Initial location of the Map view
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(13.0827, 80.2707), zoom: 13);

  String placeAddress = '';

// For controlling the view of the Map
  late GoogleMapController mapController;

  // For storing the current position
  late Position _currentPosition;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _currentAddress = '';
  String _startAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};
  String _destinationAddress = '';

  // Object for PolylinePoints
  late PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  // String API_KEY = 'AIzaSyCMD9EwNhmUsl4-XWEymhHKDxFYrHlrhzc';

  GooglePlace googlePlace = GooglePlace(Secrets.API_KEY);

  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  DetailsResult? startPosition;
  DetailsResult? endPosition;

  bool isAnimateToCurrentPosition = true;

  LatLng? onCameraMoveEndLatLng;
  Uint8List pickUpMarker = Uint8List.fromList([]);
  bool isPinMarkerVisible = true;

  late double pinLatitude;
  late double pinLongitude;

  Future<void> animateCamera(context) async {
    final appData = Provider.of<AppData>(context);
    double? lat;
    double? lon;
    if (appData.pinnedLocationOnMap != null) {
      lat = appData.pinnedLocationOnMap!.latitude;
      lon = appData.pinnedLocationOnMap!.longitute;
    } else {
      lat = 13.0827;
      lon = 80.2707;
    }
    print(
        '<<<<<<<<<<<<<-------------camera------------->>>>>>>>>>>>>>>>>>>>>>');
    // print(location.latitude!);
    // print(location.longitude!);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat!, lon!),
          zoom: 18.0,
        ),
      ),
    );
    // return true;
  }

// Method for retrieving the current location
  getCurrentLocation(isAnimateToCurrentPosition) async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // setState(() async {
      // Store the position in the variable
      _currentPosition = position;

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

      print(
          '<<<<<<<<<<<<---------current------->>>>>>>>>>>>${CurrentAddress().currentAddress}.');
      Provider.of<AppData>(context, listen: false)
          .updateCurrentLocationAddress(currentAddress);

// await getAddress();
    });
    //     .catchError((e) {
    //   print(
    //       '<<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>>>>' + e);
    // });
  }

  // String _currentAddress = '';
  // String _startAddress = '';
  // String? _placeDistance;

  // Method for retrieving the address

  var uuid = new Uuid();
  late String _sessionToken;
  List<dynamic> _placeList = [];

  // _onChanged() {
  //   if (_sessionToken == null) {
  //     setState(() {
  //       _sessionToken = uuid.v4();
  //     });
  //   }
  //   getSuggestion(startAddressController.text);
  // }
  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lat'];

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 18.0,
        ),
      ),
    );
  }

  // void getSuggestion(String input) async {
  //   String kPLACES_API_KEY = Secrets.API_KEY;
  //   // String type = '(regions)';
  //   String baseURL =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$kPLACES_API_KEY&sessiontoken=1234567890' ;
  //   // String request =
  //   //     '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
  //
  //   // String baseURL =
  //   //     'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //   // String request =
  //   //     '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
  //
  //   var response = await http.get(baseURL as Uri);
  //
  //   // var response= await .
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _placeList = json.decode(response.body)['predictions'];
  //     });
  //   } else {
  //     throw Exception('Failed to load predictions');
  //   }
  // }

  void autoCompleteSearch(String value) async {
    LatLon location = LatLon(20.5937, 78.9629);
    // LatLon location=LatLon(11.1271,78.6569);
    // LatLng location = LatLng(20.5937, 78.9629);
    var result = await googlePlace.autocomplete.get(
      value, /*location: location,strictbounds: truelocation: '${location.latitude},${location.longitude}',*/
    );
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (value.isNotEmpty) {
              //places api
              autoCompleteSearch(value);
            } else {
              //clear out the results
              setState(() {
                predictions = [];
                startPosition = null;
              });
            }
          });
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Set<Marker> markers = {};
  // String _destinationAddress = '';

//   Object for PolylinePoints
//   late PolylinePoints polylinePoints;
//
// List of coordinates to join
//   List<LatLng> polylineCoordinates = [];
//
// Map storing polylines created by connecting two points
//   Map<PolylineId, Polyline> polylines = {};

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    print(
        '<<<<<<<<<<<<<----------_createPolylines----------->>>>>>>>>>>>>>>>>>>>-');

    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Secrets.API_KEY, // Google Maps API Key
      Secrets.API_KEY,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );
    print('<<<<<<<<<<<<<--------------------->>>>>>>>>>>>>>>>>>>>-');
    print(result.points);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  Future<bool> calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      // List<Location>? startPlacemark = await locationFromAddress(_startAddress);
      // List<Location>? destinationPlacemark =
      //     await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.

      // double startLatitude = _startAddress == _currentAddress
      //     ? _currentPosition.latitude
      //     : startPosition!.geometry!.location!.lat!;
      // polylineCoordinates[0].latitude = startLatitude;
      double startLatitude = _currentPosition.latitude;

      // double startLongitude = _startAddress == _currentAddress
      //     ? _currentPosition.longitude
      //     : startPosition!.geometry!.location!.lng!;

      double startLongitude = _currentPosition.longitude;

      double destinationLatitude = pinLatitude;
      // endPosition!.geometry!.location!.lat!;
      double destinationLongitude = pinLongitude;
      // endPosition!.geometry!.location!.lng!;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        // infoWindow: InfoWindow(
        //   title: 'Start $startCoordinatesString',
        //   snippet: _startAddress,
        // ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        // infoWindow: InfoWindow(
        //   title: 'Destination $destinationCoordinatesString',
        //   snippet: _destinationAddress,
        // ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        '<<<<<<<<<<<<<<<---------->>>>>>>START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        '<<<<<<<<<<<<<<<<-------->>>>>>>>DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      //   // startCoordinates.latitude,
      //   // startCoordinates.longitude,
      //   // destinationCoordinates.latitude,
      //   // destinationCoordinates.longitude,
      // );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      // String? _placeDistance;
      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('<<<<<<<<<<<<<<<-----------------DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));

    // double _coordinateDistance(startLatitude,startLongitude, destinationLatitude, destinationLongitude) {
    //   var p = 0.017453292519943295;
    //   var a = 0.5 -
    //       cos((destinationLatitude - startLatitude) * p) / 2 +
    //       cos(startLatitude * p) * cos(destinationLatitude * p) * (1 - cos((destinationLongitude - startLongitude) * p)) / 2;
    //   return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    // var click=Widget.isAddressAutoComplete;
    // void clickedFav() {
    //   setState(() {
    //     click = !click;   //toggling the value received
    //   });
    // }
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
    if (appData.pinnedLocationOnMap != null) {
      pinLatitude = appData.pinnedLocationOnMap!.latitude!.toDouble();
      // pinLatitude=a!;
      pinLongitude = appData.pinnedLocationOnMap!.longitute!.toDouble();
      // pinLongitude=b!;
    }

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              // mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: Set<Marker>.from(markers),
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
// circles: circlesSet,
              onCameraMove: (position) async {
                // print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                onCameraMoveEndLatLng = await position.target;
                //       Circle pinCircle = Circle(
                //     circleId: CircleId('0'),
                //     radius: 1,
                //     zIndex: 1,
                //     strokeColor: Colors.red,
                //     center: onCameraMoveEndLatLng,
                //     fillColor: Colors.green);
                // circlesSet.add(pinCircle);
//                 print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                print(onCameraMoveEndLatLng);
              },

              onCameraIdle: () async {
                await MapMethods.pickOriginPositionOnMap(
                    onCameraMoveEndLatLng!, context);
                print(
                    '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                destinationAddressController.text = PinnedAddress() as String;
              },

              polylines: Set<Polyline>.of(polylines.values),
              // layoutDirection: TextDirection.ltr,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          // Container(
                          //   width: width*0.78,
                          //   height: height*0.055,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //       color: Colors.white,
                          //       border: Border.all(
                          //           color: Colors.black,
                          //           width: 1,
                          //           style: BorderStyle.solid)),
                          //   child: Row(
                          //     children: [
                          //       const SizedBox(
                          //         width: 10,
                          //       ),
                          //       // const Icon(
                          //       //   Icons.my_location,
                          //       //   color: Colors.blue,
                          //       // ),
                          //       // const SizedBox(
                          //       //   width: 10,
                          //       // ),
                          //      CurrentAddressText(),
                          //
                          //     ],
                          //   ),
                          // ),

                          SizedBox(height: 10),
                          // AddressAutoComplete(),
                          Visibility(
                              // visible: _closeMe,
                              child: _textField(
                                  label: 'Destination',
                                  hint: 'Choose destination',
                                  prefixIcon: Icon(Icons.looks_two),
                                  // suffixIcon: IconButton(
                                  //     onPressed: ()async{
                                  //       var place=await LocationService().getPlaceId(destinationAddressController.text);
                                  //       _goToPlace(place);
                                  //     },
                                  //     icon:Icon(Icons.search)),

                                  controller: destinationAddressController,
                                  focusNode: desrinationAddressFocusNode,
                                  width: width,
                                  locationCallback: (String value) {
                                    setState(() {
                                      _destinationAddress = value;
                                    });
                                  })),
                          ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: predictions.length,
                              // itemCount: _placeList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  // leading: CircleAvatar(
                                  //   child: Icon(
                                  //     Icons.pin_drop,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  title: Text(
                                    predictions[index].description.toString(),
                                  ),
                                  // title: Text(_placeList[index]["description"]),
                                  onTap: () async {
                                    final placeId = predictions[index].placeId!;
                                    final details =
                                        await googlePlace.details.get(placeId);
                                    if (details != null &&
                                        details.result != null &&
                                        mounted) {
                                      // if (startAddressFocusNode.hasFocus) {
                                      //   setState(() {
                                      //     startPosition = details.result;
                                      //     print(
                                      //         '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<------formattedaAddress-------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                      //     print(details.result!.formattedAddress!);
                                      //     startAddressController.text =
                                      //     details.result!.formattedAddress!;
                                      //     predictions = [];
                                      //   });
                                      // }
                                      if (desrinationAddressFocusNode
                                          .hasFocus) {
                                        setState(() {
                                          endPosition = details.result;
                                          print(
                                              '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                                          print(endPosition);
                                          destinationAddressController.text =
                                              details.result!.formattedAddress!;
                                          predictions = [];
                                        });
                                      }
                                      startAddressFocusNode.unfocus();
                                      desrinationAddressFocusNode.unfocus();

                                      mapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: LatLng(
                                                endPosition!
                                                    .geometry!.location!.lat!,
                                                endPosition!
                                                    .geometry!.location!.lng!),
                                            zoom: 18.0,
                                          ),
                                        ),
                                      );

                                      // if (startPosition != null && endPosition != null) {
                                      //   print('navigate');
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => MapScreen(
                                      //           startPosition: startPosition,
                                      //           endPosition: endPosition),
                                      //     ),
                                      //   );
                                      // }
                                    }
                                  },
                                );
                              }),

                          SizedBox(height: 10),
                          // Visibility(
                          //   visible: _placeDistance == null ? false : true,
                          //   child: Text(
                          //     'DISTANCE: $_placeDistance km',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // Visibility(child: Text('hjbjn')),
                          // Visibility(
                          //   // visible: _placeDistance == null ? false : true,
                          //   child: Text(
                          //     'DISTANCE: $_placeDistance km',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 5),
                          // ElevatedButton(
                          //   onPressed: (placeAddress != '' )
                          //       ? () async {
                          //     startAddressFocusNode.unfocus();
                          //     desrinationAddressFocusNode.unfocus();
                          //     setState(() {
                          //       if (markers.isNotEmpty) markers.clear();
                          //       if (polylines.isNotEmpty)
                          //         polylines.clear();
                          //       if (polylineCoordinates.isNotEmpty)
                          //         polylineCoordinates.clear();
                          //       _placeDistance = null;
                          //     });
                          //     calculateDistance().then((isCalculated) {
                          //       if (isCalculated) {
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(
                          //           SnackBar(
                          //             content: Text(
                          //                 'Distance Calculated Sucessfully'),
                          //           ),
                          //         );
                          //       } else {
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(
                          //           SnackBar(
                          //             content: Text(
                          //                 'Error Calculating Distance'),
                          //           ),
                          //         );
                          //       }
                          //     });
                          //   }
                          //       : null,
                          //   // color: Colors.red,
                          //   // shape: RoundedRectangleBorder(
                          //   //   borderRadius: BorderRadius.circular(20.0),
                          //   // ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(
                          //       'Show Route'.toUpperCase(),
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 20.0,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey, // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          // CurrentAddressText();
                          //
                          getCurrentLocation(true);
                          print(
                              '<<<<<<<<<<<<-----currentAddressString---------------------$currentAddressString');
                          startAddressController.text = currentAddressString;
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
            //  PinnedAddressContainer(child: PinnedAddress())

            // Expanded(child: Widget.child)
          ],
        ),
      ),
    );
  }
}
