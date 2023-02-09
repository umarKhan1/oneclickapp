import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hotelui.dart';
import 'utils/size_config.dart';

class AnotherScreen extends StatefulWidget {
  AnotherScreen({Key? key}) : super(key: key);

  @override
  _AnotherScreenState createState() => _AnotherScreenState();
}

class _AnotherScreenState extends State<AnotherScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setPref();
  }

  setPref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    // if (_pref.getInt("rooms") == null && _pref.getInt("total_adult") == null) {
    //   await _pref.setInt("rooms", 1);
    //   await _pref.setInt("total_adult", 1);
    // }
    if (_pref.getInt('totalPessenger') == null &&
        _pref.getInt('flight_adults') == null &&
        _pref.getInt('flight_children') == null &&
        _pref.getInt('flight_infant') == null) {
      await _pref.setInt('totalPessenger', 1);
      await _pref.setInt('flight_adults', 1);
      await _pref.setInt('flight_children', 0);
      await _pref.setInt("flight_infant", 0);
    }
  }

  bool _large = true;
  double _width = 100;
  double _height = 100;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    print("Another Screen");

    if (_large == true) {
      Timer(Duration(seconds: 2), () {
        setState(() {
          // Generate a random width and height.
          _width = SizeConfig.blockSizeHorizontal * 60;
          _height = SizeConfig.blockSizeVertical * 30;
          _large = false;
        });
      });
    } else {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.pushAndRemoveUntil(
              context,
              PageTransition(type: PageTransitionType.fade, child: HotelUI()),
              (route) => false));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/splashScreen.jpg',
              ),
              fit: BoxFit.cover,

              // colorFilter: ColorFilter.mode(
              //   // ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.3),
              //   BlendMode.hardLight,
              // ),
            ),
          ),
        ),
        Container(
          height: 0,
          child: Image.asset(
            'assets/plane.webp',
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(colors: [
        //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.3),
        //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.3),
        //   ])),
        // ),
      ]),
    );
  }
}
