import 'dart:io';
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mr_food1/Screens/Payment/placedOrder.dart';
import 'package:mr_food1/Screens/map/address_Auto_Complete.dart';
import 'package:mr_food1/Screens/map/map_Methods.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import '../catogery/product.dart';
import 'package:mr_food1/Screens/Payment/coupencon.dart';
import '../map/address.dart';
import '../map/appData.dart';
import '../map/currentAddress.dart';
import '../map/pinned_Address.dart';
import 'chooseOnMap.dart';
import 'data_class.dart';

List<couponcon> Couponlist = [
  couponcon(
      image: "mcdonalds.png",
      cname: "McDonalds",
      crate: "50",
      cvalidity: "valid until 31 august 2022"),
  couponcon(
      image: "dominos.png",
      cname: "Domino's Pizza",
      crate: "100",
      cvalidity: "valid until 31 september 2022"),
  couponcon(
      image: "starbucks.png",
      cname: "Starbucks",
      crate: "150",
      cvalidity: "valid until 31 july 2022"),
  couponcon(
      image: "pepsi.png",
      cname: "Pepsi",
      crate: "75",
      cvalidity: "valid until 31 july 2022"),
];

class CheckOutP extends StatelessWidget {
  const CheckOutP(
      {Key? key, required this.productIndex, required this.productValue})
      : super(key: key);

  final int productIndex;
  final Map productValue;

  @override
  Widget build(BuildContext context) {
    return PaymentCheckout(
        productValue: productValue, productndex: productIndex);
  }
}

class PaymentCheckout extends StatefulWidget {
  const PaymentCheckout(
      {Key? key, required this.productndex, required this.productValue})
      : super(key: key);

  final int productndex;
  final Map productValue;

  @override
  State<PaymentCheckout> createState() => _PaymentCheckoutState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  //opacity is optional value
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _PaymentCheckoutState extends State<PaymentCheckout>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Maps',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.grey,
                body: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape
                            .rectangle, // BoxShape.circle or BoxShape.retangle
                        // color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4.0,
                          ),
                        ]),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 40, right: 135),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Back',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.bold),
                                )),
                            const Text(
                              "CheckOut",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.89,
                    child: screen(
                        productValue: widget.productValue,
                        productId: widget.productndex),
                  ),
                ]))));
  }
}

enum SingingCharacter { card, Bankaccount, COD }

