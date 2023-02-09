import 'dart:developer';

import 'package:flutter/cupertino.dart';

class SelectedHotelData with ChangeNotifier {
  String? hotelCityCode, hotelCityName, hotelCountryName;

  SelectedHotelData();
  setHotelData(
      String hotelCityCodeX, String hotelCityNameX, String hotelCountryNameX) {
    hotelCityCode = hotelCityCodeX;
    hotelCityName = hotelCityNameX;
    hotelCountryName = hotelCountryNameX;

    log('==================hotel city name model' + hotelCityName.toString());
    notifyListeners();
  }
}
