import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../customer/CustomerScreen.dart';
import '../customer/NavBAr.dart';
import '../src/screens/Home.dart';

class OtpPage extends StatefulWidget {
  final Map loginResponse;
  final String DeviceId;
  String otpValue1;
  OtpPage(
      {required this.loginResponse,
      required this.DeviceId,
      required this.otpValue1});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String isOtpValid = "";
  Future submitOtp(context, otpValue) async {
    print(otpValue);
    Map OtpResponce;
    print("in");
    final response = await http.post(
      Uri.parse('http://192.168.0.161:8082/api/otp_verify'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Access-Control-Allow-Origin': '*'
      // },
      body: jsonEncode({
        "simOtp": textEditingController.text,
        "pushOtp": widget.loginResponse['data']['pushOtp'].toString(),
        "apiOtp": widget.loginResponse['data']['apiOtp'].toString(),
        "deviceId": widget.DeviceId,
        "appUserSno": widget.loginResponse['data']['appUserSno'].toString(),
        "loginTime": "asia/calcutta"
      }),
    );

    print("out");
    print(response.statusCode);
    if (response.statusCode == 200) {
      OtpResponce = json.decode(response.body);
      print(widget.loginResponse['data'].toString());
      print(widget.loginResponse['data']['isNewUser'].toString());
      print(OtpResponce['data'].toString());
      OtpResponce['data']["isVerifiedUser"].toString();
      String newuser = widget.loginResponse['data']['isNewUser'].toString();

      if (OtpResponce['data']["isVerifiedUser"].toString() == "true") {
        print(
            "__________________________________________paithiyakaran santhosh");
        setState(() {
          isOtpValid = "true";
        });
        if (newuser == "true") {
          setState(() {
            isOtpValid = "true";
          });
          print('..........................................gowri');
          return _CustomerScreen(context);
        } else {
          setState(() {
            isOtpValid = "true";
          });
          print("------------------------------paithiyakari swetha");
          return _DashBord(context);
        }
      } else {
        print("invalidOtp");
        setState(() {
          isOtpValid = "false";
        });
        // return isOtpValid = "false";
      }
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  _DashBord(context) {
    print("function in");
    Navigator.push(
      context,
      MaterialPageRoute(
        // MyApp6(
        //               skipResponse: widget.loginResponse,
        //               skipDeviceId: widget.DeviceId)
          builder: (context) =>DashBoard()),
    );
  }

  _CustomerScreen(context) {
    print("function in");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerScreen(
              skipResponse: widget.loginResponse,
              skipDeviceId: widget.DeviceId)),
    );
  }

  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Column(
          children: [
            PinCodeTextField(
              length: 6,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 45,
                activeFillColor: Colors.grey,
                inactiveColor: Colors.grey,
                inactiveFillColor: Colors.grey,
                selectedFillColor: Colors.grey,
                selectedColor: Colors.grey,
                activeColor: Color(0xFF0E6202),
              ),
              controller: textEditingController,
              onCompleted: (v) {
                if (widget.otpValue1 == null) {
                  Text("Please Enter OTP");
                } else {
                  setState(() {
                    print("widget.otpValue1 = v");
                    widget.otpValue1 = v;
                  });
                  return null;
                }
              },
              onChanged: (value) {
                debugPrint(value);
              },
              beforeTextPaste: (text) {
                return true;
              },
              appContext: context,
            ),
            (isOtpValid == "false")
                ? Center(
                    child: Text(
                    "Enter Valid OTP",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ))
                : Text(""),
            ElevatedButton(
              onPressed: () {
                if (widget.otpValue1.length != null) {
                  print(textEditingController.text);
                  print("widget.otpValue1.length != null");
                  submitOtp(context, widget.otpValue1);
                } else {
                  print("please enter OTP");
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                primary: Color(0xFF0E6202),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
