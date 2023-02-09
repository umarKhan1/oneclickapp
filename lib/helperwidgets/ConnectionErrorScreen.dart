import 'package:flutter/material.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:lottie/lottie.dart';

class ConnectionErrorScreen extends StatelessWidget {
  const ConnectionErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: SizeConfig.blockSizeVertical! * 30,
              child: Lottie.asset(
                'assets/lottieAnimations/lf30_editor_3f3sqsf7.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // color: Colors.red,
            child: Text(
              'OOPs! Please Check Your Internet Connection',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorCodeGen.colorFromHex('#115796')),
            ),
          ),
        ],
      ),
    );
  }
}
