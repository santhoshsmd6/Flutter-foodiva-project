import 'package:flutter/material.dart';

import 'address.dart';

class AppData extends ChangeNotifier{
  Address? pinnedLocationOnMap;
  CurrentAddress? currentAddressString;

  void updatePickUpLocationAddress (Address pickUpAddress){
    pinnedLocationOnMap= pickUpAddress;
    notifyListeners();
  }

  void updateCurrentLocationAddress (CurrentAddress address){
    currentAddressString= address;
    notifyListeners();
  }
}