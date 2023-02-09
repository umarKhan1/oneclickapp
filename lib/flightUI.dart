
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:oneclicktravel/customedate/CustomeDateScreen.dart';
import 'package:oneclicktravel/utils/ModuleName.dart';

import 'backend_files/search_from.dart';
import 'backend_files/search_to.dart';

import 'flight_detail.dart';
import 'utils/color_code_generator.dart';
import 'utils/size_config.dart';

// ignore: constant_identifier_names
enum SingingCharacter  {   Business, Economy }

class FlightUI extends StatefulWidget {
  @override
  _FlightUIState createState() => _FlightUIState();
}

class _FlightUIState extends State<FlightUI> {
  TextEditingController _destinationfrom = TextEditingController();
  TextEditingController _destinationfromcode = TextEditingController();
  TextEditingController _destinationto = TextEditingController();
  TextEditingController _destinationtocode = TextEditingController();
  TextEditingController departuredate = TextEditingController();
  TextEditingController returndate = TextEditingController();

  String? lastSelectedCurrency = 'INR';
  // var rooms;
  var children;
  var adults;
  var infant;

  var maxAdult = 9;
  var maxchildren = 9;
  var maxinfant = 9;

  bool adultAddButton = true;
  bool childrenAddButton = true;
  bool infantAddButton = true;

  bool adultMinusButton = false;
  bool childrenMinusButton = false;
  bool infantMinusButton = false;
  late String _passengers;
  var destination;
  // var cityid;
  var flightcodeFROM;
  var flightcodeTO;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<DateTime>? checkincheckoutdate;
  DateTime? flightonewayDategot;
  String? isDomestic;
  String? isDomesticFromData;
  String? isDomesticToData;
  @override
  void initState() {
    _destinationfrom.text = 'Delhi, India';
    _destinationfromcode.text = 'DEL';
    flightcodeFROM = 'DEL';
    isDomesticFromData = 'India';
    _destinationto.text = 'Benguluru, India';
    _destinationtocode.text = 'BLR';
    flightcodeTO = 'BLR';
    isDomesticToData = 'India';
    adults = 1;
    children = 0;
    infant = 0;

    _passengers = '$adults Adult';

    super.initState();
    getvalue();
  }

  getvalue() async {
    departuredate.text = context.read<ModuleName>().departureDate!;
    returndate.text = context.read<ModuleName>().returnDate!;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    children = prefs.getInt("flight_children");
    adults = prefs.getInt("flight_adults");
    infant = prefs.getInt("flight_infant");

    if (children != null && adults != null && infant != null) {
      // print('setting roominfo hotels got data ================');
      // print('setting  ================'+rooms.toString());
      // print('setting roominfo hotels got data ================'+adults.toString());
      var childrenText;
      var infantText;
      setState(() {
        _passengers = adults.toString() + ' ' + 'Adults';
        childrenText = children.toString() + ' ' + 'Children';

        infantText = infant.toString() + ' ' + 'Infants';

        // children = prefs.getInt("flight_children");
        // adults = prefs.getInt("flight_adults");
        // infant = prefs.getInt("flight_infant");

        if (adults > 1) {
          adultMinusButton = true;
        }
        if (adults + children + infant == 9) {
          adultAddButton = false;
          childrenAddButton = false;
          infantAddButton = false;
        }
        if (children > 0) {
          _passengers += ' ,';
          _passengers += childrenText;
          childrenMinusButton = true;
        }

        if (infant > 0) {
          _passengers += ' ,';
          _passengers += infantText;
          infantMinusButton = true;
        }
      });
    } else {
      setState(() {
        adults = 1;
        children = 0;
        infant = 0;
      });
    }

    if (prefs.getString('flight_from') != null &&
        prefs.getString('flight_code') != null &&
        prefs.getString('flight_to') != null &&
        prefs.getString('flight_code_to') != null) {
      setState(() {
        _destinationfrom.text = prefs.getString('flight_from')!;
        _destinationfromcode.text = prefs.getString('flight_code')!;
        flightcodeFROM = prefs.getString('flight_code');
        isDomesticFromData = prefs.getString('flight_isDomestic_from');
        _destinationto.text = prefs.getString('flight_to')!;
        _destinationtocode.text = prefs.getString('flight_code_to')!;
        flightcodeTO = prefs.getString('flight_code_to');
        isDomesticToData = prefs.getString('flight_isDomestic_to');
      });
    }
  }

  DateTime? lastSelecteddatereturn;

