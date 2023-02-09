import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oneclicktravel/Model/trendingFlight.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

class TrendingSearchesFlights extends StatefulWidget {
  final String trendingFlightFromORTo;
  TrendingSearchesFlights({Key? key, required this.trendingFlightFromORTo})
      : super(key: key);

  @override
  _TrendingSearchesFlightsState createState() =>
      _TrendingSearchesFlightsState();
}

class _TrendingSearchesFlightsState extends State<TrendingSearchesFlights> {
  List<TrendingAirportsDataModel>? objectRef;
  List<TrendingAirportsDataModel> parseJson(String responseBody) {
    final parsed = json.decode(responseBody);
    log(parsed.toString());
    log('json format ho gya');
    return TrendingAirportsModel().fromJson(parsed['airports']);
  }

  final String trendingAirports = '''
  {
    "airports": [
    {
      "city_fullname": "Delhi,India",
      "code": "DEL",
      "CountryCode": "IN",
      "CityCode": "DEL",
      "CityName": "Delhi",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Indira Gandhi International Airport",
      "CountryName": "India"
    },
   {
      "city_fullname": "Mumbai,India",
      "code": "BOM",
      "CountryCode": "IN",
      "CityCode": "BOM",
      "CityName": "Mumbai",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Chhatrapati Shivaji International Airport",
      "CountryName": "India"
    },
     {
      "city_fullname": "Goa,India",
      "code": "GOI",
      "CountryCode": "IN",
      "CityCode": "GOI",
      "CityName": "Goa",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Dabolim Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Mexico City,Mexico",
      "code": "MEX",
      "CountryCode": "MX",
      "CityCode": "MEX",
      "CityName": "Mexico City",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Mexico City Juarez International Airport",
      "CountryName": "Mexico"
    },
   {
      "city_fullname": "Bangkok,Thailand",
      "code": "BKK",
      "CountryCode": "TH",
      "CityCode": "BKK",
      "CityName": "Bangkok",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Bangkok Suvarnabhumi International Airport",
      "CountryName": "Thailand"
    },
   {
      "city_fullname": "Bengaluru,India",
      "code": "BLR",
      "CountryCode": "IN",
      "CityCode": "BLR",
      "CityName": "Bengaluru",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Kempegowda International Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Pune,India",
      "code": "PNQ",
      "CountryCode": "IN",
      "CityCode": "PNQ",
      "CityName": "Pune",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Pune Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Hyderabad,India",
      "code": "HYD",
      "CountryCode": "IN",
      "CityCode": "HYD",
      "CityName": "Hyderabad",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Rajiv Gandhi International Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Kolkata,India",
      "code": "CCU",
      "CountryCode": "IN",
      "CityCode": "CCU",
      "CityName": "Kolkata",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Netaji Subhas Chandra Bose Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Chennai,India",
      "code": "MAA",
      "CountryCode": "IN",
      "CityCode": "MAA",
      "CityName": "Chennai",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Chennai Airport",
      "CountryName": "India"
    },
    {
      "city_fullname": "Dubai Airport,United Arab Emirates",
      "code": "DXB",
      "CountryCode": "AE",
      "CityCode": "DXB",
      "CityName": "Dubai Airport",
      "search_type": "1",
      "PopularSearchCount": "",
      "name": "Dubai International Airport",
      "CountryName": "United Arab Emirates"
    }
  ]
}'''; // local json string

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    objectRef = parseJson(trendingAirports);
    log('after getting object of model');
    log(objectRef![0].name.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 0,
        color: Colors.grey.shade400,
      ),
      itemCount: objectRef!.length,
      itemBuilder: (context, index) => Column(
        children: [
          index == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    // height: 25,
                    width: SizeConfig.blockSizeHorizontal! * 100,
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal! * 7),
                      child: Row(
                        children: [
                          FaIcon(
                            Icons.trending_up_sharp,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 10,
                          ),
                          Text(
                            'TRENDING SEARCHES',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          ListTile(
              // padding: EdgeInsets.all(8.0),
              contentPadding: EdgeInsets.only(left: 3),

              // dense: true,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                if (widget.trendingFlightFromORTo == 'trendingFlightFrom') {
                  // ==========================

                  prefs.setString(
                      "flight_from", objectRef![index].cityfullName.toString());

                  prefs.setString(
                      'flight_code', (objectRef![index].code.toString()));

                  prefs.setString('flight_isDomestic_from',
                      (objectRef![index].countryName.toString()));

                  print('flight_code from setted-----------' +
                      prefs.getString("flight_code")!);

                  String destfromname =
                      objectRef![index].cityfullName.toString();
                  String destfromcode = objectRef![index].code.toString();

                  List<String> flightfromdata = [destfromname, destfromcode];
                  print('serach from' + flightfromdata.toString());
                  Navigator.pop(context, flightfromdata);
                } else {
                  prefs.setString(
                      "flight_to", objectRef![index].cityfullName.toString());

                  prefs.setString(
                      'flight_code_to', (objectRef![index].code.toString()));
                  prefs.setString('flight_isDomestic_to',
                      (objectRef![index].countryName.toString()));
                  print('flight_code from setted-----------' +
                      prefs.getString("flight_code_to")!);

                  String destfromname =
                      objectRef![index].cityfullName.toString();
                  String destfromcode = objectRef![index].code.toString();

                  List<String> flighttodata = [destfromname, destfromcode];
                  print(flighttodata);
                  Navigator.pop(context, flighttodata);
                }
              },
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(2)),
                        width: 55,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6.0, right: 6.0, top: 2, bottom: 2),
                          child: Text(
                            objectRef![index].code.toString(),
                            // data[index]["code"],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: ColorCodeGen.colorFromHex('#0000000'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            objectRef![index].cityfullName.toString(),
                            // data[index]["city_fullname"].toString(),
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: ColorCodeGen.colorFromHex('#0000000'),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          Text(
                            objectRef![index].name.toString(),
                            // data[index]["name"].toString(),
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
        ],
      ),
    );
  }
}
