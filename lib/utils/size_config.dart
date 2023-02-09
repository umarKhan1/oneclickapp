
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double statusBarHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    statusBarHeight = _mediaQueryData.padding.top;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}
