import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AddressPopup extends StatefulWidget {
  const AddressPopup({Key? key}) : super(key: key);

  @override
  State<AddressPopup> createState() => _AddressPopupState();
}

class _AddressPopupState extends State<AddressPopup> {
  @override
  void initState() {
    super.initState();
    getAll_Address();
  }

  Future<void> getAll_Address() async {
    Map getAddress;
    print("in");
    final response = await http.get(
      Uri.parse('http://192.168.0.149:8083/api/get_all_address/?customerSno=1'),
    );
    print("out");

    if (response.statusCode == 200) {
      getAddress = json.decode(response.body);
      print(getAddress['data'].toString());
      return print(getAddress['data'].toString());
    } else {
      print("error");
      throw Exception('Failed to get address.');
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2)),
              height: 200,
              width: 200,
              child: Column(
                children: [Text("data"), Text("dsydtusy")],
              ),
            )
          ],
        ),
      ),
    );
  }
}
