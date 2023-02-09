import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class ModuleName with ChangeNotifier {
  String lastSelectedCurrency = 'INR';

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String? departureDate = new DateFormat('dd MMM EE,yyyy')
      .format(DateTime.now().add(Duration(days: 5)));

  String? returnDate = new DateFormat('dd MMM EE,yyyy')
      .format(DateTime.now().add(Duration(days: 6)));

  DateTime? departureStandardDate = DateTime.now().add(Duration(days: 5)),
      returnStandardDate = DateTime.now().add(Duration(days: 6));
  setdepartureStandardDate({DateTime? dateX}) {
    this.departureStandardDate = dateX;
  }

  setreturnStandardDate({DateTime? dateX}) {
    this.returnStandardDate = dateX;
  }

  String convertStandardDateToFormattedDate({DateTime? dateX}) {
    return new DateFormat('dd MMM EE,yyyy').format(dateX!);
  }

  setdepartureSelectedDateFormatted({
    String? departureDateX,
  }) {
    departureDate = departureDateX;

    notifyListeners();
  }

  setreturnSelectedDateFormatted({
    String? returnDateX,
  }) {
    returnDate = returnDateX;

    notifyListeners();
  }

  TextStyle landingDestinationItemTitleStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10),
  );
  TextStyle buttonLoginRegStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
  );
  TextStyle nameLoginRegStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14),
  );
  TextStyle nameCardBelowCaraouselStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),
  );

  TextStyle moduleNameStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400, color: Colors.black87, fontSize: 13));

  TextStyle rechareBillPaymentHeaderStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 20),
  );
}
