import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:mr_food1/Screens/map/secrets.dart';
import 'package:provider/provider.dart';

class AddressAutoComplete extends StatefulWidget {
  final Map address;
  // final int addressNo;
  const AddressAutoComplete({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  State<AddressAutoComplete> createState() => _AddressAutoCompleteState();
}

class _AddressAutoCompleteState extends State<AddressAutoComplete> {
  final startAddressController = TextEditingController();
  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace = GooglePlace(Secrets.API_KEY);
  final startAddressFocusNode = FocusNode();
  Timer? _debounce;
  late double lon;
  late double lat;
  double? latitude;
  double? longitude;

  Location? location;
  late GoogleMapController mapController;

  void initState() {
    super.initState();
    startAddressController.text = widget.address['addressLine1'];
  }

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

  Future<void> updateAddress(uAddress) async {
    Map updatedAddress;
    print(uAddress.formattedAddress);
    print('<<<<<<<<<<<<<<<---------------->>>>>>>>>>>>>>');
    print(uAddress.geometry?.location?.lat!);
    print(uAddress.geometry?.location?.lng!);

    final response = await http.put(
        Uri.parse('http://192.168.0.149:8083/api/update_address'),
        body: jsonEncode({
          "addressSno": widget.address['addressSno'],
          "addressTypeCd": widget.address['addressTypeCd'],
          "addressLine1": uAddress.formattedAddress,
          "addressLine2": uAddress.formattedAddress,
          "deliveryInstructions": "innovix",
          "latitude": uAddress.geometry?.location?.lat!,
          "longitude": uAddress.geometry?.location?.lng!
        }));
    if (response.statusCode == 200) {
      updatedAddress = json.decode(response.body);
      print(updatedAddress['data'].toString());
      Navigator.pop(context);
    } else {
      print("error");
      throw Exception('Failed to get address.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final appData = Provider.of<AppData>(context);
    //
    // if (appData.pinnedLocationOnMap != null) {
    //   lat = appData.pinnedLocationOnMap!.latitude!.toDouble();
    //   lon = appData.pinnedLocationOnMap!. longitute!.toDouble();
    //
    // } else {
    //   lat = 13.0827;
    //   lon= 80.2707;
    // }
    return MaterialApp(
        home: Scaffold(
            body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (value.isNotEmpty) {
                  //places api
                  autoCompleteSearch(value);
                } else {
                  //clear out the results
                  //clear out the results

                  setState(() {
                    print('<<<<<<<<<<------------setprediction');
                    predictions = [];
                    // startPosition = null;
                  });
                }
              });
              setState(() {
                print(
                    '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<------- setStat-------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                predictions = [];
              });
            },
            // // focusNode: startAddressFocusNode,
            // locationCallback: (String value) {
            //   setState(() {
            //     // _startAddress = value;
            //   });
            // },

            // onChanged: (va),
            controller: startAddressController,
            focusNode: startAddressFocusNode,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.looks_one),
              // suffixIcon: IconButton(
              //     icon: Image.asset('assets/Map.png'),
              //     onPressed: () {
              //       // _getAddress();
              //       // setState(() {
              //       //   startAddressController.text = _currentAddress;
              //       //   _startAddress = _currentAddress;
              //       // });
              //     }),
              label: Text('Start'),
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
              hintText: 'Choose starting point',
            ),
          ),
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
                    final details = await googlePlace.details.get(placeId);
                    if (details != null && details.result != null && mounted) {
                      if (startAddressFocusNode.hasFocus) {
                        setState(() {
                          // startPosition = details.result;
                          print(
                              '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-------predi set 1------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                          print(details.result!.formattedAddress!);
                          startAddressController.text =
                              details.result!.formattedAddress!;
                          updateAddress(details.result);

                          // latitude = details.result!.geometry?.location?.lat!.toDouble()!;
                          // longitude = details.result!.geometry?.location?.lng!.toDouble();
                          // EditAddress().ani
                          location = details.result!.geometry?.location!;
                          startAddressFocusNode.unfocus();

                          predictions = [];
                        });
                      }
                      print(
                          '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-------predi set 2-------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                      print(lat);
                      print(lon);
                      // animateCamera(location!,context);
                      await mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(9.9252, 78.1198),
                            zoom: 18.0,
                          ),
                        ),
                      );
                      // Address searchAddress = Address();
                      // searchAddress.latitude =
                      //     details.result!.geometry?.location?.lat!;
                      // searchAddress.longitute =
                      //     details.result!.geometry?.location?.lng!;
                      // searchAddress.placeName =
                      //     details.result!.formattedAddress!;
                      // Provider.of<AppData>(context, listen: false)
                      //     .updatePickUpLocationAddress(searchAddress);

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
                    // print('<<<<<<<<<<<<<<<<<<<<<<<<<---------------animate camera------------------->>>>>>>>>>>>>>>>>>>>>');
                    //
                    // await mapController!.animateCamera(
                    //   CameraUpdate.newCameraPosition(
                    //     CameraPosition(
                    //       target: LatLng(lat!, lon!),
                    //       zoom: 18.0,
                    //     ),
                    //   ),
                    // );
                  },
                );
              }),
        ],
      ),
    )));
  }
}
