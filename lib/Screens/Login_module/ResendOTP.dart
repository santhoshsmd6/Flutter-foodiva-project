import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class ResnedOTP extends StatelessWidget {

  final Map OtpResponce;
  final String DeviceId;

  ResnedOTP({required this.OtpResponce, required this.DeviceId});

  Color HexaColor(String strcolor, {int opacity = 15}) {
    strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
    String stropacity = opacity.toRadixString(
        16); //convert integer opacity to Hex String
    return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  }

  Future<void> _resendOtp() async {
    Map OTPResponce;
    print("in");
    final response = await http.post(
      Uri.parse('http://192.168.0.149:8082/api/resend_otp'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'Access-Control-Allow-Origin': '*'
      // },
      body: jsonEncode({
        "appUserSno":OtpResponce['data']['appUserSno'].toString(),
        "deviceId":DeviceId,
        "timeZone":"Asia/Kolkata",
        // "hashCode":null
      }),
    );
    print("out");

    if (response.statusCode == 200) {
      OTPResponce = json.decode(response.body);
      return
        print(OTPResponce['simOtp'].toString());
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(seconds: 30),
        tween: Tween(begin: Duration(seconds: 30), end: Duration.zero),
        onEnd: () {
          print('Timer ended');
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final seconds = value.inSeconds % 30;
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child:seconds!=0?Text("${seconds} sec",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)):GestureDetector(
                  onTap: _resendOtp,
                  child: Text("Resend OTP",style: TextStyle(color: HexaColor('#0E6202'),fontWeight: FontWeight.bold),)));
        });
  }
}