  DateFormat myformatter = DateFormat('ddMMMEEEE');
  String? checkindate;
  String? checkoutdate;
  bool _selectedchip = false;
  bool onewaychip = true;
  List<String>? flightdatagot;
  // var cabins = "0";
  String? dropdownValue = 'Economy';
  String? swapDestinationandtoData;
  bool iswapedDestinations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Material(
        child: Column(children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical * 50,
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  // ColorCodeGen.colorFromHex('#0e3957').withOpacity(0.7),
                  ColorCodeGen.colorFromHex('#ffd022').withOpacity(0.5),
                  ColorCodeGen.colorFromHex('#000000').withOpacity(0.8),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.statusBarHeight +
                          SizeConfig.screenHeight! / 100),
                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   height: 0,
                      //   // width: 350,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: AssetImage("assets/loginScreen_back.jpg"),
                      //         fit: BoxFit.cover),
                      //     // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                      //   ),
                      // ),

                      Container(
                        height: 0,
                        // width: 350,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/back.jpg"),
                              fit: BoxFit.cover),
                          // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                        ),
                      ),

                      Container(
                        height: 0,
                        // width: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/hotel.jpg"),
                              fit: BoxFit.cover),
                          // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                        ),
                      ),
                      //this is pre loaded image in RAM for hotel page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(children: [
                            AnimatedPositioned(
                              left: _selectedchip
                                  ? SizeConfig.blockSizeHorizontal * 29
                                  : SizeConfig.blockSizeHorizontal * 1,

                              // 110 : 11,
                              duration: Duration(milliseconds: 150),
                              // curve: Curves.easeIn,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 1,
                                    bottom: SizeConfig.blockSizeVertical * 1,
                                    left: SizeConfig.blockSizeHorizontal * 1,
                                    right: SizeConfig.blockSizeHorizontal * 1),
                                width: SizeConfig.blockSizeHorizontal * 28,
                                height: SizeConfig.blockSizeVertical * 4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(color: Colors.white38)),

                                // color:Colors.red,
                                width: SizeConfig.blockSizeHorizontal * 60,
                                height: SizeConfig.blockSizeVertical * 6,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.vibrate();
                                        if (onewaychip != true) {
                                          setState(() {
                                            onewaychip = true;
                                            _selectedchip = !_selectedchip;
                                            // chipbacktext = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                          //  color:  ColorCodeGen.colorFromHex('#ffd022'),
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  28,
                                          height:
                                              SizeConfig.blockSizeVertical * 3,
                                          child: Center(
                                              child: Text(
                                            'One Way',
                                            style: TextStyle(
                                                color: onewaychip
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.vibrate();
                                        if (onewaychip != false) {
                                          setState(() {
                                            onewaychip = false;
                                            _selectedchip = !_selectedchip;
                                          });
                                        }
                                      },
                                      child: Container(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  28,
                                          height:
                                              SizeConfig.blockSizeVertical * 3,
                                          // color:  ColorCodeGen.colorFromHex('#ffd022'),
                                          child: Center(
                                              child: Text(
                                            'Round Trip',
                                            style: TextStyle(
                                              color: onewaychip
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ))),
                                    ),
                                  ],
                                )),
                          ])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.grey,
                            onTap: () async {
                              HapticFeedback.vibrate();
                              flightdatagot = await Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SearchFrom()));
                              if (flightdatagot != null) {
                                setState(() {
                                  isDomesticFromData =
                                      flightdatagot![0].split(',')[1];
                                  _destinationfrom.text = flightdatagot![0];
                                  _destinationfromcode.text = flightdatagot![1];
                                });

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString(
                                    "flight_from", flightdatagot![0]);

                                prefs.setString('flight_code',
                                    (flightdatagot![1].toString()));

                                prefs.setString('flight_isDomestic_from',
                                    (flightdatagot![0].split(',')[1]));
                              }
                            },
                            child: Container(
                              // color: Colors.blue,
                              width: SizeConfig.blockSizeHorizontal * 34,
                              height: SizeConfig.blockSizeVertical * 13,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'FROM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _destinationfromcode.text,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                      child: Text(
                                        _destinationfrom.text,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: InkWell(
                              onTap: () async {
                                HapticFeedback.vibrate();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  swapDestinationandtoData =
                                      _destinationfromcode.text;
                                  _destinationfromcode.text =
                                      _destinationtocode.text;
                                  _destinationtocode.text =
                                      swapDestinationandtoData!;
                                  //iata code swap above done for UI

                                  swapDestinationandtoData = flightcodeFROM;
                                  flightcodeFROM = flightcodeTO;
                                  flightcodeTO = swapDestinationandtoData;
                                  //iata code swap above done for passing data

                                  swapDestinationandtoData =
                                      _destinationfrom.text;
                                  _destinationfrom.text = _destinationto.text;
                                  _destinationto.text =
                                      swapDestinationandtoData!;
                                  //destination text swap above done for UI

                                  if (iswapedDestinations == false) {
                                    iswapedDestinations = true;
                                  } else {
                                    iswapedDestinations = false;
                                  }
                                });

                                prefs.setString(
                                    "flight_from", _destinationfrom.text);

                                prefs.setString('flight_code', flightcodeFROM);

                                prefs.setString('flight_isDomestic_from',
                                    (_destinationfrom.text.split(',')[1]));

                                prefs.setString(
                                    "flight_to", _destinationto.text);

                                prefs.setString('flight_code_to', flightcodeTO);

                                prefs.setString(
                                    'flight_isDomestic_to',
                                    (_destinationto.text
                                        .split(',')[1]
                                        .toString()));
                              },
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Icon(Icons.swap_horiz),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.grey,
                            onTap: () async {
                              HapticFeedback.vibrate();
                              flightdatagot = await Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: FlightSearchTo()));
                              if (flightdatagot != null) {
                                setState(() {
                                  isDomesticToData =
                                      flightdatagot![0].split(',')[1];
                                  print(flightdatagot![0].split(',')[0]);
                                  _destinationto.text = flightdatagot![0];
                                  _destinationtocode.text = flightdatagot![1];
                                });

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                await prefs.setString(
                                    "flight_to", flightdatagot![0]);

                                prefs.setString(
                                    'flight_code_to', (flightdatagot![1]));

                                prefs.setString(
                                    'flight_isDomestic_to',
                                    (flightdatagot![0]
                                        .split(',')[1]
                                        .toString()));
                              }
                            },
                            child: Container(
                              // color: Colors.yellow,
                              width: SizeConfig.blockSizeHorizontal * 34,
                              height: SizeConfig.blockSizeVertical * 13,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      _destinationtocode.text,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                      child: Text(
                                        _destinationto.text,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage(
                "assets/plane.webp",
              ),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            color: Colors.white,
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical * 50,
            child: Column(
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical * 14,
                  // child: SFDatePicker(),
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  // color:Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            HapticFeedback.vibrate();
                            if (onewaychip == true) {
                              // flightonewayDategot = await Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.rightToLeft,
                              //         child: DatePickerUI(
                              //             hotelorflight: 'FlightDateOneWay')));
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (route) => CustomeDateScreen(
                                          isRangeMode: false)));

                              // print(flightonewayDategot);

                              // if (flightonewayDategot != null) {
                              //   setState(() {
                              //     selectedDate = flightonewayDategot;

                              //     checkindate =
                              //         myformatter.format(flightonewayDategot);

                              //     departuredate.text = checkindate;
                              //     print(departuredate.text.toString() +
                              //         'oneway==============');
                              //   });
                              // }

                              log('oneway chip date=======');
                              setState(() {
                                departuredate.text =
                                    context.read<ModuleName>().departureDate!;
                              });
                            } else {
                              // checkincheckoutdate = await Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.rightToLeft,
                              //         child: DatePickerUI(
                              //             hotelorflight:
                              //                 'FlightDateRoundTrip')));

                              // if (checkincheckoutdate != null) {
                              //   setState(() {
                              //     selectedDate = checkincheckoutdate[0];
                              //     selectedDate1 = checkincheckoutdate[1];
                              //     checkindate = myformatter
                              //         .format(checkincheckoutdate[0]);
                              //     checkoutdate = myformatter
                              //         .format(checkincheckoutdate[1]);
                              //     departuredate.text = checkindate;
                              //     returndate.text = checkoutdate;
                              //     print(departuredate.text.toString() +
                              //         'round==============' +
                              //         returndate.text.toString());
                              //   });
                              // }
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (route) => CustomeDateScreen(
                                          isRangeMode: true)));

                              setState(() {
                                departuredate.text =
                                    context.read<ModuleName>().departureDate!;
                                returndate.text =
                                    context.read<ModuleName>().returnDate!;
                              });
                            }
                          },
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'DEPARTURE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      // left: SizeConfig.blockSizeHorizontal * 8,
                                      right: 8.0,
                                      top: 6,
                                    ),
                                    child: Text(
                                      departuredate.text.split(' ')[0],
                                      style: TextStyle(
                                          color: ColorCodeGen.colorFromHex(
                                              '#ffd022'),
                                          fontSize: 30),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        departuredate.text.split(' ')[1],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        departuredate.text.split(' ')[2],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.blockSizeVertical * 14,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (onewaychip == false) {
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (route) => CustomeDateScreen(
                                          isRangeMode: true)));

                              setState(() {
                                log('goint to set round trip date ==========');
                                departuredate.text =
                                    context.read<ModuleName>().departureDate!;
                                returndate.text =
                                    context.read<ModuleName>().returnDate!;
                              });
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'RETURN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: onewaychip
                                        ? Colors.grey[300]
                                        : Colors.grey),
                              ),
                              Row(
                                //  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      // left: SizeConfig.blockSizeHorizontal * 8,
                                      right: 8.0,
                                      top: 6,
                                    ),
                                    child: Text(
                                      returndate.text.split(' ')[0],
                                      style: TextStyle(
                                          color: onewaychip
                                              ? Colors.grey[300]
                                              : ColorCodeGen.colorFromHex(
                                                  '#ffd022'),
                                          fontSize: 30),
                                    ),
                                  ),
                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        returndate.text.split(' ')[1],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 22,
                                            color: onewaychip
                                                ? Colors.grey[300]
                                                : Colors.black),
                                      ),
                                      Text(
                                        returndate.text.split(' ')[2],
                                        style: TextStyle(
                                            color: onewaychip
                                                ? Colors.grey[300]
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 14,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  // color: Colors.yellow,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Material(
                          child: InkWell(
                            // splashColor: Colors.grey,
                            onTap: () async {
                              HapticFeedback.vibrate();
                              var gotPassengers =
                                  await openFlightPassengerPopup(context);
                              print(
                                  'gotPassengers================$gotPassengers');
                              if (gotPassengers != null) {
                                setState(() {
                                  _passengers = gotPassengers;
                                });
                              }
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    // color: Colors.pink,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          // top: 20.0,
                                          left: SizeConfig.blockSizeHorizontal *
                                              8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('TRAVELLER',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5.0),
                                                  child: Text(_passengers,
                                                      //  _controllerRooms.text,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0, top: 5),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 32,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.blockSizeVertical * 16,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        //  width: SizeConfig.screenWidth,
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              // HapticFeedback.vibrate();
                              // MyStatefulWidget();
                              // classdropdownkey.currentContext.findRenderObject().
                            },
                            child: Container(
                              // color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0,
                                    left: SizeConfig.blockSizeHorizontal * 8),
                                child: Column(
                                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text('CLASS',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    openFlightCabinClassChoice(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 6.5,
                  width: SizeConfig.screenWidth,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 6,
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  width: SizeConfig.blockSizeHorizontal * 85,
                  child: ElevatedButton(
                    // color: ColorCodeGen.colorFromHex('#0e3957'),
                    style: ElevatedButton.styleFrom(
                      primary: ColorCodeGen.colorFromHex('#0e3957'),
                    ),
                    onPressed: () async {
                      HapticFeedback.vibrate();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      children = prefs.getInt("flight_children");
                      adults = prefs.getInt("flight_adults");
                      infant = prefs.getInt("flight_infant");
                      if (prefs.getString("flight_code") != null) {
                        flightcodeFROM = prefs.getString("flight_code");
                      }
                      if (prefs.getString("flight_code_to") != null) {
                        flightcodeTO = prefs.getString("flight_code_to");
                      }
                      if (isDomesticFromData!.trim() == 'India' &&
                          isDomesticToData!.trim() == 'India') {
                        isDomestic = 'Yes';
                      } else {
                        isDomestic = 'No';
                      }
                      if (prefs.getString('selected_currency_code') != null) {
                        lastSelectedCurrency =
                            prefs.getString('selected_currency_code');
                      }
                      print('flight search btn is going to click' +
                          lastSelectedCurrency!);

                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: FlightDetail(
                                check_in_date: context
                                    .read<ModuleName>()
                                    .departureStandardDate
                                    .toString()
                                    .split(' ')[0],
                                check_out_date: context
                                    .read<ModuleName>()
                                    .returnStandardDate
                                    .toString()
                                    .split(' ')[0],
                                destinationfrom: _destinationfrom.text,
                                destinationto: _destinationto.text,
                                one_way: onewaychip ? 'Yes' : 'No',
                                children: children,
                                adults: adults,
                                infants: infant,
                                cabin: dropdownValue,
                                code: flightcodeFROM,
                                code1: flightcodeTO,
                                isDomestic: isDomestic,
                                selectedCurrency: lastSelectedCurrency,
                              )));
                    },
                    child: Text(
                      'SEARCH FLIGHTS',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget returnAdultChildInfantRow(
      {String? type,
      required String title,
      BuildContext? context,
      StateSetter? setState}) {
    return Container(
      // color: Colors.red,
      height: SizeConfig.blockSizeVertical * 12,
      width: SizeConfig.blockSizeHorizontal * 100,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                splashColor:
                    adultMinusButton ? Colors.grey : Colors.transparent,
                onTap: () {
                  if (type == "Adult") {
                    if (adultMinusButton) {
                      HapticFeedback.vibrate();
                    }
                    if (adults != 1) {
                      setState!(() {
                        if (adults == infant) {
                          infant = infant - 1;
                        }

                        print('adults================$adults');
                        print('infant================$infant');
                        adults = adults - 1;
                        if (infant < adults) {
                          infantAddButton = true;
                        }

                        adultAddButton = true;
                        // infantAddButton = true;
                        if (adults == 1) {
                          adultMinusButton = false;
                        }
                      });
                    } else {}
                  } else if (type == "Children") {
                    if (childrenMinusButton) {
                      HapticFeedback.vibrate();
                    }
                    if (children != 0) {
                      setState!(() {
                        childrenMinusButton = true;
                        adultAddButton = true;
                        if (infant < adults) {
                          infantAddButton = true;
                        }
                        children = children - 1;
                        if (children == 0) {
                          childrenMinusButton = false;
                        }
                      });
                    } else {}
                  } else {
                    if (infantMinusButton) {
                      HapticFeedback.vibrate();
                    }
                    if (infant != 0) {
                      setState!(() {
                        infantAddButton = true;
                        infantMinusButton = true;
                        adultAddButton = true;
                        infant = infant - 1;
                        if (infant == 0) {
                          infantMinusButton = false;
                        }
                      });
                    }
                  }
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(
                          color: type == "Adult"
                              ? (adultMinusButton
                                  ? Colors.grey
                                  : Colors.grey[200]!)
                              : type == "Children"
                                  ? (childrenMinusButton
                                      ? Colors.grey
                                      : Colors.grey[200]!)
                                  : (infantMinusButton
                                      ? Colors.grey
                                      : Colors.grey[200]!)),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      color: type == "Adult"
                          ? (adultMinusButton ? Colors.black : Colors.black45)
                          : type == "Children"
                              ? (childrenMinusButton
                                  ? Colors.black
                                  : Colors.black45)
                              : (infantMinusButton
                                  ? Colors.black
                                  : Colors.black45),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type == "Adult"
                      ? adults.toString()
                      : type == "Children"
                          ? children.toString()
                          : infant.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                splashColor: adultAddButton ? Colors.grey : Colors.transparent,
                onTap: () {
                  if (type == "Adult") {
                    if (adultAddButton) {
                      HapticFeedback.vibrate();
                    }
                    if (adults < (maxAdult - (children + infant))) {
                      setState!(() {
                        adults = ++adults;
                        adultMinusButton = true;
                        if (adults == maxAdult - (children + infant)) {
                          adultAddButton = false;
                          infantAddButton = false;
                        }
                        if (adults + children + infant != maxAdult) {
                          if (infant < adults) {
                            infantAddButton = true;
                          }
                        }
                      });
                    } else {
                      // setState(() {
                      //   infantAddButton = false;
                      // });
                      Fluttertoast.showToast(
                          msg:
                              "You may search for up to 9 passengers at a time");
                    }
                  } else if (type == "Children") {
                    if (adultAddButton) {
                      HapticFeedback.vibrate();
                    }
                    if (children < (maxAdult - (adults + infant))) {
                      setState!(() {
                        children = ++children;
                        childrenMinusButton = true;
                        if (children == (maxAdult - (adults + infant))) {
                          adultAddButton = false;
                          infantAddButton = false;
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "You may search for up to 9 passengers at a time");
                    }
                  } else {
                    if (infantAddButton) {
                      HapticFeedback.vibrate();
                    }
                    if (infant < (maxAdult - (adults + children))) {
                      if (infant < adults) {
                        setState!(() {
                          infant = ++infant;
                          infantMinusButton = true;
                          if (infant == (maxAdult - (adults + children))) {
                            adultAddButton = false;
                            infantAddButton = false;
                          }
                          if (infant == adults) {
                            infantAddButton = false;
                          }
                        });
                      } else {
                        // setState(() {
                        //   infantAddButton = false;
                        // });
                      }
                    } else {
                      // setState(() {
                      //   infantAddButton = false;
                      // });
                      Fluttertoast.showToast(
                          msg:
                              "You may search for up to 9 passengers at a time");
                    }
                  }
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: type == "Adult"
                              ? (adultAddButton
                                  ? Colors.grey
                                  : Colors.grey[300]!)
                              : type == "Children"
                                  ? (adultAddButton
                                      ? Colors.grey
                                      : Colors.grey[300]!)
                                  : (infantAddButton
                                      ? Colors.grey
                                      : Colors.grey[300]!)),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: type == "Adult"
                          ? (adultAddButton ? Colors.black : Colors.black26)
                          : type == "Children"
                              ? (adultAddButton ? Colors.black : Colors.black26)
                              : (infantAddButton
                                  ? Colors.black
                                  : Colors.black26),
                      size: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget returnFlightPassengerDoneButton(
      BuildContext context, StateSetter setState) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorCodeGen.colorFromHex('#0e3957'),
        ),
        height: SizeConfig.blockSizeVertical * 6.5,
        width: SizeConfig.blockSizeHorizontal * 95,
        child: ElevatedButton(
          onPressed: () async {
            HapticFeedback.vibrate();
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setInt('flight_adults', adults);
            pref.setInt('flight_children', children);
            pref.setInt('flight_infant', infant);

            var childrenText;
            var infantText;
            var finalPassenger;

            finalPassenger = adults.toString() + ' ' + 'Adults';

            childrenText = children.toString() + ' ' + 'Children';

            infantText = infant.toString() + ' ' + 'Infant' + ' ';

            if (children > 0) {
              finalPassenger += ' ,';
              finalPassenger += childrenText;
            }
            if (infant > 0) {
              finalPassenger += ' ,';
              finalPassenger += infantText;
            }

            print(finalPassenger + '=====================finalPassenger');
            Navigator.pop(context, finalPassenger);
          },
          child: Center(
            child: Text(
              'DONE',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> openFlightPassengerPopup(context) async {
    String? data = await showGeneralDialog(
      barrierLabel: "Add Passenger",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 250),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: SizeConfig.blockSizeVertical * 50,
              child: Scaffold(
                body: Column(
                  children: [
                    returnAdultChildInfantRow(
                        type: 'Adult',
                        title: 'Above 12 years',
                        context: context,
                        setState: setState),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                    ),
                    returnAdultChildInfantRow(
                        type: 'Children',
                        title: '2 - 12 years',
                        context: context,
                        setState: setState),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                    ),
                    returnAdultChildInfantRow(
                        type: 'Infant',
                        title: 'Below 2 years',
                        context: context,
                        setState: setState),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                    ),
                    // Container(
                    //   height: SizeConfig.blockSizeVertical * 2,
                    //   width: SizeConfig.blockSizeHorizontal * 100,
                    // ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    returnFlightPassengerDoneButton(context, setState),
                  ],
                ),
              ),
              // margin: EdgeInsets.only(bottom: 0, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
    print('data=================');
    print(data);
    return data;
  }

  GlobalKey classdropdownkey = new GlobalKey();

  Widget openFlightCabinClassChoice() {
    return DropdownButton<String>(
      key: classdropdownkey,
      value: dropdownValue,
      icon: Expanded(
        flex: 1,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
          size: 32,
        ),
      ),
      elevation: 16,
      style: TextStyle(
        color: Colors.black,
        // fontSize: 32,
        fontWeight: FontWeight.normal,
      ),
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      onChanged: (newValue) {
        print('newValue class flight=======================$newValue');
        setState(() {
          HapticFeedback.vibrate();
          dropdownValue = newValue;
          // if (dropdownValue == 'Economy') {
          //   cabins = '0';
          // } else {
          //   cabins = '1';
          // }
        });
        print(
            'dropdownValue class flight=======================$dropdownValue');
        // print('cabins class flight=======================$cabins');
      },
      items: <String>[
        'Any',
        'Economy',
        'Premium Economy',
        'Business',
        'Premium Business',
        'First'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            width: 100,
            // color: Colors.red,
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }).toList(),
    );
  }
}
