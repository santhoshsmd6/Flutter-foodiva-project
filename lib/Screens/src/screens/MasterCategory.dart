import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Master Category/FirstScreen.dart';
import '../../Payment/data_class.dart';
import '../helpers/colors.dart';
import 'dart:io';

class MasterCategory extends StatefulWidget {
  final List hotelList;
  final Map entityDetals;
  final String headerName;

  MasterCategory({
    required this.hotelList,
    required this.entityDetals,
    required this.headerName,
    // required headerImage,
    // required this.catergoryName,
    // required this.categoryImage
  });

  @override
  @override
  State<MasterCategory> createState() => _MasterCategoryState();
}

String dropdownValue = '';

class _MasterCategoryState extends State<MasterCategory> {
  @override
  Widget build(BuildContext context) {
    print("testsssssss");
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: ListView(children: <Widget>[
              //App Bar
              Container(
                height: 120,
                decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.black),
                    image: DecorationImage(
                        image: AssetImage("assets/appBarBG.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(45),
                        topLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(45))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                    Image.network(
                      widget.entityDetals['media'][0]['thumbnailUrl'],
                      width: 70,
                    ),
                    Text(
                      widget.headerName,
                      style: const TextStyle(
                          fontSize: 30.0,
                          height: 1.4,
                          fontWeight: FontWeight.w600),
                    ),
                    // Consumer<DataClass>(
                    //     builder: (context, data, child) {
                    //       return Text(
                    //         "${data.categoryName}",
                    //         style: TextStyle(
                    //             fontSize: 30.0,
                    //             height: 1.4,
                    //             fontWeight: FontWeight.w600)
                    //       );
                    //     }),
                    // padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                    // Image.network(
                    //   '${widget.categoryImage}',
                    //   width: 70,
                    // ),
                    // Container(),
                  ],
                ),
              ),

              //NavBar
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Back',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  //height: 756,
                  child: FirstScreen(hotel: widget.hotelList)),
            ])),
      ),
    );
  }
}
