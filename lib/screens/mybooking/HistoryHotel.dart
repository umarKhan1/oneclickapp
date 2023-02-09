import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:ndialog/ndialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/helperwidgets/ConnectionErrorScreen.dart';
import 'package:oneclicktravel/helperwidgets/circularProgIndi.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:oneclicktravel/MyScheduleProvider.dart';

class HistoryHotelScreen extends StatefulWidget {
  HistoryHotelScreen({Key? key}) : super(key: key);

  @override
  _HistoryHotelScreenState createState() => _HistoryHotelScreenState();
}

class _HistoryHotelScreenState extends State<HistoryHotelScreen> {
  late SharedPreferences pref;
  String? user;
  List? userhotelhistory;

  String progress = "";
  late Dio dio;
  List? cancellationResponse;
  // 77A633
  // 77A7359
  String userhotelhistoryURL =
      'https://www.abengines.com/wp-content/themes/adivaha_main/fetch-hotel-data.php?pid=${Strings.app_pid}&emailz=';

  Future<void> openLocalPDF(String path) async {
    log('openLOcalpdf file ');

    log('file=========' + path);
    await OpenFile.open(path);
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

    //check connection end here

    dio = Dio();
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    //check connection start here
    _connectivitySubscription.cancel();
    //check connection end here
    _unbindBackgroundIsolate();
    super.dispose();
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

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future<http.Response> getUserHotelHistory(String userLogedInEmail) async {
    return await http.get(Uri.parse(userhotelhistoryURL + userLogedInEmail));
  }

  void getUser() async {
    // print(myUser.email.toString() + '===============');
    pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('signInUser');
    });

