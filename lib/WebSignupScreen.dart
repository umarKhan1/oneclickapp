import 'dart:convert';
import 'dart:developer';

import 'package:oneclicktravel/Model/login_signup/signup.dart';
import 'package:oneclicktravel/helperwidgets/MyButtonHelperWidget.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:oneclicktravel/SelectCountry.dart';

import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:oneclicktravel/utils/color_code_generator.dart';

class WebSignupScreen extends StatefulWidget {
  WebSignupScreen({Key? key}) : super(key: key);

  @override
  _WebSignupScreenState createState() => _WebSignupScreenState();
}

class _WebSignupScreenState extends State<WebSignupScreen> {
  TextStyle fontstyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.white, fontSize: 16),
  );
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controlllerCountry, _isdCountryCode;
  late SignUp signupUserObject;
  String? _countryCode;
  @override
  void initState() {
    // TODO: implement initState
    _controlllerCountry = TextEditingController();
    _isdCountryCode = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer Sign Up",
              style:
                  fontstyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Register with us to avail hidden deals!:",
              style: fontstyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   width: SizeConfig.blockSizeHorizontal * 100,
                //   height: SizeConfig.blockSizeVertical * 30,
                //   child: SvgPicture.asset("assets/help_support.svg",
                //       fit: BoxFit.cover),
                // ),
                Container(
                  width: SizeConfig.blockSizeHorizontal! * 100,
                  height: SizeConfig.blockSizeVertical! * 40,
                  child: Lottie.asset(
                    'assets/lottieAnimations/50124-user-profile.json',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Flexible(
                      child: helpSupportInput(
                        0,
                        'First Name ',
                        '',
                        'First Name is Required.',
                        '',
                        'Enter First Name',
                        TextInputType.name,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: helpSupportInput(
                        1,
                        'Last Name ',
                        '',
                        'Last Name is Required.',
                        '',
                        'Enter Last Name',
                        TextInputType.name,
                      ),
                    ),
                  ],
                ),

                helpSupportInput(
                  2,
                  'Email ',
                  '',
                  'Email is Required.',
                  '',
                  'Enter Email',
                  TextInputType.emailAddress,
                ),
                helpSupportInput(
                  3,
                  'Address ',
                  '',
                  'Address is Required.',
                  '',
                  'Enter Address',
                  TextInputType.streetAddress,
                ),

                Row(
                  children: [
                    Flexible(
                      child: helpSupportInput(
                        4,
                        'City ',
                        '',
                        'City is Required.',
                        '',
                        'Enter City',
                        TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: helpSupportInput(
                        5,
                        'Postal Code',
                        '',
                        'Postal Code is Required.',
                        '',
                        'Enter Postal Code',
                        TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: helpSupportInput(
                        6,
                        'State/Province/Region',
                        '',
                        'State/Province/Region is Required.',
                        '',
                        'Enter State/Province/Region',
                        TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          Map<String, dynamic>? selectedCountryEntrySignup =
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SelectCountry(
                                            lastSelectedCountry: 'xyz123',
                                          )));

                          if (selectedCountryEntrySignup != null) {
                            _controlllerCountry!.text =
                                selectedCountryEntrySignup['country_name']
                                    .toString();
                            _isdCountryCode!.text =
                                selectedCountryEntrySignup['isd_code']
                                    .toString();

                            _countryCode =
                                selectedCountryEntrySignup['country_code']
                                    .toString();
                          }
                        },
                        child: helpSupportInput(
                          7,
                          'Country',
                          '',
                          'Country is Required.',
                          '',
                          'Select Country',
                          TextInputType.streetAddress,
                          controlller: _controlllerCountry,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: helpSupportInput(
                          8,
                          'ISD Code',
                          '',
                          'ISD Code is Required.',
                          '',
                          'Select ISD Code',
                          TextInputType.number,
                          controlller: _isdCountryCode),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 2,
                      child: helpSupportInput(
                        9,
                        'Mobile Number',
                        '',
                        'Mobile Number is Required.',
                        '',
                        'Enter Mobile Number',
                        TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                helpSupportInput(
                  10,
                  'Password',
                  '',
                  'Password is Required.',
                  '',
                  'Enter Password',
                  TextInputType.visiblePassword,
                ),
                helpSupportInput(
                  11,
                  'Confirm Password',
                  '',
                  'Confirm Password is Required.',
                  '',
                  'Enter Confirm Password',
                  TextInputType.visiblePassword,
                ),

                // Spacer(),
                sinupLoader == false
                    ? MyButtonHelperWidget(
                        titleX: 'SUBMIT',
                        onPressedFunction: onPressedFunction,
                        widthx: SizeConfig.blockSizeHorizontal! * 95,
                        heightX: SizeConfig.blockSizeVertical! * 6.5,
                        colorx: ColorCodeGen.colorFromHex('#0e3957'),
                        radiusX: 2.0)
                    : Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorCodeGen.colorFromHex('#0e3957')),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var pass;
  Widget helpSupportInput(
      int type,
      String labelText,
      String helperText,
      String errorText,
      String suffixText,
      String hintText,
      TextInputType textInputType,
      {TextEditingController? controlller}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        // keyboardAppearance: ,
        autofocus: false,
        controller: controlller,
        keyboardType: textInputType,
        enabled: type == 7 ? false : true,
        // onChanged: _serachContact,
        onTap: () async {},
        // onChanged: ,
        validator: (value) {
          switch (type) {
            case 0:
              if (value!.isEmpty) {
                return errorText;
              }

              break;
            case 1:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 2:
              if (value!.isEmpty) {
                return errorText;
              }

              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value)) {
                return 'Please a valid Email';
              }
              break;
            case 3:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 4:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 5:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 6:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 7:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 8:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 9:
              if (value!.isEmpty) {
                return errorText;
              }
              break;
            case 10:
              if (value!.isEmpty) {
                return errorText;
              }
              if (value.length < 5) {
                return 'Password length should be greater than 5';
              }
              pass = value;
              break;
            case 11:
              if (value!.isEmpty) {
                return errorText;
              }
              if (value.length < 5) {
                return 'Confirm Password length should be greater than 5';
              }
              if (value.toString().trim() != pass.toString().trim()) {
                return 'Password should be match.';
              }
              break;
          }

          return null;
        },
        onSaved: (value) {
          switch (type) {
            case 0:
              log('index 0');
              signupUserObject.fname = value;
              break;
            case 1:
              log('index 1');
              signupUserObject.lname = value;

              break;
            case 2:
              log('index 2');
              signupUserObject.email = value;
              break;
            case 3:
              log('index 3');
              signupUserObject.address = value;

              break;
            case 4:
              log('index 4');
              signupUserObject.city = value;

              break;
            case 5:
              log('index 5');
              signupUserObject.postalcode = value;

              break;
            case 6:
              log('index 6');
              signupUserObject.state = value;

              break;
            case 7:
              log('index 7');
              signupUserObject.country = value;

              break;
            case 8:
              log('index 8');
              signupUserObject.isdcode = value;

              break;
            case 9:
              log('index 9');
              signupUserObject.phone = value;

              break;
            case 10:
              log('index 10');
              signupUserObject.pass = value;

              break;
            case 11:
              log('index 11');
              signupUserObject.cpass = value;

              break;
          }
          print('value is going to be save =========' + value!);
        },
        style: fontstyle.copyWith(
            fontWeight: FontWeight.normal, color: Colors.black),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,

        maxLines: 1,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              child: Text(
                suffixText,
                style: fontstyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            helperText: helperText,
            helperMaxLines: 2,
            suffixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
            contentPadding: EdgeInsets.all(0),
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }

  bool sinupLoader = false;
  void onPressedFunction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        sinupLoader = true;
      });
      signupUserObject = SignUp();
      _formKey.currentState!.save();

      // signupUserObject = SignUp(fnameX, lnameX, emailX, addressX, cityX, postalcodeX, stateX, countryX, isdcodeX, phoneX, passX, cpassX)
      log('all well=========');
      log(signupUserObject.email!);

      var response = await sendSignupDataToServer();
      if (response.toString() == '1') {
        showResponseDialog(1);
      } else if (response.toString() == '0') {
        showResponseDialog(0);
      }
      setState(() {
        sinupLoader = false;
      });
    }
  }

  showResponseDialog(int i) {
    Dialogs.materialDialog(
      customView: Container(
        // color: Colors.green,
        padding: EdgeInsets.zero,
        height: 60,
        width: 60,
        child: Lottie.asset(
          i == 0
              ? 'assets/lottieAnimations/54117-invalid.json'
              : 'assets/lottieAnimations/68994-success.json',
          fit: BoxFit.contain,
        ),
      ),
      color: Colors.white,
      msg: i == 0 ? '''Email-id is already exist''' : '''SignUp Successfully''',
      title: i == 0 ? 'SignUp Failed' : 'SignUp Done',

      titleStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: i == 0 ? Colors.red : Colors.green,
              fontSize: 18)),
      msgStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black45,
              fontSize: 14)),
      // lottieBuilder: Lottie.asset(
      //   'assets/38213-error.json',
      //   fit: BoxFit.contain,
      // ),
      context: context,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(SizeConfig.blockSizeHorizontal! * 95,
                  SizeConfig.blockSizeVertical! * 5.5),
              primary: ColorCodeGen.colorFromHex('#0e3957'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSurface: ColorCodeGen.colorFromHex('#0e3957')),
          onPressed: () {
            Navigator.of(context).pop();
            if (i == 1) {
              Navigator.pop(context);
            }
          },
          child: Text('OK',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 18))),
          // color: ColorCodeGen.colorFromHex('#0e3957'),
          // textStyle: TextStyle(color: Colors.white),
          // iconColor: Colors.white,
        ),
      ],
    );
  }

  Future<dynamic> sendSignupDataToServer() async {
    var data;
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/customer-management/custom-ajax.php?action=RegisterMe&isautologin=Yes&pid=${Strings.app_pid}&pre_title=&first_name=${signupUserObject.fname}&last_name=${signupUserObject.lname}&email=${signupUserObject.email}&address=${signupUserObject.address}&city=${signupUserObject.city}&postal_code=${signupUserObject.postalcode}&state=${signupUserObject.state}&countryCode=$_countryCode&ext_phone=${signupUserObject.isdcode}&phone=${signupUserObject.phone}&password=${signupUserObject.pass}&password=${signupUserObject.cpass}";
    var response = await http.get(Uri.parse(url));
    if (response.body.toString().trim() == 'Email-id is already exist') {
      data = '0';
    } else {
      data = jsonDecode(response.body);
    }

    return data;
  }
}
