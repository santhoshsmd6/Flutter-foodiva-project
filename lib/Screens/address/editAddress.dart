import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignProfile extends StatefulWidget {
  const SignProfile({Key? key}) : super(key: key);

  @override
  State<SignProfile> createState() => _SignProfileState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity =
      opacity.toRadixString(16); //convert integer opacity to Hex String
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _SignProfileState extends State<SignProfile> {
  TextEditingController addressOneController = TextEditingController();
  TextEditingController addressTwoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> createAddress(
      address1, address2, city, state, pincode, country) async {
    Map addressResponse;
    print("in");
    final response = await http.post(
      Uri.parse('http://192.168.0.149:8083/api/create_address'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Access-Control-Allow-Origin': '*'
      // },
      body: jsonEncode({
        "addressSno": null,
        "customerSno": 1,
        "customerAddressSno": null,
        "addressLine1": address1 +
            "" +
            address2 +
            "" +
            city +
            "" +
            state +
            "" +
            pincode +
            "" +
            country,
        "addressLine2": address2,
        "citySno": null,
        "pinCode": null,
        "latitude": 12.926437200000002,
        "longitude": 80.23264842963866,
        "addressTypeCd": 15,
        "deliveryInstructions": "innovix",
        "cdValue": null
      }),
    );
    print("out");

    if (response.statusCode == 200) {
      addressResponse = json.decode(response.body);

      print(addressResponse.toString());
      return _openMyPage();
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  _openMyPage() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 68,
                  width: 64,
                ),
                // ElevatedButton(
                //   child: const Text('Submit'),
                //   onPressed: () => {},
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign-In',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
        ),
        leadingWidth: 80,
        leading: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
              size: 15,
            ),
            label: Text(
              'back',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: addressOneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Address Line 1',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: addressTwoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Address Line 2',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter City';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'City',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: stateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter State';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'State',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: pincodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Pincode';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Pincode',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: HexaColor('#ECE9EC'),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: countryController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Country';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    // obscureText: true,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Country',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: HexaColor('#0E6202')),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {
                          if (_formKey.currentState!.validate())
                            {
                              createAddress(
                                  addressOneController.text.toString(),
                                  addressTwoController.text.toString(),
                                  cityController.text.toString(),
                                  stateController.text.toString(),
                                  pincodeController.text.toString(),
                                  countryController.text.toString())
                            }
                        },
                        child:
                            Text('Next', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
