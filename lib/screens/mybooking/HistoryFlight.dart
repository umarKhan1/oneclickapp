
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/helperwidgets/ConnectionErrorScreen.dart';
import 'package:oneclicktravel/helperwidgets/circularProgIndi.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:ndialog/ndialog.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oneclicktravel/MyScheduleProvider.dart';

import 'package:oneclicktravel/utils/color_code_generator.dart';

class HistoryFlightScreen extends StatefulWidget {
  HistoryFlightScreen({Key? key}) : super(key: key);

  @override
  _HistoryFlightScreenState createState() => _HistoryFlightScreenState();
}

class _HistoryFlightScreenState extends State<HistoryFlightScreen> {
  late SharedPreferences pref;
  String? user;
  List? flightInternaltionFullData;
  List? userflighthistory;
  String? isDomestic;
  String? orderIdFlight;
  List? onewayFlightData;
  List? returnFlightData;
  List? passengerDetail;
  late Map<String, dynamic> startAirportData;
  late Map<String, dynamic> endAirportData;
  late Map<String, dynamic> returnstartAirportData;
  late Map<String, dynamic> returnendAirportData;
  bool isOneWay = true;
  String? pnrNumberForReturn;
  String? pnrNumberForGoing;
  String? flightBookingStatus;
  late double flightPrice;
  String? flightBookingCurrency;
//  var pid= Strings.app_pid;
  String userflighthistoryURL =
      'https://www.abengines.com/wp-content/themes/adivaha_main/fetch-flight-data.php?pid=${Strings.app_pid}&emailz=';
  String flightimageURL =
      "https://res.cloudinary.com/wego/image/upload/c_fit,w_100,h_100/v20190802/flights/airlines_square/";

  String progress = "";
  bool showProgress = false;
  var cancellationResponseFlight;
  late Dio dio;
  @override
  void dispose() {
    //check connection start here
    _connectivitySubscription.cancel();
    //check connection end here

    super.dispose();
  }

