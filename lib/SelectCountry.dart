import 'dart:developer';

import 'package:oneclicktravel/Model/FetchUpdateCustomerDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneclicktravel/Model/CountryListModel.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'deviceType/SizeConfig.dart';

class SelectCountry extends StatefulWidget {
  final String? lastSelectedCountry, customerprofile;
  SelectCountry({this.lastSelectedCountry, this.customerprofile});
  // final hotelimageURLList;
  // final hotelImageIndex;
  // int currentHotelIndex = 1;
  // SelectCountry(this.hotelimageURLList, this.hotelImageIndex);
  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final CountryListModel countryListModel = new CountryListModel();
  late List filteredList;
  // List countryListData = [];
  // List selectedCountryOntap = [];
  String? lastSelectedCountry;
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();

    filteredList = countryListModel.countryList;
    lastSelectedCountry = widget.lastSelectedCountry!.toLowerCase();
  }

  TextStyle selectCountryStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        color: Colors.black54,
        // color: ColorCodeGen.colorFromHex('#186900'),
        fontWeight: FontWeight.normal,
        letterSpacing: .5,
        // fontWeight: FontWeight.bold,
        fontSize: 14),
  );
  @override
  Widget build(BuildContext context) {
    log('running build ==========');
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(
        //   Icons.clear,
        //   color: Colors.black,
        // ),
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),

        title: Text(
          'Country/Region',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.white,
                // color: ColorCodeGen.colorFromHex('#186900'),
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
                // fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          returnMyCountrySearchBox(),
          // Container(
          //   height: 60,
          //   color: Colors.grey[400],
          // ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              // dragStartBehavior: DragStartBehavior.down,
              shrinkWrap: true,
              itemCount: filteredList.length + 4,
              itemBuilder: (context, index) {
                return index == 0
                    ? returnTitleHeading('Suggested country/region')
                    : index == 1
                        ? returnSuggestedCountry(context,
                            countryListModel.countryList.elementAt(98), index)
                        : index == 2
                            ? returnSuggestedCountry(
                                context,
                                countryListModel.countryList.elementAt(229),
                                index)
                            : index == 3
                                ? returnTitleHeading('All Countries/Regions')
                                : Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ListTile(
                                          // dense: true,
                                          // contentPadding: EdgeInsets.symmetric(vertical: 0),
                                          // isThreeLine: true,
                                          visualDensity: VisualDensity.compact,
                                          onTap: () async {
                                            setState(() {
                                              lastSelectedCountry = filteredList
                                                      .elementAt(index - 4)[
                                                  'country_code'];
                                            });
                                            if (widget.customerprofile ==
                                                'customerprofile') {
                                              context
                                                  .read<
                                                      FetchUpdateCustomerDetails>()
                                                  .countryCode = filteredList
                                                      .elementAt(index - 4)[
                                                  'country_code'];

                                              context
                                                  .read<
                                                      FetchUpdateCustomerDetails>()
                                                  .countryName = filteredList
                                                      .elementAt(index - 4)[
                                                  'country_name'];
                                              Navigator.pop(
                                                  context,
                                                  filteredList.elementAt(index -
                                                      4)['country_name']);
                                            } else {
                                              Navigator.pop(
                                                  context,
                                                  filteredList
                                                      .elementAt(index - 4));
                                            }
                                          },
                                          // contentPadding: EdgeInsets.zero,
                                          // leading: Icon(FontAwesomeIcons.solidFlag),
                                          // tileColor: Colors.pink,
                                          title: Text(
                                              filteredList
                                                  .elementAt(
                                                      index - 4)['country_name']
                                                  .toString(),
                                              style: selectCountryStyle),
                                          trailing: filteredList
                                                      .elementAt(index - 4)[
                                                          'country_code']
                                                      .toLowerCase() ==
                                                  lastSelectedCountry!
                                                      .toLowerCase()
                                              ? Icon(
                                                  Icons.check,
                                                  color:
                                                      ColorCodeGen.colorFromHex(
                                                          '#189600'),
                                                )
                                              : SizedBox()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: Divider(
                                          height: 0,
                                          thickness: 1,
                                        ),
                                      )
                                    ],
                                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchCountry(String value) {
    setState(() {
      filteredList = countryListModel.countryList
          .where((i) => i['country_name']
              .toString()
              .trim()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  returnMyCountrySearchBox() {
    return Container(
      color: Colors.grey[400],
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(3)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: SizeConfig.blockSizeHorizontal! * 100,
          height: SizeConfig.blockSizeVertical! * 7,
          child: Padding(
            padding: EdgeInsets.only(
              left: 5.0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_sharp,
                  color: Colors.black,
                  size: 32,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal! * 75,
                  // height: SizeConfig.blockSizeVertical * 7,
                  // margin: EdgeInsets.only(left: 10.0, right: 0.0),
                  child: TextField(
                    cursorColor: ColorCodeGen.colorFromHex('#2b97b0'),
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    onChanged: searchCountry,

                    // autofocus: true,
                    decoration: InputDecoration(
                      fillColor: Colors.green,
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.black54,
                              // color: ColorCodeGen.colorFromHex('#186900'),
                              fontWeight: FontWeight.normal,
                              letterSpacing: .5,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      hintText: 'Enter the country/region name',
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  returnTitleHeading(String title) {
    return Container(
      height: 30,
      color: Colors.grey[200],
      width: SizeConfig.blockSizeHorizontal! * 100,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal! * 5, vertical: 5),
        child: Text(
          title,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.black54,
                  // color: ColorCodeGen.colorFromHex('#186900'),
                  fontWeight: FontWeight.normal,
                  letterSpacing: .5,
                  // fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ),
      ),
    );
  }

  returnSuggestedCountry(
      BuildContext context, Map suggestedCountry, int index) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListTile(
            // dense: true,
            // contentPadding: EdgeInsets.symmetric(vertical: 0),
            // isThreeLine: true,
            visualDensity: VisualDensity.compact,
            onTap: () {
              if (widget.customerprofile == 'customerprofile') {
                context.read<FetchUpdateCustomerDetails>().countryCode =
                    suggestedCountry['country_code'];
                context.read<FetchUpdateCustomerDetails>().countryName =
                    suggestedCountry['country_name'];
                Navigator.pop(context, suggestedCountry['country_name']);
              } else {
                Navigator.pop(context, suggestedCountry);
              }
            },
            // contentPadding: EdgeInsets.zero,
            // leading: Icon(FontAwesomeIcons.solidFlag),
            // tileColor: Colors.pink,
            title: Text(
              suggestedCountry['country_name'].toString(),
              style: selectCountryStyle,
            ),
            trailing: suggestedCountry['country_code'].toLowerCase() ==
                    lastSelectedCountry!.toLowerCase()

                // lastSelectedCountry == suggestedCountry.key
                ? Icon(
                    Icons.check,
                    color: ColorCodeGen.colorFromHex('#189600'),
                  )
                : SizedBox()),
        index == 1
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Divider(
                  height: 0,
                  thickness: 1,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
