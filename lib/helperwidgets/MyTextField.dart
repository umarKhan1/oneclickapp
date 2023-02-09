import 'package:google_fonts/google_fonts.dart';
import 'package:oneclicktravel/Model/FetchUpdateCustomerDetails.dart';
import 'package:oneclicktravel/SelectCountry.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MyTextField extends StatelessWidget {
  final labelText, controller;

  final keyboardtype;
  const MyTextField(
      {Key? key, this.labelText, this.controller, this.keyboardtype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        // keyboardAppearance: ,
        autofocus: false,
        controller: controller,
        keyboardType: this.keyboardtype,

        // onChanged: _serachContact,
        onTap: () async {
          if (labelText == 'Country') {
            controller.text = await Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SelectCountry(
                    customerprofile: 'customerprofile',
                    lastSelectedCountry: context
                        .read<FetchUpdateCustomerDetails>()
                        .countryCode
                        .toString());
              },
              // transitionDuration: Duration(milliseconds: 500),
              // reverseTransitionDuration: Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // return SharedAxisTransition(
                //     child: child,
                //     animation:
                //         CurvedAnimation(curve: Curves.decelerate, parent: animation),
                //     secondaryAnimation: secondaryAnimation,
                //     transitionType: SharedAxisTransitionType.vertical);
                return new FadeTransition(
                    opacity: CurvedAnimation(
                        curve: Curves.decelerate, parent: animation),
                    child: child);
                // return RotationTransition(
                //   turns: animation,
                //   child: child,
                // );
              },
            ));
            // FocusScope.of(context).unfocus();
          }
        },
        // onChanged: ,
        validator: (value) {
          // switch (type) {
          //   case 0:
          //     if (value.isEmpty) {
          //       return errorText;
          //     }
          //     // else if (_controlller.text.length != 10) {
          //     //   return 'Customer ID must be of 10 digit.';
          //     // }
          //     break;
          //   case 1:
          //     if (value.isEmpty) {
          //       return errorText;
          //     }
          //     break;
          // }

          return null;
        },
        onSaved: (value) {
          // switch (type) {
          //   case 0:
          //     // if(){

          //     // }
          //     // log(type.toString());
          //     break;
          //   case 1:
          //     // log('amount clicked');
          //     break;
          // }
          print('value is going to be save =========' + value!);
        },

        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: labelText == "Email" ? Colors.grey : Colors.black)),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        enabled: labelText == "Email" ? false : true,
        maxLines: 1,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            suffixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
            contentPadding: EdgeInsets.all(0),
            labelText: this.labelText,
            hintText: controller.text),
      ),
    );
  }
}
