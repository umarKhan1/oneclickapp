// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/src/provider.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:oneclicktravel/Model/selectedHotelData.dart';
import 'package:oneclicktravel/app_bar_search.dart';
import 'package:oneclicktravel/backend_files/hotel_data.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/screens/trendingSearchHotel.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

class SearchFromHotel extends StatefulWidget {
  const SearchFromHotel({Key? key}) : super(key: key);

  @override
  _SearchFromHotelState createState() => _SearchFromHotelState();
}

class _SearchFromHotelState extends State<SearchFromHotel> {
  List<dynamic> data = [];
  String? textValue;
  Timer? timeHandle;
  var show = true;
  var searching = true;
  var listshow = false;
  var selectValue = "";

  void textChanged(String val) {
    setState(() {
      print('pressed ----------- $val');
      searching = false;

      listshow = true;
    });
    textValue = val;

    timeHandle = Timer(const Duration(microseconds: 500), () async {
      List<dynamic> data1 = await HotelData().getHotelData(textValue);
      print('i got listof dynamic here---- ' + data.toString());
      setState(() {
        searching = true;
        data = data1;
        print('response-------' + data.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // timeHandle!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBarSearch(
            textChangedRef: textChanged, appbarTitle: "Destination"),
        body: Visibility(
            visible: show,
            child: searching == false
                ? const Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  )
                : listshow == true
                    ? ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                          height: 0,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) => ListTile(
                            contentPadding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal! * 4),
                            dense: true,
                            onTap: () async {
                              context.read<SelectedHotelData>().setHotelData(
                                  data[index]["regionid"],
                                  data[index]["latinFullName"],
                                  data[index]["CountryCode"]);

                              Navigator.pop(context);
                            },
                            title: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FaIcon(
                                    LineIcons.city,
                                    color: ColorCodeGen.colorFromHex('#000000'),
                                  ),
                                ),
                                SizedBox(
                                    width: SizeConfig.blockSizeHorizontal! * 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        data[index]["latinFullName"].toString(),
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: ColorCodeGen.colorFromHex(
                                                  '#000000'),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: .5,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      //:Container(),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                    : const TrendingSearchesHotels()));
  }
}
