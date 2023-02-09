import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:oneclicktravel/CountryCurrencyScreen.dart';
import 'package:oneclicktravel/CountryNameFlagScreen.dart';

import 'package:oneclicktravel/utils/color_code_generator.dart';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deviceType/SizeConfig.dart';

class SettingScreen extends StatefulWidget {
  // SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? clickedCurrencyStatus = false;
  bool? clickedCountryFlagStatus = false;
  late SharedPreferences prefs;
  String? user;
  String? selectedCurrencyCode = 'INR';
  String? selectedCountryCode = 'IN';
  String? selectedCountryFlag =
      'https://abengines.com/api/country-list/images/country-flag/flags-medium/in.png';
  @override
  void initState() {
    super.initState();

    getUserSigninInfo();
    getLastSelectedCountryCurrency();
  }

  void getLastSelectedCountryCurrency() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_country_flag') != null &&
        prefs.getString('selected_country_code') != null &&
        prefs.getString('selected_currency_code') != null) {
      setState(() {
        selectedCountryFlag = prefs.getString('selected_country_flag');
        selectedCountryCode = prefs.getString('selected_country_code');
        selectedCurrencyCode = prefs.getString('selected_currency_code');
      });
    }
  }

  void getUserSigninInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString("signInUser");
    });
    print('user==================' + user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical! * 7,
            color: ColorCodeGen.colorFromHex('#ffd022').withOpacity(.2),
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 7,
                  top: SizeConfig.blockSizeVertical! * 2.2),
              child: Text(
                "Region / Currencies",
                style: TextStyle(
                    color: ColorCodeGen.colorFromHex('#ffd022'), fontSize: 15),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              HapticFeedback.vibrate();
              // Navigator.pop(context);
              clickedCountryFlagStatus = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CountryFlagName(),
                  ));
              prefs = await SharedPreferences.getInstance();
              if (clickedCountryFlagStatus == true) {
                setState(() {
                  selectedCountryFlag =
                      prefs.getString('selected_country_flag');
                  selectedCountryCode =
                      prefs.getString('selected_country_code');
                  selectedCurrencyCode =
                      prefs.getString('selected_currency_code');
                });
                Fluttertoast.showToast(
                  msg: "Country and Currency Updated",
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical! * 8,
              // color: Colors.red,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 7,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        // color:
                        //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                        color: Colors.blue[500],
                      ),
                      width: 25,
                      height: 25,
                      // color:
                      //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                      child: Center(
                        child: Icon(
                          Icons.flag,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 7,
                    ),
                    Text('Country', style: TextStyle(fontSize: 15)),
                    // SizedBox(
                    //   width: SizeConfig.blockSizeHorizontal * 30,
                    // ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Container(
                      width: 35,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.blueGrey[100]!),
                        // color:
                        //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                        // color: Colors.blue[500],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            selectedCountryFlag!,
                          ),
                        ),
                      ),

                      // color:
                      //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                    ),
                    Text(' ' + selectedCountryCode!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[300],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              HapticFeedback.vibrate();
              clickedCurrencyStatus = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: CountryCurrency(),
                ),
              );
              prefs = await SharedPreferences.getInstance();
              if (clickedCurrencyStatus == true) {
                setState(() {
                  selectedCurrencyCode =
                      prefs.getString('selected_currency_code');
                });
                print(selectedCurrencyCode);
                Fluttertoast.showToast(
                  msg: "Currency Updated",
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical! * 8,
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 7,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.red.withOpacity(0.7),
                      ),
                      width: 25,
                      height: 25,
                      // color:
                      //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.dollarSign,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 7,
                    ),
                    Text(
                      'Currency',
                      style: TextStyle(fontSize: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    // SizedBox(
                    //   width: SizeConfig.blockSizeHorizontal * 30,
                    // ),
                    Text(selectedCurrencyCode!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 2,
                    ),
                    Text('()',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[300],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical! * 7,
            color: ColorCodeGen.colorFromHex('#ffd022').withOpacity(.2),
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 7,
                  top: SizeConfig.blockSizeVertical! * 2.2),
              child: Text(
                "General",
                style: TextStyle(
                    color: ColorCodeGen.colorFromHex('#ffd022'), fontSize: 15),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.vibrate();
              AppSettings.openNotificationSettings();
            },
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical! * 8,
              // color: Colors.red,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 7,
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: ColorCodeGen.colorFromHex('#ffd022')
                            .withOpacity(0.6),
                      ),
                      width: 25,
                      height: 25,
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 7,
                    ),
                    Text(
                      'Notification',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider(),
          Expanded(
            child: Container(),
            flex: 10,
          ),
        ],
      ),
    );
  }
}
