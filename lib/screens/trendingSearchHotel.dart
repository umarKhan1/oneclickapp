import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import 'package:provider/src/provider.dart';

import 'package:oneclicktravel/Model/selectedHotelData.dart';
import 'package:oneclicktravel/Model/trendingHotel.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

class TrendingSearchesHotels extends StatefulWidget {
  const TrendingSearchesHotels({
    Key? key,
  }) : super(key: key);

  @override
  _TrendingSearchesHotelsState createState() => _TrendingSearchesHotelsState();
}

class _TrendingSearchesHotelsState extends State<TrendingSearchesHotels> {
  List<TrendingHotelsDataModel>? objectRef;
  List<TrendingHotelsDataModel> parseJson(String responseBody) {
    final parsed = json.decode(responseBody);
    log(parsed.toString());
    log('json format ho gya');
    return TrendingHotelsModel().fromJson(parsed['cities']);
  }

  final String trendingAirports = '''
  {
   "cities": [
   {
      "latinFullName": "Delhi,India",
      "regionid": "130443",
      "CountryCode": "IN",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Delhi,Canada",
      "regionid": "105477",
      "CountryCode": "CA",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Delhi,United States of America",
      "regionid": "116067",
      "CountryCode": "US",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    
    {
      "latinFullName": "Manali,India",
      "regionid": "126388",
      "CountryCode": "IN",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Bali,Cameroon",
      "regionid": "149598",
      "CountryCode": "CM",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Balingen,Germany",
      "regionid": "110761",
      "CountryCode": "DE",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Bali,Greece",
      "regionid": "144077",
      "CountryCode": "GR",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
    {
      "latinFullName": "Bali,Indonesia",
      "regionid": "110670",
      "CountryCode": "ID",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    },
   {
      "latinFullName": "Dubai,United Arab Emirates",
      "regionid": "115936",
      "CountryCode": "AE",
      "category": "cities",
      "class_Name": "cities",
      "search_type": "1"
    }

  ]
}'''; // local json string

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    objectRef = parseJson(trendingAirports);
    log('after getting object of model');
    log(objectRef![0].latinFullName.toString());
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
                          horizontal: SizeConfig.blockSizeHorizontal! * 4),
                      child: Row(
                        children: [
                          const FaIcon(
                            Icons.trending_up_sharp,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 4,
                          ),
                          const Text('TRENDING SEARCHES',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          ListTile(
              // padding: EdgeInsets.all(8.0),
              contentPadding: const EdgeInsets.only(left: 3),

              // dense: true,
              onTap: () async {
                await context.read<SelectedHotelData>().setHotelData(
                    objectRef![index].locationId,
                    objectRef![index].latinFullName,
                    objectRef![index].countryCode);

                // log('==================hotel city name trending' +
                //     context.read<SelectedHotelData>().hotelCityName.toString());

                log('==================hotel hotelCountryName name trending' +
                    context
                        .read<SelectedHotelData>()
                        .hotelCountryName
                        .toString());

                Navigator.pop(context);
              },
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      LineIcons.city,
                      color: ColorCodeGen.colorFromHex('#0000000'),
                    ),
                  ),

                  //    SizedBox(width: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          objectRef![index].latinFullName.toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: ColorCodeGen.colorFromHex('#0000000'),
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
