import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:oneclicktravel/backend_files/flight_data.dart';
import 'package:oneclicktravel/screens/trendingSearchFlight.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

import '../app_bar_search.dart';

class SearchFrom extends StatefulWidget {
  @override
  _SearchFromState createState() => _SearchFromState();
}

class _SearchFromState extends State<SearchFrom> {
  List<dynamic> data = [];
  String? textValue;
  Timer? timeHandle;
  var show = true;
  var searching = true;
  var listshow = false;
  var selectValue = "";

  void textChanged(String val) {
    setState(() {
      searching = false;
      listshow = true;
    });
    textValue = val;
    // show = true;

    timeHandle = Timer(Duration(microseconds: 500), () async {
      var data1 = await FlightData().getFlightData(textValue);
      if (this.mounted) {
        setState(() {
          searching = true;
          data = data1;
        });
      }
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

  List<String>? flightfromdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBarSearch(
          textChangedRef: textChanged,
          appbarTitle: "From",
        ),
        body: Visibility(
            visible: show,
            child: searching == false
                ? Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  )
                : listshow == true
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 0,
                          color: Colors.grey.shade400,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) => ListTile(
                            // padding: EdgeInsets.all(8.0),
                            contentPadding: EdgeInsets.only(left: 3),

                            // dense: true,
                            onTap: () async {
                              HapticFeedback.vibrate();

                              String destfromname =
                                  data[index]["city_fullname"];
                              String destfromcode =
                                  data[index]["code"].toString();

                              flightfromdata = [destfromname, destfromcode];
                              print('serach from' + flightfromdata.toString());
                              Navigator.pop(context, flightfromdata);
                            },
                            title: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      width: 55,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0,
                                            right: 6.0,
                                            top: 2,
                                            bottom: 2),
                                        child: Text(
                                          data[index]["code"],
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color:
                                                    ColorCodeGen.colorFromHex(
                                                        '#0000000'),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: .5,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )),
                                ),

                                //    SizedBox(width: 20),

                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          data[index]["city_fullname"]
                                              .toString(),
                                          overflow: TextOverflow.visible,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color:
                                                    ColorCodeGen.colorFromHex(
                                                        '#0000000'),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: .5,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Text(
                                          data[index]["name"].toString(),
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.normal,
                                                // letterSpacing: .5,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        //:Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      )
                    : TrendingSearchesFlights(
                        trendingFlightFromORTo: 'trendingFlightFrom')));
  }
}
