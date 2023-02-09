import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/Model/selectedHotelData.dart';
import 'package:oneclicktravel/another_main_screen.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:oneclicktravel/utils/ModuleName.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'Model/FetchUpdateCustomerDetails.dart';
import 'MyScheduleProvider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MyScheduleProvider()),
    ChangeNotifierProvider(create: (_) => FetchUpdateCustomerDetails()),
    ChangeNotifierProvider(create: (_) => SelectedHotelData()),
    ChangeNotifierProvider(create: (_) => ModuleName()),
    ChangeNotifierProvider(create: (_) => MyUser()),
  ], child: MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

LocationPermission? statusPermission;
List<Placemark>? placemarks;
// var resultLocation;
late MyScheduleProvider myprovider;

_getCurrentLocationLatLong(MyScheduleProvider myprovider1) async {
  // print('_currentPosition==========$_currentPosition');
  myprovider = myprovider1;
  statusPermission = await Geolocator.requestPermission();

  // log("statusPermission.toString()=======================");
  if (statusPermission != LocationPermission.denied &&
      statusPermission != LocationPermission.deniedForever) {
    // log('permisssion grandted================');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // ignore: unnecessary_null_comparison
    if (position != null) {
      placemarks = await getCurrentLocation(position);
    } else {}
  } else {
    myprovider.setStatusPermission(statusPermission, placemarks);
  }
}

Future<List<Placemark>?> getCurrentLocation(Position _currentPosition) async {
  // print(_currentPosition.latitude);
  // print(_currentPosition.longitude);
  placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude, _currentPosition.longitude);

  getCountryFlagCurrencyFun(placemarks![0].isoCountryCode);

  return placemarks;
}

getCountryFlagCurrencyFun(String? countryCode) async {
  String getCountryFlagCurrency =
      "https://www.abengines.com/api/country-list/get-country-code.php?action=getCountryCode&countryCode=$countryCode";
  var response = await http.get(Uri.parse(getCountryFlagCurrency));
  List<dynamic> data = jsonDecode(response.body);
  log('got response main.dart=======================');
  log(data.toString());
  if (data[0] != null) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('selected_country_flag', data[0]['flag'].toString());
    await pref.setString('selected_country_code', data[0]['country_code']);
    await pref.setString('selected_currency_code', data[0]['code']);
    await pref.setString('selected_country_name', data[0]['country_name']);
    myprovider.setStatusPermission(statusPermission, placemarks);
  }
}

bool setGeoSettings = false;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          if (!setGeoSettings) {
            _getCurrentLocationLatLong(
                Provider.of<MyScheduleProvider>(context));
            setGeoSettings = true;
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'oneclicktravel',
              theme: ThemeData(
                primaryColor: ColorCodeGen.colorFromHex('#ffd022'),
                fontFamily: GoogleFonts.poppins().fontFamily,
                appBarTheme: AppBarTheme(
                    backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
                    systemOverlayStyle: SystemUiOverlayStyle.light),
                iconTheme: const IconThemeData(color: Colors.white),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: AnotherScreen());
        });
      },
    );
  }
}