class screen extends StatefulWidget {
  const screen({Key? key, required this.productId, required this.productValue})
      : super(key: key);
  final int productId;
  final Map productValue;

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {
  Color _iconcolor = Colors.green;
  Color _iconcolors = Colors.red;

  String cPrice = "";
  String cName = "";
  File? _cImage;
  String selectedAddress = "";
  Map addressSelected = {};
  TextEditingController tipController = TextEditingController();
  TextEditingController addNotesController = TextEditingController();

  // late ConfettiController _centerController;
  List? getAllAddress = [];

  String tipPrice = "";
  bool isTipSelected = false;

  late GoogleMapController mapController;
  late Position _currentPosition;
  late String placeAddress;
  bool currentAddressBool = false;
  bool pinnedAddressBool = false;
  bool savedAddress = false;

  @override
  void initState() {
    // super.initState();
    MapMethods.checkIfLocationPermissionEnabled();

    getCurrentLocation(false);
    // _centerController =
    //     ConfettiController(duration: const Duration(seconds: 2));
  }

  getCurrentLocation(isAnimateToCurrentPosition) async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      _currentPosition = position;

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
      // Places are retrieved using the coordinates
      List<Placemark> p =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Taking the most probable result
      print(p);
      Placemark place = p[0];

      // Structuring the address
      placeAddress =
          "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      CurrentAddress currentAddress = CurrentAddress();
      currentAddress.currentAddress = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updateCurrentLocationAddress(currentAddress);
    });
  }

  tipFecth(tip) {
    print(tip);
    if (tip == "other") {
      return opendialog();
    } else {
      print(tip);
      tipPrice = tip;
    }
    print(tip);
    print(isTipSelected);
  }

  editTip(newTip) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    return tipFecth(newTip);
  }

  Future<void> _showMyDialog(deleteId) async {
    print(deleteId);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                // Text('This is a demo alert dialog.'),
                Text('Would you like to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                delete_address(deleteId['addressSno']);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> delete_address(deleteId) async {
    Map deleteaddress;
    print(deleteId);
    final response = await http.delete(
      Uri.parse(
          'http://192.168.0.161:8083/api/delete_address/?addressSno=${deleteId}'),
    );

    if (response.statusCode == 200) {
      deleteaddress = json.decode(response.body);
      print(deleteaddress['data'].toString());
      Navigator.pop(context);
    } else {
      print("error");
      throw Exception('Failed to get address.');
    }
  }

  Future<String?> opendialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          // title: Text("name"),
          content: TextFormField(
            autofocus: true,
            controller: tipController,
            validator: (value) {
              print(value);
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
            cursorColor: Colors.black,
            style: TextStyle(
              color: Colors.black,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              labelText: 'Enter amount',
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          actions: [
            TextButton(
                child: Text("submit"),
                onPressed: () {
                  setState(() {
                    editTip(tipController.text.toString());
                    tipController.clear();
                  });
                }),
          ],
        ),
      );

  Future<void> getAll_Address() async {
    Map getAddress;
    print("in");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8083/api/get_all_address/?customerSno=4'),
    );
    print("out");
    getAddress = json.decode(response.body);
    // setState(() {
    if (response.statusCode == 200) {
      getAddress = json.decode(response.body);
      getAllAddress = getAddress['data'];
      print(getAllAddress);
      print("pass");
      return openPop();
    } else {
      print("error");
      throw Exception('Failed to get address.');
    }
    // });
  }

  Map selectedItem = {};
  Future<Future<Object?>> placeOrder() async {
    Map order;
    print("in");
    print(selectedItem);
    print("hgdfhdfsfdhad");
    print(DataClass().totalCost);
    Consumer<DataClass>(builder: (context, data, child) {
      print("test++++++++++++++++++++++++++++");
      print(data.totalCost);
      print('<<<<<---------------${data.selectedItem['0']}');
      return Text("tes");
    });
    final response = await http.post(
      Uri.parse('http://192.168.0.161:8090/api/create_order'),
      body: jsonEncode({
        "totalQuantity": 1,
        "totalPrice": 350,
        "totalTax": 0,
        "totalCharges": 0,
        "totalDiscount": 0,
        "payablePrice": 350,
        "orderOn": "Asia/Kolkata",
        "address": {
          "addressSno": 2,
          "customerSno": 4,
          "customerAddressSno": 1,
          "addressTypeCd": 15,
          "addressLine1": selectedAddress,
          "addressLine2": "",
          "citySno": null,
          "pinCode": null,
          "latitude": addressSelected['latitude'],
          "longitude": addressSelected['longitude'],
          "deliveryInstructions": "innovix",
          "cdValue": "Work",
          "isSelect": true
        },
        "latitude": "13.0213",
        "longitude": "80.2231",
        "productList": [
          {
            "product_sno": 1,
            "product_price": 300,
            "total_quantity": 1,
            "category_sno": 1,
            "product_name": "biriyani",
            "total_tax": 0
          }
        ],
        "entitySno": 1,
        "customerSno": 4,
        "paymentTypeCd": 32,
        "razorpayPaymentId": "pay_JsrRrxBSD7XFAH",
        "paymentStatusCd": 34
      }),
    );
    print("out");
    order = json.decode(response.body);
    if (response.statusCode == 200) {
      order = json.decode(response.body);
      print("pass");
      print("testsPlaceOrder");
      print(order['data']);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PlaceOrder()));
    } else {
      print("error");
      throw Exception('Failed to place order.');
    }
  }

  selectAddress(address) {
    print("-----------------defefef--------------------");
    print(address['latitude']);
    print(address['longitude']);
    print(address['addressLine1']);
    addressSelected = address;
    selectedAddress = address['addressLine1'];
    Navigator.pop(context);
  }

  removeCoupon() {
    cName = "";
    cPrice = "";
  }

  openPop() {
    print(getAllAddress);
    // print(getAllAddress!.length);
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.250,
                  child: getAllAddress != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: getAllAddress!.length,
                          itemBuilder: (context, index) {
                            print('<<<<<<---------$getAllAddress');
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 30, 0, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey.shade200,
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.450,
                                // height:MediaQuery.of(context).size.height * 0.550,

                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressAutoComplete(
                                                            address:
                                                                getAllAddress![
                                                                    index],
                                                          )));
                                            });
                                          },
                                          icon: Icon(Icons.edit,
                                              color: _iconcolor),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _showMyDialog(
                                                getAllAddress![index]);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: _iconcolors),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            savedAddress = true;
                                            pinnedAddressBool = false;
                                            currentAddressBool = false;
                                            selectAddress(
                                                getAllAddress![index]);
                                          });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.350,
                                          child: Text(
                                            getAllAddress![index]
                                                ['addressLine1'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Text(""),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.180,
                    width: MediaQuery.of(context).size.width * 0.280,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 0, 30),
                      child: Container(
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(18),
                        //   color: Colors.grey.shade200,
                        // ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChooseOnMap()));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    currentAddressBool = true;
                    savedAddress = false;
                    pinnedAddressBool = false;

                    Navigator.pop(context);
                    print('<<<<<<<<<<<<<<<<<---------currentAddressBool-----');
                  });
                  // CurrentAddressText();
                },
                child: const Text('Use Current Location')),
            TextButton(
                onPressed: () {
                  setState(() {
                    pinnedAddressBool = true;
                    savedAddress = false;
                    currentAddressBool = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChooseOnMap()));
                  });
                  // CurrentAddressText();
                },
                child: const Text('Choose on Map'))
          ],
        );
      },
    );
  }

  applyCoupon(coupon) {
    cPrice = coupon.crate;
    cName = coupon.cname;
    print(coupon.image);
    Navigator.pop(context);
    // _centerController.play();
  }

  getCoupon() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Coupons",
          style: TextStyle(color: HexaColor('#464444'), fontSize: 15),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: HexaColor('#666161'),
            ),
            label: Text(
              'back',
              style: TextStyle(color: HexaColor('#666161')),
            )),
      ),
      body: Scaffold(
          backgroundColor: HexaColor('#F2F2F2'),
          body: ListView.builder(
              itemCount: Couponlist.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 25, right: 25, bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        applyCoupon(Couponlist[index]);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            //height: 100,
                            //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Image.asset(
                                "assets/images/${Couponlist[index].image}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.001,
                              //height: 90,
                              //width: 10,
                              child: const DottedLine(
                                direction: Axis.vertical,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.black38,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, top: 25),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              //width: 170,
                              //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Couponlist[index].cname,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Text("\u{20B9} "),
                                          Text(
                                            Couponlist[index].crate,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('Coupon'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Couponlist[index].cvalidity,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  SingingCharacter? _character = SingingCharacter.card;
  DataClass dataObject = DataClass();

  int itemCount = 0;
  int subItemCount = 0;
  addItem(int itemValue) {
    print("swetha");
    print(itemValue);
    subItemCount = subItemCount + itemValue;
    print("testssssss");
    print(subItemCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexaColor('#F2F2F2'),
              blurRadius: 2.0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Adayar Ananda Bhavan",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: HexaColor("#0E6202"),
                        fontSize: 20.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: getAll_Address,
                  child: const Text("Change",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ]),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/images/Map.png'),
                        fit: BoxFit.contain,
                        width: 23,
                      ),
                      Container(
                        child: Visibility(
                          visible: savedAddress,
                          child: Text(selectedAddress),
                        ),
                      ),
                      Container(
                        child: Visibility(
                          visible: currentAddressBool == true,
                          child: CurrentAddressText(),
                        ),
                      ),
                      Container(
                        child: Visibility(
                          visible: pinnedAddressBool == true,
                          child: const PinnedAddress(),
                        ),
                      )
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: cName == ""
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ])
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexaColor('#FFFFE0'),
                              HexaColor('#91D9B1')
                            ]),
                        boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ]),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      Consumer<DataClass>(builder: (context, data, child) {
                        print(data.selectedItem);
                        selectedItem = data.selectedItem;
                        print('<<<<<---------------${data.selectedItem['0']}');
                        return (data.selectedItem != null)
                            ? ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(height: 7);
                                },
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: data.selectedItem.length,
                                itemBuilder: (_, index) {
                                  return data.count[index] != 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // Image(
                                            //   image: AssetImage(
                                            //     'assets/vegIcon.png',
                                            //   ),
                                            //   height: 15,
                                            //   // fit: BoxFit.contain,
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.41,
                                                // decoration: BoxDecoration(
                                                //   border:Border.all(color:Colors.black),
                                                //       ),
                                                child: Text(
                                                  // '${data.selectedItem[index.toString()]['categoryName']}',
                                                  '${data.selectedItem[index.toString()]['prodcutList']['data'][0]['productName']}',

                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              decoration: BoxDecoration(
                                                  // border:Border.all(color:Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          Provider.of<DataClass>(
                                                                  context,
                                                                  listen: false)
                                                              .decrementX(
                                                                  data.selectedItem[
                                                                      index],
                                                                  index);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: HexaColor(
                                                            '#0E6202'),
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<DataClass>(builder:
                                                      (context, data, child) {
                                                    return Text(
                                                      '${data.count[index]}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: HexaColor(
                                                            '#0E6202'),
                                                      ),
                                                    );
                                                  }),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // dataObject.incrementX(data.selectedItem[index], data.count[index]);
                                                        context
                                                            .read<DataClass>()
                                                            .incrementX(
                                                                data.selectedItem[
                                                                    index],
                                                                index);
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                          HexaColor('#0E6202'),
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13),
                                              child: Consumer<DataClass>(
                                                  builder:
                                                      (context, data, child) {
                                                print(data
                                                    .count[widget.productId]);
                                                print(data.price);
                                                print(
                                                    "brindha__________________________________");
                                                itemCount = data.selectedItem[
                                                                index
                                                                    .toString()]
                                                            [
                                                            'prodcutList']['data']
                                                        [0]['sellingPrice'] *
                                                    data.count[index];
                                                addItem(itemCount);
                                                return Text(
                                                  '${data.selectedItem[index.toString()]['prodcutList']['data'][0]['sellingPrice'] * data.count[index]}',
                                                  // '${{data.count[index]}}',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                );
                                              }),
                                            ),
                                          ],
                                        )
                                      : Container();
                                })
                            : Container();
                      }),
                      const Divider(
                        endIndent: 15,
                        indent: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Item Total',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              '\u{20B9}630',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        endIndent: 10,
                        indent: 10,
                      ),
                      (tipPrice != "")
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Tips Added",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            '\u{20B9} ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            tipPrice,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            )
                          : Row(),
                      (cName != "")
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Coupon Discount",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '-  \u{20B9} ${cPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexaColor("#0E6202"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            )
                          : Row(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Delivery Fee',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Text(
                              '\u{20B9} 40',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        endIndent: 10,
                        indent: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Pay',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: HexaColor("#0E6202"),
                              ),
                            ),
                            Text(
                              '\u{20B9} 630',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: HexaColor("#0E6202"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Special Request to Kitchen',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                    // borderRadius: BorderRadius.circular(19),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: addNotesController,
                    decoration: InputDecoration(
                        hintText: "Add Your Delivery Notes",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: HexaColor("#0E704D"),
                          ),
                        )),
                  )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Offers and Benefits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              (cName != "")
                  ? Container(
                      height: 80,
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                HexaColor('#FFFFE0'),
                                HexaColor('#91D9B1')
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 15),
                                  child: Text(
                                    cName + " " + "Applied",
                                    style: TextStyle(
                                        color: HexaColor('#0E704D'),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3, left: 15),
                                  child: Text(
                                    'You Saved \u{20B9} $cPrice ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_sharp, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                removeCoupon();
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: ConfettiWidget(
                          //     confettiController: _centerController,
                          //     blastDirection: pi / 2,
                          //     maxBlastForce: 5,
                          //     minBlastForce: 1,
                          //     emissionFrequency: 0.03,
                          //
                          //     // 10 paticles will pop-up at a time
                          //     numberOfParticles: 10,
                          //
                          //     // particles will pop-up up
                          //     gravity: 0,
                          //   ),
                          // ),
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    'Apply Coupon',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3, left: 15),
                                  child: Text(
                                    'Save upto \u{20B9} 150 with TRYNEW',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 100),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_outlined),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => getCoupon()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Add Tip (Optional)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ]),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              tipFecth("10");
                            });
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: '\u{20B9}10',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: HexaColor("#0E704D"),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ]),
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            setState(() {
                              tipFecth("25");
                            });
                          },
                          decoration: InputDecoration(
                              hintText: '\u{20B9}25',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: HexaColor("#0E704D"),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ]),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              tipFecth("50");
                            });
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: '\u{20B9}50',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: HexaColor("#0E704D"),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ]),
                        child: TextField(
                          textAlign: TextAlign.center,
                          onTap: () {
                            setState(() {
                              tipFecth("other");
                            });
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'other',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: HexaColor("#0E704D"),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Colors.grey,
                    )
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 15),
                      child: Row(
                        children: [
                          Radio(
                              value: SingingCharacter.card,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              }),
                          Image.asset('assets/images/card.png'),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Card',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 15),
                      child: Row(
                        children: [
                          Radio(
                              value: SingingCharacter.Bankaccount,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              }),
                          Image.asset('assets/images/bankaccount.png'),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'UPI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 15),
                      child: Row(
                        children: [
                          Radio(
                              value: SingingCharacter.COD,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              }),
                          Image.asset('assets/images/COD.png'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'COD',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        // width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Container(
            //     padding: EdgeInsets.all(15),
            //     color: Colors.green,
            //     child: Text("data")),
            GestureDetector(
              onTap: () {
                placeOrder();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexaColor('#0E6202'),
                ),
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
