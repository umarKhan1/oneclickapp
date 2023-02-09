
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButtonHelperWidget extends StatelessWidget {
  final titleX, widthx, heightX, colorx, radiusX;
  final Function? onPressedFunction;
  MyButtonHelperWidget(
      {Key? key,
      this.titleX,
      this.onPressedFunction,
      this.widthx,
      this.heightX,
      this.colorx,
      this.radiusX})
      : super(key: key);

  @override
  Widget build(context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(widthx, heightX),
            primary: colorx,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusX)),
            onSurface: colorx),
        onPressed: () {
          onPressedFunction!();
        },
        child: Text(titleX,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 16),
            )));
  }
}
