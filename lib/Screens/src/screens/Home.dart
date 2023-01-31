import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_food1/Screens/map/currentAddress.dart';
import 'package:mr_food1/Screens/src/screens/secondScreen.dart';
import 'package:provider/provider.dart';
import '../../HistoryPage/Reorder.dart';
import '../../Login_module/LoginScreen.dart';
import '../../Payment/data_class.dart';
import '../../catogery/bodysection.dart';
import '../../customer/NavBAr.dart';
import '../../customer/ProfileScreen.dart';
import '../../map/address.dart';
import '../../map/appData.dart';
import '../CurrentLocation//Map.dart';
import '../helpers/colors.dart';
import '../widgets/BottomNavigation.dart';
import '../widgets/brands.dart';
import '../widgets/categorise.dart';
import '../widgets/offers.dart';
import '../widgets/popular.dart';
import '../widgets/toppics.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MisterFood',
      home: BottomNavBar(
          // skipId: skipDeviceId,
          // skipOut: skipResponse,
          ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  late String placeAddress;
  void initState() {
    getCurrentLocation(false);
  }

  getCurrentLocation(isAnimateToCurrentPosition) async {
    print('<<<<<<<<<<<<-------------------2--------------------------');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // setState(() async {
      // Store the position in the variable
      setState(() {
        _currentPosition = position;
      });
      // Provider.of<DataClass>(context, listen: false).position(position);

      print('<<<<<<<<<<<<<-----------------CURRENT POS: $_currentPosition');

      // For moving the camera to current location
      // if (isAnimateToCurrentPosition) {
      //   await mapController.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //         target: LatLng(position.latitude, position.longitude),
      //         zoom: 18.0,
      //       ),
      //     ),
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppData(),
        child: Scaffold(
          backgroundColor: white,
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    height: 35,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 33,
                            //width: 350,
                            decoration: (BoxDecoration(
                                color: HexaColor("#ECE9EC"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen()),
                                    );
                                  },
                                  child: Image(
                                    image: AssetImage('assets/images/Map.png'),
                                    fit: BoxFit.contain,
                                    height: 100,
                                    width: 23,
                                  ),
                                ),
                                Container(
                                    width: 265,
                                    // height: 28,
                                    child: CurrentAddressText()),
                              ],
                            ),
                          ),
                          Consumer<DataClass>(builder: (context, data, child) {
                            return data.getLoginRes.length != 0
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                                LoginRespnce: data.getLoginRes,
                                                Deviceid: data.identifier)),
                                      );
                                    },
                                    child: Container(
                                      height: 75,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.black),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/profile.jpeg'),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    child: Container(
                                        height: 25,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexaColor("#0E6202")),
                                        child: Center(
                                            child: Text(
                                          "login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                  );
                          }),
                        ]),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: HexaColor("#0E6202"),
                              fontFamily: 'OutfitBold'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Are you Hungry!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: (BoxDecoration(
                      color: HexaColor("#ECE9EC"),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      //border: Border.all(color: black)
                    )),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            child: const Image(
                              image: AssetImage('assets/images/search.png'),
                              fit: BoxFit.contain,
                              width: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 3),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: const TextField(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Outfit-Regular",
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search for foods here',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Outfit-Regular")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Categorise',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HexaColor("#0E6202"),
                            fontFamily: 'OutFitBold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                categorise(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Text(
                      'Offers for you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HexaColor("#0E6202"),
                        fontFamily: 'OutFitBold',
                      ),
                    ),
                  ),
                ),
                Advertisement(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Popular Cusines',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HexaColor("#0E6202"),
                        fontFamily: 'OutFitBold',
                      ),
                    ),
                  ),
                ),
                CusineScreen(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Top picks For You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HexaColor("#0E6202"),
                        fontFamily: 'OutFitBold',
                      ),
                    ),
                  ),
                ),
                toppics(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Popular Brands',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HexaColor("#0E6202"),
                        fontFamily: 'OutFitBold',
                      ),
                    ),
                  ),
                ),
                brandScreen(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Nearby Resteaurant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HexaColor("#0E6202"),
                        fontFamily: 'OutFitBold',
                      ),
                    ),
                  ),
                ),
                _currentPosition != ""
                    ? nearby(currentPosition: _currentPosition)
                    : Text("Enable Device Location"),
              ],
            ),
          ),
        ));
  }
}
