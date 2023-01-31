import 'package:geolocator/geolocator.dart';

class Address{
  String? placeName;
  String? placeId;
  double? latitude;
  double? longitute;
  String? currentAddress;

  Address({
    this.placeName,
    this.placeId,
    this.latitude,
    this.longitute,
    this.currentAddress,
});
}

class CurrentAddress{
  String? currentAddress;
  double? currentlatitude;
  double? currentlongitute;

  CurrentAddress({
    this.currentAddress,
    this.currentlatitude,
    this.currentlongitute

  });
}