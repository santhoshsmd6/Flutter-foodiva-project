import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Container(
          // decoration: const BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(10),
          //       topLeft: Radius.circular(5),
          //       bottomRight: Radius.circular(5),
          //       bottomLeft: Radius.circular(10)),
          //   color: Color(0xFFBFBFBF),
          // ),
          child: Image.file(
        _selectedFile!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ));
    } else {
      return Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //       top: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
          //       bottom:
          //           BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
          //       left: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
          //       right: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
          //     ),
          //     borderRadius: BorderRadius()),
          child: Image.asset(
        "assets/profile.jpeg",
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
      File? cropped = await ImageCropper().cropImage(
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
          ));

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
                          color: Colors.green,
                          child: const Text(
                            "Camera",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          }),
                      MaterialButton(
                          color: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () => dialogue(context),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                    height: MediaQuery.of(context).size.height * .09,
                    width: MediaQuery.of(context).size.width * .09,
                    child: getImageWidget())),
            // Container(
            //     height: MediaQuery.of(context).size.height * .20,
            //     child: Padding(
            //         padding: const EdgeInsets.fromLTRB(20, 20, 29, 0),
            //         child: Column(children: <Widget>[
            //           Text(
            //             "Swetha",
            //             textAlign: TextAlign.left,
            //             style: TextStyle(
            //                 decoration: TextDecoration.none,
            //                 color: Colors.black,
            //                 fontSize: 20.0,
            //                 fontFamily: 'Raleway',
            //                 fontWeight: FontWeight.w600),
            //           ),
            //           Text(""),
            //           Text("swetha@gmail.com"),
            //           Text("9999-999-999"),
            //           Text("No 15, Bharathi Street,"),
            //           Text("Chennai-38")
            //         ])))
          ],
        ),
        // (_inProcess)
        //     ? Container(
        //         color: Colors.white,
        //         height: MediaQuery.of(context).size.height * 0.95,
        //         child: const Center(
        //           child: CircularProgressIndicator(),
        //         ),
        //       )
        //     : Center()
      ],
    );
  }
}
