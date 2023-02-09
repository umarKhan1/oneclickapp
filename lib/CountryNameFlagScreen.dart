import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bar_search.dart';
import 'utils/color_code_generator.dart';
import 'utils/size_config.dart';

class CountryFlagName extends StatefulWidget {
  const CountryFlagName({Key? key}) : super(key: key);

  @override
  _CountryFlagNameState createState() => _CountryFlagNameState();
}

class _CountryFlagNameState extends State<CountryFlagName> {
  List<dynamic>? countryData = [];
  List<dynamic>? countryFullData = [];
  String urlCountryInfo =
      'https://www.abengines.com/api/country-list/get-country-code.php?action=getCountryList';
  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
  }

  getCountryInfo() {
    print('getCountryInfo called===');
    if (countryData!.length == 0) {
      return http.get(Uri.parse(urlCountryInfo));
    }
    return Future.value(0);
  }

  void searchCountry(String value) {
    print(value);
    setState(() {
      countryData = countryFullData!
          .where((i) => i['country_name']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBarSearch(
            textChangedRef: searchCountry, appbarTitle: "Country"),
        body: (countryData is List)
            ? FutureBuilder(
                future: getCountryInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is http.Response) {
                      countryData = jsonDecode(snapshot.data.body);
                      countryFullData = countryData;
                    }
                    return ListView.builder(
                      itemCount: countryData!.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          // Divider(),
                          InkWell(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              pref = await SharedPreferences.getInstance();

                              await pref.setString('selected_country_flag',
                                  countryData![index]['flag'].toString());
                              await pref.setString('selected_country_code',
                                  countryData![index]['country_code']);
                              await pref.setString('selected_currency_code',
                                  countryData![index]['code']);

                              Navigator.pop(context, true);
                            },
                            child: Container(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.blockSizeVertical * 7,
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
                                    left: SizeConfig.blockSizeHorizontal * 7,
                                  ),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border: Border.all(
                                              color: Colors.blueGrey[100]!),
                                          // color:
                                          //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                                          // color: Colors.blue[500],
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              countryData![index]['flag'],
                                            ),
                                          ),
                                        ),

                                        // color:
                                        //     ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 7,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          countryData![index]['country_name'],
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          // maxLines: 1,
                                        ),
                                      ),

                                      // SizedBox(
                                      //   width: SizeConfig.blockSizeHorizontal * 30,
                                      // ),

                                      // Divider(),
                                    ],
                                  ),
                                )),
                          ),
                          // Divider(),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      // backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
                      //  ColorCodeGen.colorFromHex('#ffd022'),
                      // value: 50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorCodeGen.colorFromHex('#ffd022')),
                    ));
                  }
                })
            : SizedBox());
  }
}
