
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MyScheduleProvider with ChangeNotifier {
  LocationPermission? statusPermission;
  List<Placemark>? placemark;
  LocationPermission? get mystatusPermission => statusPermission;
  List<Placemark>? get myplacemark => placemark;
  void setStatusPermission(
      LocationPermission? statusPermission1, List<Placemark>? placemark1) {
    // log(statusPermission1.toString() + placemark1.toString() + 'in provider');
    this.statusPermission = statusPermission1;
    this.placemark = placemark1;
    notifyListeners();
  }

  bool cancelledHotelBooking = false;
  bool get showCancelHotelBooking => cancelledHotelBooking;
  set showCancelHotelBooking(bool value) {
    cancelledHotelBooking = value;
    notifyListeners();
  }

  bool cancelledBusBooking = false;
  set showCancelBusBooking(bool value) {
    cancelledBusBooking = value;
    notifyListeners();
  }

  bool cancelledFlightBooking = false;
  bool get showCancelFlightBooking => cancelledFlightBooking;
  set showCancelFlightBooking(bool value) {
    cancelledHotelBooking = value;
    notifyListeners();
  }
}
