import 'package:flutter/material.dart';

class SizeConfig {
  static double? screenWidth;
  static late double screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? statusBarHeight;
  static double? textMultiplier;
  static double? heightMultiplier;
  static double? imageMultiplier;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
    }

    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight / 100;

    textMultiplier = blockSizeVertical;
    heightMultiplier = blockSizeVertical;
    imageMultiplier = blockSizeHorizontal;

    print(blockSizeHorizontal);
    print(blockSizeVertical);
  }
}
