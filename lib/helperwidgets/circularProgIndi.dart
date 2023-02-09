import 'package:flutter/material.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

class CircularProgIndicator extends StatelessWidget {
  const CircularProgIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 80,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              ColorCodeGen.colorFromHex('#0e3957')),
        ),
      ),
    );
  }
}
