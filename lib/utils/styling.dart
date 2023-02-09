import 'package:flutter/material.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';

class AppTheme {
  AppTheme._();

  static Color subTitleTextColor = Colors.white;

  static final ThemeData mobileTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: mobileTextTheme,
  );
  static final ThemeData tabletTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: tabletTextTheme,
  );

  static final TextTheme mobileTextTheme = TextTheme(
    subtitle1: _subTitleMobile1,
    bodyText2: _subTitleMobile2,
  );
  static final TextTheme tabletTextTheme = TextTheme(
    subtitle1: _subTitletablet1,
    bodyText2: _subTitletablet2,
  );

  static final TextStyle _subTitleMobile1 = TextStyle(
    color: Colors.white,
    fontSize: 2.5 * SizeConfig.textMultiplier!,
    // height: 1.5,
  );
  static final TextStyle _subTitleMobile2 = TextStyle(
    color: Colors.white,
    fontSize: 2 * SizeConfig.textMultiplier!,
    // height: 1.5,
  );

  static final TextStyle _subTitletablet1 = TextStyle(
    color: Colors.white,
    fontSize: 1.5 * SizeConfig.textMultiplier!,
    // height: 1.5,
  );
  static final TextStyle _subTitletablet2 = TextStyle(
    color: Colors.white,
    fontSize: 1.2 * SizeConfig.textMultiplier!,
    // height: 1.5,
  );
}