  //check connection start here
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  //check connection end here
  @override
  void initState() {
    //check connection start here
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    dio = Dio();
    //check connection end here
    super.initState();

    getUser();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  Future<http.Response> getUserflightHistory(String userEmail) async {
    return await http.get(Uri.parse(userflighthistoryURL + userEmail));
  }

  // String path;
  void getUser() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('signInUser');
    });

    print('user in flighthistory');
    print(user);
  }

  List<Widget>? _listings;
  showDetails(int index) {
    initializeDataForEachBooking(index);
    showGeneralDialog(
      barrierLabel: "Flight History Details",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 120),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.clear,
                            color: ColorCodeGen.colorFromHex('#15a2f5'),
                            size: 32,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  getFlightDataHeading(),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 10, bottom: 5),
                      child: Divider(
                        color: Colors.grey,
                      )),
                  Expanded(
                    child: ListView(
                      children: returnsegmentFlightStationDetailsScreen(
                          onewayFlightData, returnFlightData)!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  List<Widget>? returnsegmentFlightStationDetailsScreen(
      List? onewayFlightData, List? returnFlightData) {
    bool isreturnStoppageMade;
    List? stoppageData;
    _listings = <Widget>[];
    isreturnStoppageMade = false;

    for (int i = 0; i < 2; i++) {
      if (isreturnStoppageMade == false) {
        stoppageData = onewayFlightData;
      } else {
        if (isOneWay == false) {
          stoppageData = returnFlightData;
        } else {
          getTicketDetails();
          getPassengerDetails();
          return _listings;
        }
      }
      for (int i = 0; i < stoppageData!.length; i++) {
        _listings!.add(
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.teal[100]!,
                                ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      stoppageData[i]['Origin']['Airport']
                                                  ['CityName']
                                              .toString() +
                                          ' ',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      stoppageData[i]['Origin']['Airport']
                                          ['AirportCode'],
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                stoppageData[i]['Origin']['DepTime']
                                    .split('T')[1],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                formatter.format((DateTime.parse(stoppageData[i]['Origin']['DepTime'].split('T')[0].toString()))).toString().substring(
                                        5,
                                        formatter
                                            .format((DateTime.parse(stoppageData[i]
                                                    ['Origin']['DepTime']
                                                .split('T')[0]
                                                .toString())))
                                            .toString()
                                            .length) +
                                    ', ' +
                                    formatter
                                        .format((DateTime.parse(stoppageData[i]
                                                ['Origin']['DepTime']
                                            .split('T')[0]
                                            .toString())))
                                        .toString()
                                        .substring(0, 2) +
                                    ' ' +
                                    formatter
                                        .format((DateTime.parse(
                                            stoppageData[i]['Origin']['DepTime'].split('T')[0].toString())))
                                        .toString()
                                        .substring(2, 5),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                stoppageData[i]['Origin']['Airport']
                                    ['AirportName'],
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: ColorCodeGen.colorFromHex('#189600'),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: ColorCodeGen.colorFromHex('#189600')),
                            ),
                          ),
                          Container(
                            // height: 8,
                            width: 30,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashColor: Colors.grey,
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.grey,
                              dashGapRadius: 0.0,
                            ),
                          ),
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal[100]!,
                                  Colors.white,
                                ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    stoppageData[i]['Destination']['Airport']
                                            ['AirportCode'] +
                                        ' ',
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Flexible(
                                    child: Text(
                                      stoppageData[i]['Destination']['Airport']
                                              ['CityName']
                                          .toString()
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                stoppageData[i]['Destination']['ArrTime']
                                    .split('T')[1],
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                formatter.format((DateTime.parse(stoppageData[i]['Destination']['ArrTime'].split('T')[0].toString()))).toString().substring(
                                        5,
                                        formatter
                                            .format((DateTime.parse(
                                                stoppageData[i]['Destination']
                                                        ['ArrTime']
                                                    .split('T')[0]
                                                    .toString())))
                                            .toString()
                                            .length) +
                                    ', ' +
                                    formatter
                                        .format((DateTime.parse(stoppageData[i]
                                                ['Destination']['ArrTime']
                                            .split('T')[0]
                                            .toString())))
                                        .toString()
                                        .substring(0, 2) +
                                    ' ' +
                                    formatter
                                        .format(
                                            (DateTime.parse(stoppageData[i]['Destination']['ArrTime'].split('T')[0].toString())))
                                        .toString()
                                        .substring(2, 5),
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                stoppageData[i]['Destination']['Airport']
                                    ['AirportName'],
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      }
      isreturnStoppageMade = true;
    }
    getTicketDetails();
    getPassengerDetails();
    return _listings;
  }

  void getTicketDetails() {
    _listings!.add(
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ticket Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Divider(),
                  Text(
                    startAirportData['Origin']['Airport']['AirportName'] +
                        '-' +
                        startAirportData['Origin']['Airport']['AirportCode'],
                    style: TextStyle(),
                  ),
                  Text(
                    startAirportData['Origin']['DepTime']
                            .toString()
                            .split('T')[0] +
                        ' ' +
                        startAirportData['Origin']['DepTime']
                            .toString()
                            .split('T')[1],
                    style: TextStyle(),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                  ),
                  Text(
                      endAirportData['Destination']['Airport']['AirportName'] +
                          '-' +
                          endAirportData['Destination']['Airport']
                              ['AirportCode'],
                      style: TextStyle()),
                  Text(
                      endAirportData['Destination']['ArrTime']
                              .toString()
                              .split('T')[0] +
                          ' ' +
                          endAirportData['Destination']['ArrTime']
                              .toString()
                              .split('T')[1],
                      style: TextStyle()),
                  Row(
                    children: [
                      Text(
                        'AirLine : ' +
                            startAirportData['Airline']['AirlineName'] +
                            ' ',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        startAirportData['Airline']['AirlineCode'],
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  Text(
                    'Flight no: ' + startAirportData['Airline']['FlightNumber'],
                    style: TextStyle(),
                  ),
                  Text(
                      startAirportData['CabinClass'] == 0
                          ? "CabinClass: Economy"
                          : "CabinClass: Business",
                      style: TextStyle(fontSize: 14)),
                  Text(
                    'PNR: ' + pnrNumberForGoing!,
                    style: TextStyle(),
                  ),
                  Divider(),
                  isOneWay == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(returnstartAirportData['Origin']['Airport']
                                    ['AirportName'] +
                                '-' +
                                returnstartAirportData['Origin']['Airport']
                                    ['AirportCode']),
                            Text(returnstartAirportData['Origin']['DepTime']
                                    .toString()
                                    .split('T')[0] +
                                ' ' +
                                returnstartAirportData['Origin']['DepTime']
                                    .toString()
                                    .split('T')[1]),
                            Text(returnendAirportData['Destination']['Airport']
                                    ['AirportName'] +
                                '-' +
                                returnendAirportData['Destination']['Airport']
                                    ['AirportCode']),
                            Text(returnendAirportData['Destination']['ArrTime']
                                    .toString()
                                    .split('T')[0] +
                                ' ' +
                                returnendAirportData['Destination']['ArrTime']
                                    .toString()
                                    .split('T')[1]),
                            Row(
                              children: [
                                Text(
                                  'AirLine : ' +
                                      returnstartAirportData['Airline']
                                          ['AirlineName'] +
                                      ' ',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  returnstartAirportData['Airline']
                                      ['AirlineCode'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                            Text('Flight no: ' +
                                returnstartAirportData['Airline']
                                    ['FlightNumber']),
                            Text(
                                returnstartAirportData['CabinClass'] == 0
                                    ? "CabinClass: Economy"
                                    : "CabinClass: Business",
                                style: TextStyle(fontSize: 14)),
                            Text('PNR: ' + pnrNumberForReturn!),
                            Divider(),
                          ],
                        )
                      : SizedBox(),
                  Row(
                    children: [
                      Text(
                        'Price: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        flightBookingCurrency! +
                            ' ' +
                            flightPrice.toStringAsFixed(2),
                        style: TextStyle(
                            color: ColorCodeGen.colorFromHex('#189600')),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Text(
                        'Status: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        flightBookingStatus!,
                        style: TextStyle(
                            color: flightBookingStatus == 'Confirmed'
                                ? ColorCodeGen.colorFromHex('#189600')
                                : Colors.red),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  void getPassengerDetails() {
    for (int i = 0; i < passengerDetail!.length; i++) {
      _listings!.add(Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Information',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  passengerDetail![i]['Title'] +
                      ' ' +
                      passengerDetail![i]['FirstName'] +
                      ' ' +
                      passengerDetail![i]['LastName'],
                ),
                Text(passengerDetail![i]['Gender'] == 1
                    ? 'Gender: Male'
                    : 'Gender: Female'),
                Text('DOB:' + passengerDetail![i]['DateOfBirth']),
                Divider(),
                Text('Contact Information',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Email: ' + passengerDetail![i]['Email']),
                Text('Contact Number: ' + passengerDetail![i]['ContactNo']),
                Text('Address Line1: ' + passengerDetail![i]['AddressLine1']),
                Text('Address Line2: ' + passengerDetail![i]['AddressLine2']),
                Text('City: ' + passengerDetail![i]['City']),
                passengerDetail![i]['CountryName'] != null
                    ? Text('Country: ' + passengerDetail![i]['CountryName'])
                    : Container(),
              ],
            ),
          ),
        ),
      ));
    }
    // return _listings;
  }

  Widget returnsegmentFlightStation(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 0),
      child: Column(
        children: [
          Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(child: SizedBox()),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          startAirportData['Origin']['Airport']['CityName'] +
                              ' ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          startAirportData['Origin']['Airport']['AirportCode'],
                          // overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                    Text(
                      startAirportData['Origin']['DepTime'].split('T')[1],
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      formatter
                              .format((DateTime.parse(startAirportData['Origin']
                                      ['DepTime']
                                  .split('T')[0]
                                  .toString())))
                              .toString()
                              .substring(
                                  5,
                                  formatter
                                      .format((DateTime.parse(
                                          startAirportData['Origin']['DepTime']
                                              .split('T')[0]
                                              .toString())))
                                      .toString()
                                      .length)
                              .substring(0, 3) +
                          ', ' +
                          formatter
                              .format((DateTime.parse(startAirportData['Origin']
                                      ['DepTime']
                                  .split('T')[0]
                                  .toString())))
                              .toString()
                              .substring(0, 2) +
                          ' ' +
                          formatter
                              .format((DateTime.parse(
                                  startAirportData['Origin']['DepTime'].split('T')[0].toString())))
                              .toString()
                              .substring(2, 5),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      startAirportData['Origin']['Airport']['AirportName'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isOneWay == true
                          ? Icons.arrow_right_alt
                          : Icons.compare_arrows,
                      color: Colors.red,
                    ),
                    Text(
                      isOneWay == true ? 'One Way' : 'Round Trip',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              ///return data main screen
              Expanded(
                flex: 1,
                child: Column(
                  // shrinkWrap: true,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          endAirportData['Destination']['Airport']
                                  ['AirportCode'] +
                              ' ',
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Flexible(
                          child: Text(
                            endAirportData['Destination']['Airport']
                                ['CityName'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      endAirportData['Destination']['ArrTime'].split('T')[1],
                      overflow: TextOverflow.visible,
                      // textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      formatter
                              .format((DateTime.parse(
                                  endAirportData['Destination']['ArrTime']
                                      .split('T')[0]
                                      .toString())))
                              .toString()
                              .substring(
                                  5,
                                  formatter
                                      .format((DateTime.parse(
                                          endAirportData['Destination']
                                                  ['ArrTime']
                                              .split('T')[0]
                                              .toString())))
                                      .toString()
                                      .length)
                              .substring(0, 3) +
                          ', ' +
                          formatter
                              .format((DateTime.parse(
                                  endAirportData['Destination']['ArrTime']
                                      .split('T')[0]
                                      .toString())))
                              .toString()
                              .substring(0, 2) +
                          ' ' +
                          formatter
                              .format(
                                  (DateTime.parse(endAirportData['Destination']['ArrTime'].split('T')[0].toString())))
                              .toString()
                              .substring(2, 5),
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      endAirportData['Destination']['Airport']['AirportName'],
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  var formatter = new DateFormat('ddMMMEEEE');
  void initializeDataForEachBooking(int index) {
    orderIdFlight = userflighthistory![index]['id'];

    if (jsonDecode(userflighthistory![index]['request_data'])['isDomestic']
            .toString() ==
        'Yes') {
      isDomestic =
          jsonDecode(userflighthistory![index]['request_data'])['isDomestic']
              .toString();
      if (userflighthistory![index]['onewayFlights'] != null) {
        onewayFlightData =
            jsonDecode(userflighthistory![index]['onewayFlights'])[0];

        if (onewayFlightData!.length > 1) {
          startAirportData = onewayFlightData![0];
          endAirportData = onewayFlightData![onewayFlightData!.length - 1];
        }
        if (onewayFlightData!.length == 1) {
          // print('domesstic one way ==1');
          startAirportData = onewayFlightData![0];
          endAirportData = onewayFlightData![0];
        }
        pnrNumberForGoing = userflighthistory![index]['pnr_number'];
      }
      if (userflighthistory![index]['returnFlights'].toString() != 'null') {
        returnFlightData =
            jsonDecode(userflighthistory![index]['returnFlights'])[0];

        if (returnFlightData!.length > 1) {
          returnstartAirportData = returnFlightData![0];
          returnendAirportData =
              returnFlightData![returnFlightData!.length - 1];
        }
        if (returnFlightData!.length == 1) {
          returnstartAirportData = returnFlightData![0];
          returnendAirportData = returnFlightData![0];
        }
        pnrNumberForReturn = userflighthistory![index]['return_pnr_number'];
      }
      if (userflighthistory![index]['onewayFlights'] != null &&
          userflighthistory![index]['returnFlights'].toString() != 'null') {
        isOneWay = false;
      } else {
        isOneWay = true;
      }
    } else {
      isDomestic =
          jsonDecode(userflighthistory![index]['request_data'])['isDomestic']
              .toString();
      if (userflighthistory![index]['onewayFlights'] != null) {
        flightInternaltionFullData =
            jsonDecode(userflighthistory![index]['onewayFlights']);

        if (flightInternaltionFullData!.length == 1) {
          pnrNumberForGoing = userflighthistory![index]['pnr_number'];
          isOneWay = true;
          onewayFlightData = flightInternaltionFullData![0];

          if (onewayFlightData!.length > 1) {
            startAirportData = onewayFlightData![0];

            endAirportData = onewayFlightData![onewayFlightData!.length - 1];
          }
          if (onewayFlightData!.length == 1) {
            startAirportData = onewayFlightData![0];
            endAirportData = onewayFlightData![0];
          }
        }
        if (flightInternaltionFullData!.length == 2) {
          pnrNumberForGoing = userflighthistory![index]['pnr_number'];
          isOneWay = false;
          onewayFlightData = flightInternaltionFullData![0];

          if (onewayFlightData!.length > 1) {
            startAirportData = onewayFlightData![0];

            endAirportData = onewayFlightData![onewayFlightData!.length - 1];
          }
          if (onewayFlightData!.length == 1) {
            startAirportData = onewayFlightData![0];

            endAirportData = onewayFlightData![0];
          }
          returnFlightData = flightInternaltionFullData![1];
          if (returnFlightData!.length > 1) {
            returnstartAirportData = returnFlightData![0];
            returnendAirportData =
                returnFlightData![returnFlightData!.length - 1];
          }
          if (returnFlightData!.length == 1) {
            returnstartAirportData = returnFlightData![0];
            returnendAirportData = returnFlightData![0];
          }
        }
      }
    }
    if (userflighthistory![index]['passenger_detail'] != null) {
      passengerDetail =
          jsonDecode(userflighthistory![index]['passenger_detail']);
    }
    if (userflighthistory![index]['booking_status'] != null) {
      flightBookingStatus = userflighthistory![index]['booking_status'];
    }
    if (userflighthistory![index]['price'] != null) {
      flightPrice = double.parse(userflighthistory![index]['price']);
    }
    if (jsonDecode(userflighthistory![index]['request_data'])['currency'] !=
        null) {
      flightBookingCurrency =
          jsonDecode(userflighthistory![index]['request_data'])['currency'];
    }
  }

  Widget getFlightDataHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 55,
            width: SizeConfig.blockSizeHorizontal! * 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(flightimageURL.toString() +
                                startAirportData['Airline']['AirlineCode']
                                    .toString()),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            startAirportData['Airline']['AirlineName'] + ' ',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            startAirportData['Airline']['AirlineCode'] +
                                ' ' +
                                startAirportData['Airline']['FlightNumber'],
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Text(
                          startAirportData['CabinClass'] == 0
                              ? "Economy"
                              : "Business",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final myScheduleProvider = Provider.of<MyScheduleProvider>(context);
    return user != null
        ? Stack(children: [
            FutureBuilder(
              future: getUserflightHistory(context.read<MyUser>().email!),
              builder: (context, AsyncSnapshot snapshot) {
                if (_connectionStatus != 'ConnectivityResult.none') {
                  if (snapshot.hasData) {
                    userflighthistory = jsonDecode(snapshot.data.body);

                    if (userflighthistory != null) {
                      return ListView.builder(
                          itemCount: userflighthistory!.length,
                          itemBuilder: (context, index) {
                            initializeDataForEachBooking(index);
                            return Card(
                              // color: Colors.red,
                              borderOnForeground: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getFlightDataHeading(),
                                  returnsegmentFlightStation(index),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                            'Booked on ' +
                                                formatter
                                                    .format((DateTime.parse(
                                                        userflighthistory![index]
                                                                ['date_time']
                                                            .split(' ')[0]
                                                            .toString())))
                                                    .toString()
                                                    .substring(
                                                        5,
                                                        formatter
                                                            .format((DateTime.parse(
                                                                userflighthistory![index]['date_time']
                                                                    .split(
                                                                        ' ')[0]
                                                                    .toString())))
                                                            .toString()
                                                            .length)
                                                    .substring(0, 3) +
                                                ', ' +
                                                formatter
                                                    .format((DateTime.parse(userflighthistory![index]['date_time'].split(' ')[0].toString())))
                                                    .toString()
                                                    .substring(0, 2) +
                                                ' ' +
                                                formatter.format((DateTime.parse(userflighthistory![index]['date_time'].split(' ')[0].toString()))).toString().substring(2, 5),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: ShaderMask(
                                          shaderCallback: (bounds) =>
                                              RadialGradient(
                                            center: Alignment.topLeft,
                                            radius: 1.0,
                                            colors: userflighthistory![index]
                                                        ['booking_status'] ==
                                                    'Cancelled'
                                                ? [
                                                    Colors.red,
                                                    Colors.red,
                                                  ]
                                                : [
                                                    Colors.green,
                                                    Colors.green,
                                                  ],
                                            tileMode: TileMode.mirror,
                                          ).createShader(bounds),
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Status : ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                            TextSpan(
                                              text: flightBookingStatus,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ])),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DateTime.now().compareTo(DateTime.parse(
                                                  jsonDecode(userflighthistory![
                                                                  index][
                                                              'onewayFlights'])[0][0]
                                                          ['Origin']['DepTime']
                                                      .toString()
                                                      .split('T')[0])) <
                                              0
                                          ? userflighthistory![index]
                                                          ['pnr_status']
                                                      .toString() !=
                                                  'Cancelled'
                                              ? Flexible(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final ConfirmAction?
                                                          action =
                                                          await confirmDialogFlightCancel(
                                                              context);

                                                      if (action ==
                                                          ConfirmAction
                                                              .Accept) {
                                                        cancellationResponseFlight =
                                                            await cancelRequestFlightTicket(
                                                                context,
                                                                index,
                                                                false);

                                                        if (cancellationResponseFlight[
                                                                    'StatusCode'] !=
                                                                null &&
                                                            cancellationResponseFlight[
                                                                    'StatusCode'] ==
                                                                1 &&
                                                            cancellationResponseFlight[
                                                                    'cancellationNumber'] !=
                                                                null) {
                                                          myScheduleProvider
                                                                  .showCancelFlightBooking =
                                                              true;
                                                          Navigator.of(
                                                            _keyLoaderFlight
                                                                .currentContext!,
                                                          ).pop();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Booking Cancelled Successfully");
                                                        } else {
                                                          print(
                                                              'else cancel===========');
                                                          Navigator.of(
                                                            _keyLoaderFlight
                                                                .currentContext!,
                                                          ).pop();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Something Went Wrong!");
                                                        }
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        SizeConfig.blockSizeHorizontal! *
                                                                            15),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .arrowRight,
                                                              color: Colors.red,
                                                              // textDirection: ,
                                                              size: 16,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .ban,
                                                                color:
                                                                    Colors.blue,
                                                                // textDirection: ,
                                                                size: 16,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5.0),
                                                                child: Text(
                                                                  'Cancel Ticket',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .blue,
                                                                      fontFamily:
                                                                          'Helvetica',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .arrowRight,
                                                          color: Colors.red,
                                                          // textDirection: ,
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.cancel,
                                                                color:
                                                                    Colors.red,
                                                                // textDirection: ,
                                                                size: 16),
                                                            Flexible(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5.0),
                                                                child: Text(
                                                                  'Cancelled on ' +
                                                                      formatter
                                                                          .format((DateTime.parse(userflighthistory![index]['date_time']
                                                                              .toString())))
                                                                          .toString()
                                                                          .substring(
                                                                              5,
                                                                              formatter
                                                                                  .format((DateTime.parse(userflighthistory![index]['date_time']
                                                                                      .toString())))
                                                                                  .toString()
                                                                                  .length)
                                                                          .substring(
                                                                              0, 3) +
                                                                      ', ' +
                                                                      formatter
                                                                          .format((DateTime.parse(userflighthistory![index]['date_time']
                                                                              .toString())))
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              2) +
                                                                      ' ' +
                                                                      formatter
                                                                          .format((DateTime.parse(userflighthistory![index]['date_time'].toString())))
                                                                          .toString()
                                                                          .substring(2, 5),

                                                                  // userhotelhistory[index]
                                                                  //         ['cancellation_date']

                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Helvetica'),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                          : Text(
                                              userflighthistory![index]
                                                      ['pnr_status']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: userflighthistory![index]
                                                                ['pnr_status']
                                                            .toString() ==
                                                        'Confirmed'
                                                    ? Colors.green
                                                    : Colors.orange[300],
                                              ),
                                            ),
                                      // Expanded(child:   SizedBox(),),
                                      isOneWay != true
                                          ? userflighthistory![index]
                                                      ['returnFlights'] !=
                                                  null
                                              ? DateTime.now().compareTo(DateTime.parse(
                                                          jsonDecode(userflighthistory![index]
                                                                          ['returnFlights'])[0][0]
                                                                      ['Origin']
                                                                  ['DepTime']
                                                              .toString()
                                                              .split('T')[0])) <
                                                      0
                                                  ? userflighthistory![index][
                                                                  'return_pnr_status']
                                                              .toString() !=
                                                          'Cancelled'
                                                      ? Flexible(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              final ConfirmAction?
                                                                  action =
                                                                  await confirmDialogFlightCancel(
                                                                      context);

                                                              if (action ==
                                                                  ConfirmAction
                                                                      .Accept) {
                                                                cancellationResponseFlight =
                                                                    await cancelRequestFlightTicket(
                                                                        context,
                                                                        index,
                                                                        true);

                                                                if (cancellationResponseFlight[
                                                                            'StatusCode'] !=
                                                                        null &&
                                                                    cancellationResponseFlight[
                                                                            'StatusCode'] ==
                                                                        1 &&
                                                                    cancellationResponseFlight[
                                                                            'cancellationNumber'] !=
                                                                        null) {
                                                                  myScheduleProvider
                                                                          .showCancelFlightBooking =
                                                                      true;
                                                                  Navigator.of(
                                                                    _keyLoaderFlight
                                                                        .currentContext!,
                                                                  ).pop();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Booking Cancelled Successfully");
                                                                } else {
                                                                  print(
                                                                      'else cancel===========');
                                                                  Navigator.of(
                                                                    _keyLoaderFlight
                                                                        .currentContext!,
                                                                  ).pop();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Something Went Wrong!");
                                                                }
                                                              }
                                                              // cancelRequestFlightReturnTicket(
                                                              //     context, index);
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: SizeConfig
                                                                          .blockSizeHorizontal! *
                                                                      10),
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .arrowLeft,
                                                                    color: Colors
                                                                        .red,
                                                                    // textDirection: ,
                                                                    size: 16,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    // crossAxisAlignment:
                                                                    //     CrossAxisAlignment
                                                                    //         .baseline,
                                                                    children: [
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .ban,
                                                                        color: Colors
                                                                            .blue,
                                                                        // textDirection: ,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 5.0),
                                                                          child:
                                                                              Text(
                                                                            'Cancel Return Ticket',
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.blue,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .arrowLeft,
                                                                  color: Colors
                                                                      .red,
                                                                  // textDirection: ,
                                                                  size: 16,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                        // textDirection: ,
                                                                        size:
                                                                            16),
                                                                    Flexible(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child:
                                                                            Text(
                                                                          'Cancelled on ' +
                                                                              formatter.format((DateTime.parse(userflighthistory![index]['date_time'].toString()))).toString().substring(5, formatter.format((DateTime.parse(userflighthistory![index]['date_time'].toString()))).toString().length).substring(0, 3) +
                                                                              ', ' +
                                                                              formatter.format((DateTime.parse(userflighthistory![index]['date_time'].toString()))).toString().substring(0, 2) +
                                                                              ' ' +
                                                                              formatter.format((DateTime.parse(userflighthistory![index]['date_time'].toString()))).toString().substring(2, 5),

                                                                          // userhotelhistory[index]
                                                                          //         ['cancellation_date']

                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Helvetica'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                  : Text(
                                                      userflighthistory![index][
                                                              'return_pnr_status']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: userflighthistory![
                                                                            index]
                                                                        [
                                                                        'return_pnr_status']
                                                                    .toString() ==
                                                                'Confirmed'
                                                            ? Colors.green
                                                            : Colors
                                                                .orange[300],
                                                      ),
                                                    )
                                              : Text('')
                                          : SizedBox(),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            splashRadius: 20,
                                            // color: Colors.blue,
                                            onPressed: () async {
                                              if (await getUserPermission()) {
                                                print(
                                                    'User Permission granted flight');
                                                await downloadFile(
                                                    context,
                                                    userflighthistory![index]
                                                        ['id'],
                                                    userflighthistory![index]
                                                        ['from_city'],
                                                    userflighthistory![index]
                                                        ['to_city']);
                                              } else {
                                                print('User Permission denied');
                                              }
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.filePdf,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDetails(index);
                                            },
                                            child: Center(
                                              child: Text(
                                                'Details',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        // color: Colors.yellow,

                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            flightBookingCurrency! +
                                                ' ' +
                                                flightPrice.toStringAsFixed(2),
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    } else {
                      return showHistoryFlightDefaultPage();
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            ColorCodeGen.colorFromHex('#0e3957')),
                      ),
                    );
                  }
                } else {
                  log('connection not done=======');
                  return ConnectionErrorScreen();
                }
              },
            ),
          ])
        : showHistoryFlightDefaultPage();
  }

  Future<ConfirmAction?> confirmDialogFlightCancel(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          // backgroundColor: Colors.blueGrey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          // titlePadding: EdgeInsets.symmetric(vertical: 10),
          title: Text(
            'Cancel This Ticket?',
          ),
          content: const Text('This will cancel your Ticket.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            )
          ],
        );
      },
    );
  }

  Future<dynamic> cancelRequestFlightTicket(
      BuildContext context, int index, bool isReturn) async {
    // bool value = ;

    showProgressLoader(
        context, 'Sending request for cancel Ticket.', 'Please wait ...');

    initializeDataForEachBooking(index);
    var startAriportCode;
    var endAriportCode;
    var requestType;
    var pnrNumber;

    if (isDomestic == 'Yes') {
      if (isReturn) {
        startAriportCode = startAirportData['Origin']['Airport']['AirportCode'];
        endAriportCode =
            endAirportData['Destination']['Airport']['AirportCode'];
        pnrNumber = pnrNumberForReturn;
      } else {
        startAriportCode =
            returnstartAirportData['Origin']['Airport']['AirportCode'];
        endAriportCode =
            returnstartAirportData['Destination']['Airport']['AirportCode'];
        requestType = 'PartialCancellation';
        pnrNumber = pnrNumberForGoing;
      }
    } else {
      print('International flight cancel req=============');
      startAriportCode = startAirportData['Origin']['Airport']['AirportCode'];
      endAriportCode = endAirportData['Destination']['Airport']['AirportCode'];
      pnrNumber = pnrNumberForGoing;
      requestType = 'FullCancellation';
    }

    String cancelFlightBookingURL =
        'https://www.abengines.com/wp-content/plugins/adivaha//apps/modules/adivaha-fly-smart/apiflight_update_rates.php?action=FlightBookingCancellation&pid=${Strings.app_pid}&order_number=$orderIdFlight&pnr_number=$pnrNumber&IsDomesticReturn=$isDomestic&requestType=$requestType&ticketIds=&sectorsSelectors=$startAriportCode-$endAriportCode&remarks=test';

    var response = await http.get(Uri.parse(cancelFlightBookingURL));
    print('flight  booking  canceled ==============');
    print(cancelFlightBookingURL.toString());
    log(response.body);

    return jsonDecode(response.body);
  }

  Future<dynamic> cancelRequestFlightReturnTicket(
      BuildContext context, int index) async {
    // bool value = ;

    showProgressLoader(
        context, 'Sending request for cancel Ticket.', 'Please wait ...');
  }

  final GlobalKey<State> _keyLoaderFlight = new GlobalKey<State>();
  showProgressLoader(context, String title, String bodytext) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            key: _keyLoaderFlight,
            insetPadding: EdgeInsets.zero,
            // backgroundColor: Colors.blueGrey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
            contentTextStyle: TextStyle(color: Colors.black, fontSize: 14),
            // titlePadding: EdgeInsets.symmetric(vertical: 10),
            title: Text(
              title,
            ),
            content: Row(children: [
              Expanded(
                child: SizedBox(),
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.amber[500]),
              ),
              Expanded(
                child: SizedBox(),
              ),
              Text(
                bodytext,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ]),
          );
        });
  }

  Widget showHistoryFlightDefaultPage() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              // height: 250,
              // width: 350,
              child: Image.asset(
                'assets/history_flight.PNG',
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: Container(
            // color: Colors.red,
            child: Column(
              children: [
                Text(
                  'No search history found',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool? isLoading;
  downloadFile(BuildContext context, String? fileName, String? fromCity,
      String? toCity) async {
    var dirPath = await getPath() + '/' + fileName + '.pdf';
    log('diPatg========' + dirPath.toString());
    if (!await getUserPermission()) {
      await getUserPermission();
    }
    File f = File(dirPath);

    if (f.existsSync()) {
      await openLocalPDF(f.path);
    } else {
      String flightpdfURL =
          "https://www.abengines.com/tools/TCPDF/examples/ticket.html?id=$fileName";

      try {
        ProgressDialog progressDialog = ProgressDialog(context,
            dialogTransitionType: DialogTransitionType.BottomToTop,
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text("Downloading File"),
            ),
            defaultLoadingWidget: CircularProgIndicator(),
            message: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Please wait ..."),
            ));

        progressDialog.show();

        await dio.download(flightpdfURL, dirPath,
            onReceiveProgress: (rec, total) {
          setState(() {
            isLoading = true;
            log('rec=====' + rec.toString());
            log('total=====' + total.toString());
            progress = (((rec / -total) / 1000) + 80).toStringAsFixed(0) + "%";
            log('progress1=====' + progress.toString());
            progressDialog.setMessage(Text("Dowloading $progress"));
          });
        });

        progressDialog.dismiss();
        await openLocalPDF(f.path);
      } catch (e) {
        print(e.toString());
      }
    }

    // return taskId.toString();
  }

  Future<dynamic> getPath() async {
    // var dirPath = '';
    // if (Platform.isAndroid) {
    //   String _directory = await ExtStorage.getExternalStoragePublicDirectory(
    //       ExtStorage.DIRECTORY_DOWNLOADS);

    //   dirPath = '$_directory/';

    //   return dirPath;

    //   //APIKey.FILE_NAME: fileName;
    // } else if (Platform.isIOS) {
    //   Directory _directory = await getApplicationDocumentsDirectory();

    //   dirPath = '$_directory/';

    //   return dirPath;
    // }
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory =
        await new Directory(appDocDirectory.path).create(recursive: true);
    log(directory.toString());
    return directory.path;
  }

  Future<void> openLocalPDF(String path) async {
    log('openLOcalpdf file ');

    log('file=========' + path);
    await OpenFile.open(path);
  }

  Future<bool> getUserPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

enum ConfirmAction { Cancel, Accept }
