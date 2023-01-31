import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../HistoryPage/Reorder.dart';
import '../HistoryPage/listing.dart';
import '../Login_module/LoginScreen.dart';
import '../Payment/data_class.dart';
import 'CustomerScreen.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class UserProfile extends StatefulWidget {
  final String Deviceid;
  final Map LoginRespnce;

  UserProfile({required this.Deviceid, required this.LoginRespnce});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

Color HexaColor(String strcolor, {int opacity = 15}) {
  strcolor = strcolor.replaceAll("#", ""); //replace "#" with empty value
  String stropacity = opacity.toRadixString(16);
  return Color(int.parse("$stropacity$stropacity" + strcolor, radix: 16));
  //here color format is 0xFFDDDDDD, where FF is opacity, and DDDDDD is Hex Color
}

class _UserProfileState extends State<UserProfile> {
  Future<void> _logout() async {
    Map capResponse;
    print("in");
    print(widget.LoginRespnce['data']['appUserSno'].toString());
    final response = await http.put(
      Uri.parse('http://192.168.0.149:8082/api/logout'),
      body: jsonEncode({
        "appUserSno": widget.LoginRespnce['data']['appUserSno'].toString(),
        "deviceTypeName": "mobile",
        "deviceId": widget.Deviceid
      }),
    );
    print("out");
    print(response.statusCode);
    if (response.statusCode == 200) {
      capResponse = json.decode(response.body);
      print(capResponse["msg"].toString());
      return FinalScreen();
    } else {
      print("error");
      throw Exception('Failed to Logout.');
    }
  }

  FinalScreen() {
    print("______________LogOut");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    print("_____________________LogoutCheck");
  }

  bool click = false;
  File? _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Container(
          child: Image.file(
        _selectedFile!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ));
    } else {
      return Container(
          child: Image.asset(
        "assets/images/profieBG (1).png",
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ));
    }
  }

  getImage(ImageSource source) async {
    Navigator.pop(context, false);
    setState(() {
      _inProcess = true;
    });
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      File? cropped = (await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "Image Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ))) as File?;

      setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  void dialogue(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .15,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text(
                            "Camera",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          }),
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text(
                            "Device",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<String?> logout() => showDialog<String>(
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: AlertDialog(
            title: Text("Come back soon!"),
            content: Text(
              "Are you sure you want to Logout?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _logout();
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );

  Future<void> get_orders(context) async {
    Map mapResponse;
    print("in");
    final response = await http.get(
      Uri.parse('http://192.168.0.161:8083/api/get_my_orders/?customerSno=4'),
    );
    print("out");
    print(response.statusCode);
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      // print(mapResponse['data'].toString());
      List orderHistory = mapResponse['data'];
      print(orderHistory.length);
      print(orderHistory[0]['customerEntityOrderSno']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Reorder(orders: orderHistory)));
    } else {
      print("error");
      throw Exception('Failed to get orders.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () => {
                            Navigator.pop(
                              context,
                            )
                          },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        size: 15,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerScreen(
                                  skipDeviceId: widget.Deviceid,
                                  skipResponse: widget.LoginRespnce,
                                )),
                      );
                    },
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => dialogue(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                              width: MediaQuery.of(context).size.width * .33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: getImageWidget()),
                        ),
                      )
                    ],
                  ),
                  (_inProcess)
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          height: MediaQuery.of(context).size.height * 0.95,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Center(),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Consumer<DataClass>(builder: (context, data, child) {
                return Text(
                  "${data.PhoneNumber}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                );
              }),
              SizedBox(
                height: 5,
              ),
              Consumer<DataClass>(builder: (context, data, child) {
                return Text(
                  "${data.CustomerFirstName} ${data.CustomerLastName}",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                );
              }),
              Consumer<DataClass>(builder: (context, data, child) {
                return Text(
                  " ${data.CustomerEmail}",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                );
              }),
              // ExpansionTile(title: Text('fjlik')),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  collapsedTextColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  title: Text(
                    'My Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Favourites & Offers',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Image.asset(
                      'assets/images/user-solid 1.png',
                      height: 25,
                    ),
                  ),
                  children: [
                    Divider(
                      color: Colors.green,
                      indent: 45,
                      endIndent: 25,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 4, vertical: -4),
                      title: Text(
                        'Favourites',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(top: 3, left: 30.0),
                        child: Image.asset(
                          'assets/images/heart.png',
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    Divider(
                      color: Colors.green,
                      indent: 45,
                      endIndent: 25,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 4, vertical: -4),
                      title: Text(
                        'Offers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(top: 3, left: 30),
                        child: Image.asset('assets/images/offers.png'),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    Divider(
                      color: Colors.green, //color of divider
                      // height: 1, //height spacing of divider
                      // thickness: 1, //thickness of divier line
                      indent: 45, //spacing at the start of divider
                      endIndent: 25, //spacing at the end of divider
                    ),
                  ],
                ),
              ),

              ListTile(
                title: Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Had Delicious Foods',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Image.asset(
                    'assets/images/biriyani.png',
                    height: 25,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  setState(() {
                    get_orders(context);
                  });
                },
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  collapsedTextColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  title: Text(
                    'Payments & Refunds',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    'Refund Status & Paymode Modes',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Image.asset(
                      'assets/images/indian-rupee-sign-solid 1.png',
                      height: 30,
                    ),
                  ),
                  children: [
                    Divider(
                      color: Colors.green,
                      indent: 45,
                      endIndent: 25,
                    ),
                    ListTile(
                      enabled: true,
                      visualDensity: VisualDensity(horizontal: 4, vertical: -4),
                      title: Text(
                        'Refund Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(left: 30, top: 3),
                        child: Image.asset('assets/images/refund.png'),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    Divider(
                      color: Colors.green,
                      indent: 45,
                      endIndent: 25,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 4, vertical: -4),
                      title: Text(
                        'Payment Modes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(left: 30, top: 3),
                        child: Image.asset('assets/images/payment.png'),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    Divider(
                      color: Colors.green,
                      indent: 45,
                      endIndent: 25,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Addresses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Share Edit & Add New Addresses',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Image.asset(
                    'assets/images/location-dot-solid 1.png',
                    height: 25,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MovieDetailsScreen(movie))
                  // );
                },
              ),
              FlatButton(
                  onPressed: () async {
                    logout();
                  },
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        'assets/images/right-from-bracket-solid 1.png',
                        height: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    ));
  }
}