    print('user in hotelhistory');
    print(user);
  }

  List tableTitle = [
    'Room',
    'Adult',
    'Children',
    'Price',
  ];

  void showDetails(int index) {
    showModalBottomSheet(
        // elevation: 0,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: SizeConfig.blockSizeVertical! * 80,
            child: Column(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        height: 80,
                        width: 80,
                        child: Image.network(
                          userhotelhistory![index]['hotel_img'],
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/no_hotel_image.jpg',
                                fit: BoxFit.cover);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                userhotelhistory![index]['hotelName']
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              child: Text(
                                userhotelhistory![index]['hotelAddress']
                                    .toString(),
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.clear_sharp),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Divider(
                    height: 0,
                    color: Colors.blueGrey,
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            returnMyCheckinCheckoutRow(index),
                            const SizedBox(
                              height: 10,
                            ),
                            returnMyGuestRoomStatusRow(index),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Divider(
                          height: 0,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      userhotelhistory![index]
                                                      ['cancellationNumber'] !=
                                                  null &&
                                              userhotelhistory![index]
                                                      ['cancellation_date'] !=
                                                  null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                'Cancelled on ' +
                                                    formatter
                                                        .format((DateTime.parse(
                                                            userhotelhistory![index]['cancellation_date']
                                                                .toString())))
                                                        .toString()
                                                        .substring(
                                                            5,
                                                            formatter
                                                                .format((DateTime.parse(userhotelhistory![index]['cancellation_date']
                                                                    .toString())))
                                                                .toString()
                                                                .length)
                                                        .substring(0, 3) +
                                                    ', ' +
                                                    formatter
                                                        .format((DateTime.parse(
                                                            userhotelhistory![index]['cancellation_date']
                                                                .toString())))
                                                        .toString()
                                                        .substring(0, 2) +
                                                    ' ' +
                                                    formatter
                                                        .format((DateTime.parse(userhotelhistory![index]['cancellation_date'].toString())))
                                                        .toString()
                                                        .substring(2, 5),

                                                // userhotelhistory[index]
                                                //         ['cancellation_date']

                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 10,
                                            ),
                                      Text(
                                        userhotelhistory![index]['itineraryId']
                                                    .toString() !=
                                                ""
                                            ? 'Booking Id : ' +
                                                userhotelhistory![index]
                                                        ['itineraryId']
                                                    .toString()
                                            : 'Booking Id : ' + 'unknown!',
                                        style: TextStyle(
                                          color: userhotelhistory![index]
                                                          ['itineraryId']
                                                      .toString() !=
                                                  ""
                                              ? Colors.black
                                              : Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          'Total Price: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        userhotelhistory![index]
                                                        ['currency_code']
                                                    .toString() ==
                                                "INR"
                                            ? '₹ ' +
                                                userhotelhistory![index]
                                                        ['chargable_rate']
                                                    .toString()
                                            : userhotelhistory![index]
                                                        ['currency_code']
                                                    .toString() +
                                                userhotelhistory![index]
                                                        ['chargable_rate']
                                                    .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                // height: 0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              userhotelhistory![index]['itineraryId'] != null
                                  ? 'Order Id : ' +
                                      userhotelhistory![index]['order_id']
                                          .toString()
                                  : 'Order Id : ' + 'unknown!',
                              style: TextStyle(
                                color: userhotelhistory![index]
                                            ['itineraryId'] !=
                                        null
                                    ? Colors.black
                                    : Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          // height: 0,
                          color: Colors.blueGrey,
                        ),
                      ),
                      returnMyCancellationPolicy(
                          index,
                          int.parse(jsonDecode(userhotelhistory![index]
                              ['rest_data'])['noofRooms'])),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          // height: 0,

                          color: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.black12,
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal[100]!),
                            columnSpacing: 25,
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey[100]!),
                            columns: [
                              for (int i = 0; i < 4; i++)
                                returnTableColumn(tableTitle[i]),
                            ],
                            rows: [
                              for (int i = 0;
                                  i <
                                      int.parse(jsonDecode(
                                          userhotelhistory![index]
                                              ['rest_data'])['noofRooms']);
                                  i++)
                                returnTableRow(
                                    i,
                                    index,
                                    int.parse(jsonDecode(
                                        userhotelhistory![index]
                                            ['rest_data'])['noofRooms'])),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                        ),
                      ),
                      returnTotalCostGstRow(index),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget returnCancellationDateRow(index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cancellation Number : ' +
                userhotelhistory![index]['cancellationNumber'].toString(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Cancellation Date : ' +
                userhotelhistory![index]['cancellation_date'].toString(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  returnMyCancellationPolicy(int index, int totalRoom) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cancellation Policy',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            height: 10,
          ),
          for (int i = 0; i < totalRoom; i++)
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[400],
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('R' + (i + 1).toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: jsonDecode(userhotelhistory![index]
                                    ['rest_data'])['cancellationPolicy'] !=
                                null
                            ? Text(jsonDecode(userhotelhistory![index]
                                ['rest_data'])['cancellationPolicy'][i][0])
                            : Text('')),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
        ],
      ),
    );
  }

  returnTableColumn(String title) {
    return DataColumn(
        label: Text(title,
            style: const TextStyle(

                // fontSize: 16,
                fontWeight: FontWeight.normal)));
  }

  returnTableRow(int roomNO, int index, int totalRoom) {
    return DataRow(cells: [
      DataCell(Text((roomNO + 1).toString())),
      DataCell(Text((jsonDecode(userhotelhistory![index]['rest_data'])['packs']
              [0]['adults'])
          .toString()
          .split(',')[roomNO])),
      DataCell(Text((jsonDecode(userhotelhistory![index]['rest_data'])['packs']
              [0]['childs'])
          .toString()
          .split(',')[roomNO]
          .toString())),
      DataCell(Text('₹ ' +
          jsonDecode(userhotelhistory![index]['rest_data'])['roomPrice'][roomNO]
              .toString())),
    ]);
  }

  Widget returnTotalCostGstRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 45,
        color: Colors.grey[100],
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Total Cost ',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                VerticalDivider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
                Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    '₹ ' +
                        userhotelhistory![index]['chargable_rate'].toString(),
                    style: TextStyle(fontFamily: 'Helvetica'),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  returnMyGuestRoomStatusRow(int index) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Rooms : ',
                    // overflow:
                    //     TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '${jsonDecode(userhotelhistory![index]['rest_data'])['noofRooms']} Room',
                          style: TextStyle(
                              color: userhotelhistory![index]['booking_status']
                                          .toString() !=
                                      'Failed'
                                  ? Colors.black
                                  : Colors.red,
                              fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // navigate to desired screen
                            })
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: 'Guests : ',
                    // overflow:
                    //     TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: userhotelhistory![index]['booking_status'] !=
                                  'Failed'
                              ? ('$totalHotelGuest Guest')
                              : 'unknown!',
                          style: TextStyle(
                              color: userhotelhistory![index]['booking_status']
                                          .toString() !=
                                      'Failed'
                                  ? Colors.black
                                  : Colors.red,
                              fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // navigate to desired screen
                            })
                    ]),
              ),
            ],
          ),
          VerticalDivider(
            color: Colors.grey[400],
            thickness: 1,
          ),
          Column(
            children: [
              Text('Status : '),
              Text(
                userhotelhistory![index]['booking_status'].toString(),
                style: TextStyle(
                    color:
                        userhotelhistory![index]['booking_status'].toString() !=
                                'Failed'
                            ? userhotelhistory![index]['booking_status']
                                        .toString() ==
                                    'Confirmed'
                                ? Colors.green
                                : Colors.orange[300]
                            : Colors.red,
                    fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }

  returnMyCheckinCheckoutRow(int index) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHECK-IN',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_in'].toString())))
                        .toString()
                        .substring(
                            5,
                            formatter
                                .format((DateTime.parse(userhotelhistory![index]
                                        ['check_in']
                                    .toString())))
                                .toString()
                                .length)
                        .substring(0, 3) +
                    ', ' +
                    formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_in'].toString())))
                        .toString()
                        .substring(0, 2) +
                    ' ' +
                    formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_in'].toString())))
                        .toString()
                        .substring(2, 5),
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 45,
              width: 60,
              child: Lottie.asset(
                'assets/lottieAnimations/74927-clear-night-moon.json',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              // margin: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              child: Text(
                (DateTime.parse(
                            userhotelhistory![index]['check_out'].toString()))
                        .difference(DateTime.parse(
                            userhotelhistory![index]['check_in'].toString()))
                        .inDays
                        .toString() +
                    ' Nights',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHECK-OUT',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_out'].toString())))
                        .toString()
                        .substring(
                            5,
                            formatter
                                .format((DateTime.parse(userhotelhistory![index]
                                        ['check_out']
                                    .toString())))
                                .toString()
                                .length)
                        .substring(0, 3) +
                    ', ' +
                    formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_out'].toString())))
                        .toString()
                        .substring(0, 2) +
                    ' ' +
                    formatter
                        .format((DateTime.parse(
                            userhotelhistory![index]['check_out'].toString())))
                        .toString()
                        .substring(2, 5),
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  final GlobalKey<State> _keyLoaderHotel = new GlobalKey<State>();
  var formatter = new DateFormat('ddMMMEEEE');
  late int totalHotelGuest;

  @override
  Widget build(BuildContext context) {
    final myScheduleProvider = Provider.of<MyScheduleProvider>(context);

    return user != null
        ? FutureBuilder(
            future: getUserHotelHistory(context.read<MyUser>().email!),
            builder: (context, AsyncSnapshot snapshot) {
              if (_connectionStatus != 'ConnectivityResult.none') {
                log('connection done=======' + _connectionStatus.toString());
                if (snapshot.hasData) {
                  log('connection done and has data=======');
                  userhotelhistory = jsonDecode(snapshot.data.body);
                  if (userhotelhistory != null) {
                    print('got snapshot data');
                    //  print(userhotelhistory);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: userhotelhistory!.length,
                        itemBuilder: (context, index) {
                          totalHotelGuest = 0;

                          // log(jsonDecode(userhotelhistory![index]['rest_data'])[
                          //     'packs'][0]['childs']);

                          log(jsonDecode(userhotelhistory![index]['rest_data'])[
                              'noofRooms']);

                          int adultLength = int.parse(
                              jsonDecode(userhotelhistory![index]['rest_data'])[
                                  'packs'][0]['adults']);

                          int childLength = int.parse(
                              jsonDecode(userhotelhistory![index]['rest_data'])[
                                  'packs'][0]['childs']);

                          for (int i = 0; i < adultLength; i++) {
                            totalHotelGuest = totalHotelGuest +
                                int.parse((jsonDecode(userhotelhistory![index]
                                    ['rest_data'])['packs'][i]['adults']));
                          }

                          for (int i = 0; i < childLength; i++) {
                            totalHotelGuest = totalHotelGuest +
                                int.parse(jsonDecode(userhotelhistory![index]
                                    ['rest_data'])['packs'][i]['childs']);
                          }

                          return Container(
                            color: Colors.grey[200],
                            child: Padding(
                              // padding: EdgeInsets.all(5.0),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                // color: Colors.red,
                                // borderOnForeground: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            child: Image.network(
                                              userhotelhistory![index]
                                                  ['hotel_img'],
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                    'assets/no_hotel_image.jpg',
                                                    fit: BoxFit.cover);
                                              },
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userhotelhistory![index]
                                                          ['hotelName']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  // crossAxisAlignment:
                                                  //     CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.map_sharp,
                                                      color: Colors.blueGrey,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Text(
                                                        userhotelhistory![index]
                                                                ['hotelAddress']
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Helvetica'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.date_range_sharp,
                                                      color: Colors.blueGrey,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Text(
                                                        'Booked on ' +
                                                            formatter
                                                                .format((DateTime.parse(
                                                                    userhotelhistory![index]['date_time']
                                                                        .toString())))
                                                                .toString()
                                                                .substring(
                                                                    5,
                                                                    formatter
                                                                        .format((DateTime.parse(userhotelhistory![index]['date_time']
                                                                            .toString())))
                                                                        .toString()
                                                                        .length) +
                                                            ', ' +
                                                            formatter
                                                                .format((DateTime.parse(
                                                                    userhotelhistory![index]['date_time']
                                                                        .toString())))
                                                                .toString()
                                                                .substring(
                                                                    0, 2) +
                                                            ' ' +
                                                            formatter
                                                                .format((DateTime.parse(userhotelhistory![index]['date_time'].toString())))
                                                                .toString()
                                                                .substring(2, 5) +
                                                            ' for',
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Helvetica'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      // thickness: 1,
                                      height: 0,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: returnMyCheckinCheckoutRow(index),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: returnMyGuestRoomStatusRow(index),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      // thickness: 1,
                                      height: 0,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: DateTime.now().compareTo(
                                                  DateTime.parse(
                                                      userhotelhistory![index]
                                                              ['check_in']
                                                          .toString())) <
                                              0
                                          ? userhotelhistory![index]
                                                          ['booking_status']
                                                      .toString() ==
                                                  'Confirmed'
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    final ConfirmAction?
                                                        action =
                                                        await _asyncConfirmDialog(
                                                            context);
                                                    if (action ==
                                                        ConfirmAction.Accept) {
                                                      cancellationResponse =
                                                          // ignore: use_build_context_synchronously
                                                          await (cancelRequestHotelBooking(
                                                                  context,
                                                                  index)
                                                              as FutureOr<
                                                                  List<
                                                                      dynamic>?>);
                                                      log(cancellationResponse
                                                          .toString());
                                                      if (cancellationResponse![
                                                                      0][
                                                                  'booking_status'] ==
                                                              'Cancelled' &&
                                                          cancellationResponse![
                                                                      0][
                                                                  'cancellationNumber'] !=
                                                              null) {
                                                        myScheduleProvider
                                                                .showCancelHotelBooking =
                                                            true;

                                                        Navigator.of(
                                                          _keyLoaderHotel
                                                              .currentContext!,
                                                        ).pop();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Booking Cancelled Successfully");
                                                      } else {
                                                        print(
                                                            'else cancel===========');
                                                        Navigator.of(
                                                          _keyLoaderHotel
                                                              .currentContext!,
                                                        ).pop();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Something Went Wrong!");
                                                      }
                                                    }
                                                    print(
                                                        "Confirm Action $action");
                                                  },
                                                  child: Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .baseline,
                                                    children: const [
                                                      Icon(
                                                        FontAwesomeIcons.ban,
                                                        color: Colors.blue,
                                                        // textDirection: ,
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        child: Text(
                                                          'Cancel booking',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : userhotelhistory![index][
                                                          'cancellation_date'] !=
                                                      null
                                                  ? Row(
                                                      children: [
                                                        Icon(Icons.cancel,
                                                            color: Colors.red,
                                                            // textDirection: ,
                                                            size: 16),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: Text(
                                                              'Cancelled on ' +
                                                                  formatter
                                                                      .format((DateTime.parse(userhotelhistory![index]
                                                                              [
                                                                              'cancellation_date']
                                                                          .toString()
                                                                          .toString())))
                                                                      .toString()
                                                                      .substring(
                                                                          5,
                                                                          formatter
                                                                              .format((DateTime.parse(userhotelhistory![index]['cancellation_date']
                                                                                  .toString())))
                                                                              .toString()
                                                                              .length)
                                                                      .substring(
                                                                          0,
                                                                          3) +
                                                                  ', ' +
                                                                  formatter.format((DateTime.parse(userhotelhistory![index]['cancellation_date'].toString()))).toString().substring(
                                                                      0, 2) +
                                                                  ' ' +
                                                                  formatter
                                                                      .format(
                                                                          (DateTime.parse(userhotelhistory![index]['cancellation_date'].toString())))
                                                                      .toString()
                                                                      .substring(2, 5),

                                                              // userhotelhistory[index]
                                                              //         ['cancellation_date']

                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  : Text(
                                                      userhotelhistory![index]
                                                              ['booking_status']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: userhotelhistory![
                                                                            index]
                                                                        [
                                                                        'booking_status']
                                                                    .toString() ==
                                                                'Confirmed'
                                                            ? Colors.green
                                                            : Colors
                                                                .orange[300],
                                                      ),
                                                    )
                                          : Text(
                                              userhotelhistory![index]
                                                      ['booking_status']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: userhotelhistory![index][
                                                                'booking_status']
                                                            .toString() ==
                                                        'Confirmed'
                                                    ? Colors.green
                                                    : Colors.orange[300],
                                              ),
                                            ),
                                    ),
                                    Divider(
                                      // thickness: 1,
                                      height: 0,
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
                                              // color: Colors.blueGrey,
                                              // minWidth: 50,
                                              onPressed: () async {
                                                if (await getUserPermission()) {
                                                  print(
                                                      'User Permission granted');
                                                  // progress = 0;
                                                  var response = await downloadHotelBookingPDF(
                                                      context,
                                                      userhotelhistory![index][
                                                                      'order_id']
                                                                  .toString() !=
                                                              null
                                                          ? userhotelhistory![
                                                                      index]
                                                                  ['order_id']
                                                              .toString()
                                                          : '');
                                                  log('downoad=============pdf hotel ' +
                                                      response.toString());
                                                }
                                              },
                                              icon: Icon(
                                                  FontAwesomeIcons.filePdf,
                                                  color: Colors.blueAccent),
                                              tooltip: 'Download pdf',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: ElevatedButton(
                                              // color: Colors.green,
                                              // minWidth: 50,
                                              onPressed: () {
                                                showDetails(index);
                                              },
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
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            // onPressed: (){},
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                userhotelhistory![index][
                                                                'currency_code']
                                                            .toString() ==
                                                        "INR"
                                                    ? '₹ ' +
                                                        userhotelhistory![index]
                                                                [
                                                                'chargable_rate']
                                                            .toString()
                                                    : userhotelhistory![index][
                                                                'currency_code']
                                                            .toString() +
                                                        userhotelhistory![index]
                                                                [
                                                                'chargable_rate']
                                                            .toString(),
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return showHistoryHotelPage();
                  }
                } else {
                  log('connection done and has not data=======');
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
          )
        : showHistoryHotelPage();
  }

  Future<bool> getUserPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory =
        await new Directory(appDocDirectory.path).create(recursive: true);
    log(directory.toString());
    return directory.path;
  }

  bool? isLoading;

  Future downloadHotelBookingPDF(
      BuildContext context, String hotelBookingOrderId) async {
    var dirPath = await getPath() + '/' + hotelBookingOrderId + '.pdf';
    if (!await getUserPermission()) {
      await getUserPermission();
    }
    File f = File(dirPath);

    if (f.existsSync()) {
      await openLocalPDF(f.path);
    } else {
      var hotelBookingPDFURL =
          "https://www.abengines.com/tools/TCPDF/examples/hotelsbed-voucher.html?order_number=$hotelBookingOrderId";

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

        await dio.download(hotelBookingPDFURL, dirPath,
            onReceiveProgress: (rec, total) {
          setState(() {
            isLoading = true;
            log('rec=====' + rec.toString());
            log('total=====' + total.toString());
            progress = (((rec / -total) / 1000) + 86).toStringAsFixed(0) + "%";
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
  }

  showProgressLoader(context, String title, String bodytext) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            key: _keyLoaderHotel,
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

  Future<dynamic> cancelRequestHotelBooking(
      BuildContext context, int index) async {
    // bool value = ;

    showProgressLoader(
        context, 'Sending request for cancel booking.', 'Please wait ...');

    var currentHotelItineraryId =
        userhotelhistory![index]['itineraryId'].toString();

    String cancelHotelBookingURL =
        'https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/adivaha-hotelbeds/update_rates.php?action=BookingCancellation&pid=${Strings.app_pid}&itineraryId=$currentHotelItineraryId&reason=&isMobile=1';

    var response = await http.get(Uri.parse(cancelHotelBookingURL));

    return jsonDecode(response.body);
  }

  Future<ConfirmAction?> _asyncConfirmDialog(BuildContext context) async {
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
            'Cancel This Booking?',
          ),
          content: const Text('This will cancel your booking.'),
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

  Widget showHistoryHotelPage() {
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
                'assets/history_hotel.jpg',
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
                  style: TextStyle(fontSize: 16),
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
}

enum ConfirmAction { Cancel, Accept }
