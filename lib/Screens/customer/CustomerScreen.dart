import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Payment/data_class.dart';
import '../src/screens/Home.dart';
import 'NavBAr.dart';

enum Button { Male, Female, Others }

class CustomerScreen extends StatelessWidget {
  final Map skipResponse;

  final String skipDeviceId;

  const CustomerScreen(
      {Key? key, required this.skipResponse, required this.skipDeviceId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0E6202),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: MyCustomForm(response: skipResponse, dId: skipDeviceId),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final Map response;
  final String dId;
  MyCustomForm({required this.response, required this.dId});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

String? vs;

class MyCustomFormState extends State<MyCustomForm> {
  // bool click = false;
  Future<void> fetc() async {
    final response = await http.get(Uri.parse(
        'http://192.168.0.161:8082/api/get_enum_name?codeType=gender_cd'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  bool male = false;
  bool female = false;
  bool others = false;
  Button? _character;

  final _formKey = GlobalKey<FormState>();
  TextEditingController myController = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();

  Future<void> login() async {
    String? fname = myController.text;
    String? lname = myController2.text;
    String? email = myController3.text;
    Map mapResponse;
    print("in");

    Provider.of<DataClass>(context, listen: false).setUserDetails(
        myController.text, myController2.text, myController3.text);

    print(myController.text);
    print(myController2.text);
    print(myController3.text);
    print(_result);
    if (_result == "12") {
      print("Male");
    } else {
      print("Female");
    }
    final response = await http.post(
      Uri.parse('http://192.168.0.161:8083/api/create_customer'),
      body: jsonEncode({
        "firstName": fname,
        "lastName": lname,
        "email": email,
        "genderCd": _result,
        "appUserSno": 3
      }),
    );
    print("out");

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      print("???????????test");
      print(mapResponse['data']);
      return reDirectPage(context);
    } else {
      print("error");
      throw Exception('Failed to Login.');
    }
  }

  reDirectPage(context) {
    print("___________________198");
    Navigator.push(
      context,
      MaterialPageRoute(
          // MyApp6(
          //             skipResponse: widget.response,
          //             skipDeviceId: widget.dId,
          //           )
          builder: (context) => BottomNavBar()),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  bool pressAttenti = false;
  bool pressAttent = false;
  var _result;
  @override
  Widget build(BuildContext context) {
    return Container(
//      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/signinPage.png"),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
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
                      left: 15, top: 54, right: 15, bottom: 10),
                  height: 70.0,
                  decoration: new BoxDecoration(
                      color: HexaColor("#F3F3F3"),
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
                            style: TextStyle(
                                fontSize: 18,
                                color: HexaColor("#171717"),
                                fontWeight: FontWeight.bold),
                            controller: myController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              // icon: const Icon(Icons.person),
                              hintText: 'Enter your FirstName',
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                margin: const EdgeInsets.only(
                    left: 15, top: 4, right: 15, bottom: 10),
                height: 70.0,
                decoration: new BoxDecoration(
                    color: HexaColor("#F3F3F3"),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(10.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(
                          fontSize: 18,
                          color: HexaColor("#171717"),
                          fontWeight: FontWeight.bold),
                      controller: myController2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // icon: const Icon(Icons.people_alt_sharp),
                        hintText: 'Enter your LastName',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.only(
                    left: 15, top: 4, right: 15, bottom: 10),
                height: 70.0,
                decoration: new BoxDecoration(
                    color: HexaColor("#F3F3F3"),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(10.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(
                          fontSize: 18,
                          color: HexaColor("#171717"),
                          fontWeight: FontWeight.bold),
                      controller: myController3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // icon: const Icon(Icons.people_alt_sharp),
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      children: [
                        Radio(
                            value: Button.Male,
                            groupValue: _character,
                            fillColor: MaterialStateColor.resolveWith(
                              (states) => male == true
                                  ? HexaColor("#0E6202")
                                  : Colors.black,
                            ),
                            onChanged: (Button? value) {
                              setState(() {
                                male = true;
                                female = false;
                                others = false;
                                _character = value;
                                fetc();
                              });
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Male',
                          style: TextStyle(
                            // color: MaterialStateColor.resolveWith((states) {
                            //   if (states.contains(MaterialState.selected)) {
                            //     return HexaColor("#0E6202");
                            //   }
                            //   return Colors.black;
                            // }),
                            color: male == true
                                ? HexaColor("#0E6202")
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      children: [
                        Radio(
                            value: Button.Female,
                            groupValue: _character,
                            fillColor: MaterialStateColor.resolveWith(
                              (states) => female == true
                                  ? HexaColor("#0E6202")
                                  : Colors.black,
                            ),
                            onChanged: (Button? value) {
                              setState(() {
                                female = true;
                                male = false;
                                others = false;
                                _character = value;
                              });
                              fetc();
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Female',
                          style: TextStyle(
                            color: female == true
                                ? HexaColor("#0E6202")
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      children: [
                        Radio(
                            value: Button.Others,
                            groupValue: _character,
                            fillColor: MaterialStateColor.resolveWith(
                              (states) => others == true
                                  ? HexaColor("#0E6202")
                                  : Colors.black,
                            ),
                            onChanged: (Button? value) {
                              setState(() {
                                others = true;
                                male = false;
                                female = false;
                                _character = value;
                              });
                            }),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Others',
                          style: TextStyle(
                            color: others == true
                                ? HexaColor("#0E6202")
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  height: 62,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          //                      color: Color(0xFF0E6202),
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.bold,

                          //fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
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
