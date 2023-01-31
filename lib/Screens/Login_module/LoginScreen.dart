import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_food1/Screens/src/screens/Home.dart';
import 'package:provider/provider.dart';
import '../Payment/data_class.dart';
import '../customer/NavBAr.dart';
import 'otpbox.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class LoginScreen extends StatelessWidget {
  static String _title = 'Sample App';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MyStatefulWidget(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void initState() {
    super.initState();
    _deviceDetails();
  }

  Color HexaColor(String strcolor, {int opacity = 15}) {
    strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
    String stropacity =
        opacity.toRadixString(16); //convert integer opacity to Hex String
    return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  }

  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map mapResponse = {};
  String identifier = '';
  var seconds;
  String otpValue = "";

  Future<void> _deviceDetails() async {
    print("swetha");
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      print("santhosh");
      var build = await deviceInfoPlugin.androidInfo;
      setState(() {
        identifier = build.androidId;
      });
      //UUID for Androidnulnullnulll
    }
  }

  Future<void> login(phNumber) async {
    print("in" + phNumber);
    Provider.of<DataClass>(context, listen: false)
        .userMobileNumber(phoneController.text);
    final response = await http.post(
      Uri.parse('http://192.168.0.161:8082/api/verify_user'),
      body: jsonEncode({
        "roleName": "Customer",
        "countryCode": "91",
        "mobileNumber": phNumber,
        "deviceId": identifier,
        "loginTime": "asia/calcutta",
        "deviceTypeName": "mobile",
        "hashCode": null
      }),
    );
    print("out");

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      print(mapResponse['data']['isNewUser'].toString());
      print(mapResponse['data'].toString());
      return _openMyPage(mapResponse);
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  Future<void> _resendOtp(value) async {
    print(otpValue);
    print(seconds);
    Map OTPResponce;
    print("in");
    final response = await http.post(
      Uri.parse('http://192.168.0.161:8082/api/resend_otp'),
      body: jsonEncode({
        "appUserSno": mapResponse['data']['appUserSno'].toString(),
        "deviceId": identifier,
        "timeZone": "Asia/Kolkata",
        // "hashCode":null
      }),
    );
    print("out");

    if (response.statusCode == 200) {
      OTPResponce = json.decode(response.body);
      return print(OTPResponce['simOtp'].toString());
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  _openMyPage(mapResponse) {
    bool resendTimer = true;
    Provider.of<DataClass>(context, listen: false)
        .setLoginRes(mapResponse['data'], identifier);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: (BoxDecoration(
                //color: HexaColor('#ECE9EC'),
                borderRadius: BorderRadius.all(Radius.circular(20)))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 10)),
                  Container(
                    child: Text(
                      'Enter OTP',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: HexaColor('#0E6202'),
                          fontFamily: "Outfit"),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      'kindely for few seconds to recive',
                      style: TextStyle(fontSize: 15, fontFamily: "Outfit"),
                    ),
                  ),
                  Container(
                    child: Text(
                      'your OTP in given number',
                      style: TextStyle(fontSize: 15, fontFamily: "Outfit"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: OtpPage(
                        loginResponse: mapResponse,
                        DeviceId: identifier,
                        otpValue1: otpValue),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Didn't Recive?",
                          style: TextStyle(fontFamily: "Outfit"),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TweenAnimationBuilder<Duration>(
                          duration: Duration(seconds: 30),
                          tween: Tween(
                              begin: Duration(seconds: 30), end: Duration.zero),
                          onEnd: () {
                            print('Timer ended');
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            seconds = value.inSeconds % 30;
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: seconds != 0
                                    ? Text("${seconds} sec",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // if (otpValue != '') {
                                            otpValue = '';
                                            // }
                                            seconds == 0
                                                ? seconds = Duration(seconds: 3)
                                                : seconds =
                                                    Duration(seconds: 00);
                                            _resendOtp(value);
                                          });
                                        },
                                        child: Text(
                                          "Resend OTP",
                                          style: TextStyle(
                                              color: HexaColor('#0E6202'),
                                              fontWeight: FontWeight.bold),
                                        )));
                          })
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
//            image: AssetImage("assets/images/bulb2.png"),
        image: AssetImage("assets/images/lf.png"),
        fit: BoxFit.cover,
      )),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoard()),
                        // MyApp6(
                        //     skipResponse: mapResponse,
                        //     skipDeviceId: identifier)
                      );
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 310, top: 29.0, right: 0.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                              color: Color(0xFF0E6202),
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        )),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 5, top: 29.0, right: 0.0),
                    alignment: Alignment.center,
//                      padding: const EdgeInsets.all(10),
                    child:
                        //new
                        Image.asset(
                      'assets/images/skiparrow.png',
                      height: 12,
                      width: 12,
                    ),
                  ),
                ],
              ),

//new
              new Container(
                  margin: const EdgeInsets.only(
                      left: 15, top: 274, right: 15, bottom: 10),
                  height: 70.0,
                  decoration: new BoxDecoration(
                      color: Color(0xFFf3f3f3),
//                      color: Colors.black,

                      borderRadius:
                          new BorderRadius.all(new Radius.circular(10.0))),
                  child: new Form(
                    key: _formKey,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter a phone number',
                                hintStyle: TextStyle(fontSize: 18)),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              } else if (value != null && value.length > 10 ||
                                  value.length < 10) {
                                return 'Please enter valid phone number';
                              }
                              // print(value);
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  )),

              SizedBox(
                height: 28,
              ),
              Container(
                  height: 62,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("object");
                        login(phoneController.text);
                        //_openMyPage(phoneController.text.toString());
                      }
                    },
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                          //                      color: Color(0xFF0E6202),
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.bold,

                          //                        fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 40.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      primary: Color(0xFF0E6202),
                    ),
                  )),
            ],
          )),
    );
  }
}
