import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oneclicktravel/AboutUsScreen.dart';
import 'package:oneclicktravel/HistoryScreen.dart';
import 'package:oneclicktravel/HotelRoomsSelect.dart';
import 'package:oneclicktravel/Model/CountryListModel.dart';
import 'package:oneclicktravel/Model/FetchUpdateCustomerDetails.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/Model/selectedHotelData.dart';
import 'package:oneclicktravel/MyScheduleProvider.dart';
import 'package:oneclicktravel/SettingScreen.dart';
import 'package:oneclicktravel/customedate/CustomeDateScreen.dart';
import 'package:oneclicktravel/screens/myaccount/UserProfileScreen.dart';
import 'package:oneclicktravel/utils/ModuleName.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:oneclicktravel/utils/size_config.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoginScreen.dart';
import 'backend_files/serach_place.dart';
import 'flightUI.dart';
import 'hotel_detail.dart';

class HotelUI extends StatefulWidget {
  final tabIndex;
  HotelUI({this.tabIndex});
  @override
  HotelUIState createState() => HotelUIState();
}

const List<String> tabNames = <String>['Hotel', 'Flight'];

class HotelUIState extends State<HotelUI> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  TextEditingController _hotelSearchFieldcontroller = TextEditingController();
  TextEditingController _controllerNationality = TextEditingController();
  TextEditingController _controllerRooms = TextEditingController();
  int _screen = 0;
  var rooms;
  var totalAdult;
  var totalChild;
  var destination;
  var hotelsearchedCountryCode;
  var cityid;
  var currentTabIndex = 0;

  String adultParam = '';
  String childParam = '';
  String childAgeParam = '';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController departuredate = TextEditingController();
  TextEditingController returndate = TextEditingController();

  String hotelNationalityCountry = '';
  String? hotelNationalityCountryCode = '';
  String? user;
  static MyUser? myUser;
  String? lastSelectedCurrency = 'INR';
  List<DateTime>? checkincheckoutdate;
  late MyScheduleProvider myProvider;

  @override
  void initState() {
    // myProvider = context.watch<MyScheduleProvider>();

    _tabController = TabController(vsync: this, length: tabNames.length);

    _hotelSearchFieldcontroller.text = 'Where ?';

    _controllerRooms.text = '1 Room, 1 Adult';

    super.initState();
    getvalue();
  }

  getvalue() async {
    departuredate.text = context.read<ModuleName>().departureDate!;
    returndate.text = context.read<ModuleName>().returnDate!;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cityid = prefs.getString("hotel_city_code");
    user = prefs.getString("signInUser");
    // print(rooms);
    // print(adults);

    if (user != null) {
      var mapUser = jsonDecode(user!);
      log(mapUser.toString());
      myUser = context.read<MyUser>().fromJson(mapUser);
      //fetch user profile
      if (context.read<MyUser>().email != null &&
          context.read<MyUser>().userid != null) {
        // context.read<FetchUpdateCustomerDetails>().setStatus(false);
        if (await context
                .read<FetchUpdateCustomerDetails>()
                .fetchCustomerDetails(context.read<MyUser>().email,
                    context.read<MyUser>().userid) !=
            null) {
          final CountryListModel countryListModel = CountryListModel();
          for (int i = 0; i < countryListModel.countryList.length; i++) {
            if (countryListModel.countryList
                    .elementAt(i)['country_code']!
                    .toLowerCase() ==
                context
                    .read<FetchUpdateCustomerDetails>()
                    .countryCode!
                    .toLowerCase()) {
              context.read<FetchUpdateCustomerDetails>().countryName =
                  countryListModel.countryList.elementAt(i)['country_name'];
            }
          }
        }
      }
    }
    setState(() {
      if (prefs.getInt("total_room") != null &&
          prefs.getInt("total_adult") != null) {
        rooms = prefs.getInt("total_room");
        totalAdult = prefs.getInt("total_adult");

        _controllerRooms.text =
            rooms.toString() + ' Room, ' + totalAdult.toString() + ' Adult';
        // print(_controllerRooms.text);
        totalChild = prefs.getInt("total_children");
        if (totalChild == null) {
          totalChild = 0;
          childParam = '0';
          childAgeParam = '0';
        } else {
          childParam = prefs.getString('childParam')!;

          childAgeParam = prefs.getString('child_age_param')!;
        }
        if (prefs.getString('adultParam') != null) {
          adultParam = prefs.getString('adultParam')!;
        } else {
          adultParam = '1';
        }

        print('totalChild=================$totalChild');
      } else {
        adultParam = '1';
        childParam = '0';
        childAgeParam = '0';
        rooms = '1';
        totalAdult = 1;
        totalChild = 0;
        print('totalChild=================$totalChild');
      }
    });

    destination = prefs.getString("hotel_destination");
  }

  void launchWhatsApp() async {
    const String whatsappText =
        "Hello Oneclick Travel,\n\nI would Like to talk to you regarding booking.";
    String uri =
        'https://wa.me/+917906705105?text=${Uri.encodeComponent(whatsappText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch';
    }
  }

  DateTime? lastSelecteddatereturn;

  var checkdate = false;

  String companyEmail = Strings.companyEmail;
  void launchEmail() async {
    const String subject = "Feedback";
    const String stringText =
        "Hello Oneclick Travel,\n\nI would Like to see the following improvements in your app :\n\n 1.\n\n\n2.\n\n\n";
    String uri =
        'mailto:$companyEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch';
    }
  }

  // MyScheduleProvider myProvider;
  setNationalitity(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString('nationalityCountryName') != null &&
          prefs.getString('nationalityCountryCode') != null) {
        log('setState=======nationalityCountryCode=====not null if=');
        hotelNationalityCountry =
            prefs.getString('nationalityCountryName').toString();
        hotelNationalityCountryCode =
            prefs.getString('nationalityCountryCode').toString();
      } else {
        if (value) {
          log('setState=======nationalityCountryCode======');
          log(prefs.getString('selected_country_name').toString());
          log(prefs.getString('selected_country_code').toString());
          hotelNationalityCountryCode =
              prefs.getString('selected_country_code').toString();
          hotelNationalityCountry =
              prefs.getString('selected_country_name').toString();
        } else {
          hotelNationalityCountryCode = "IN";
          hotelNationalityCountry = "India";
        }
      }
      issetGeoSettings = true;
    });

    // }
  }

  String? lastSelectedCountry = '';
  getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      lastSelectedCountry = prefs.getString('nationalityCountryName');
    });
  }

  bool issetGeoSettings = false;

  Future<bool> _onWillPop() async {
    if (await returnLogoutPopup()) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<dynamic> returnLogoutPopup() {
    var statusExit = showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          title: Text(
            'Oneclick Travel',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20)),
          ),
          content: Text(
            "Are You Sure You Want To Exit ?",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    // fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 16)),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.

                Navigator.pop(context, true);
              },
            ),
            ElevatedButton(
              child: const Text("CANCEL"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.

                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
    // log('statusExit====================$statusExit');
    return statusExit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: tabNames.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          drawer: Container(
            // margin: EdgeInsets.zero,
            width: SizeConfig.blockSizeHorizontal * 76,

            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                // padding: const EdgeInsets.all(0.0),
                children: [
                  // Container(
                  //   child: Image.asset("assets/date_picker.png"),
                  //   height: 0,
                  //   width: 0,
                  // ),
                  Container(
                    // color: Colors.red,
                    child: Stack(children: [
                      // ignore: missing_required_param
                      Container(
                        height: SizeConfig.blockSizeVertical * 35,
                        // ignore: missing_required_param
                        child: DrawerHeader(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/back.jpg"),
                                fit: BoxFit.cover),
                            // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                          ),
                          child: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // child:Stack(

                      //      children:[
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 76,
                        height: SizeConfig.blockSizeVertical * 35,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              ColorCodeGen.colorFromHex('#ffffff')
                                  .withOpacity(0.5),
                              ColorCodeGen.colorFromHex('#000000')
                                  .withOpacity(0.5),
                            ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                      ),
                      /* Positioned(
                          bottom: 70,
                          left: SizeConfig.blockSizeHorizontal * 10,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 16,
                            width: SizeConfig.blockSizeHorizontal * 60,
                            // color: Colors.blue,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                    fit: BoxFit.cover)),
                            // ignore: missing_required_param
                          )
                          // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),

                          ),*/
                      context.watch<MyUser>().email == null
                          ? Positioned(
                              bottom: 16,
                              left: SizeConfig.blockSizeHorizontal * 4,
                              child: InkWell(
                                onTap: () async {
                                  HapticFeedback.vibrate();
                                  Navigator.pop(context);
                                  await Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: LoginScreen(),
                                      ));
                                },
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal * 68,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     spreadRadius: 3,
                                    //     color: Colors.transparent,
                                    //   )
                                    // ]
                                    // image: DecorationImage(
                                    //     image: AssetImage('assets/logo.png'),
                                    //     fit: BoxFit.fill),
                                  ),
                                  child: const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    ColorCodeGen.colorFromHex('#0e3957')
                                        .withOpacity(0.1),

                                    // ColorCodeGen.colorFromHex('#8a6d3b')
                                    //     .withOpacity(0.5),
                                    ColorCodeGen.colorFromHex('#0e3957')
                                        .withOpacity(0.2),
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeVertical * 2),
                              height: SizeConfig.blockSizeVertical * 35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: Image.asset(
                                        'assets/avtar.png',
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    context.read<MyUser>().name! +
                                        ' ' +
                                        context.read<MyUser>().lname!,
                                    style: const TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    context.read<MyUser>().email!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      HapticFeedback.vibrate();
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: UserProfileScreen()),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Container(
                                        height: 40.0,
                                        margin: const EdgeInsets.only(top: 6.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.transparent,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'View Profile',
                                            style: TextStyle(
                                                letterSpacing: 0.3,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ]),
                  ),

                  ListTile(
                    leading: Icon(LineIcons.hotel,
                        size: 25,
                        color: _tabController!.index == 0
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    // tileColor: Colors.white10,
                    title: Text(
                      'Hotels',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 0
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      setState(() {
                        _tabController!.index = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(LineIcons.plane,
                        size: 25,
                        color: _tabController!.index == 1
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    tileColor: Colors.white10,
                    title: Text(
                      'Flights',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 1
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      setState(() {
                        _tabController!.index = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    leading: Icon(LineIcons.history,
                        size: 25,
                        color: _tabController!.index == 3
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    // tileColor: Colors.white10,
                    title: Text(
                      'My Bookings',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 3
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(LineIcons.cog,
                        size: 25,
                        color: _tabController!.index == 5
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    tileColor: Colors.white10,
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 5
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () async {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                      await Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SettingScreen(),
                          ));
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        user = prefs.getString("signInUser");
                        print(user);
                        if (user == null) {
                          myUser = null;
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: FaIcon(LineIcons.whatSApp,
                        size: 25,
                        color: _tabController!.index == 6
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    tileColor: Colors.white10,
                    title: Text(
                      'Contact us',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 6
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                      launchWhatsApp();
                    },
                  ),
                  ListTile(
                    leading: Icon(LineIcons.comment,
                        size: 25,
                        color: _tabController!.index == 7
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    tileColor: Colors.white10,
                    title: Text(
                      'Submit Feedback',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 7
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                      launchEmail();
                    },
                  ),
                  ListTile(
                    leading: Icon(LineIcons.infoCircle,
                        size: 25,
                        color: _tabController!.index == 8
                            ? ColorCodeGen.colorFromHex('#ffd022')
                            : Colors.grey[700]),
                    tileColor: Colors.white10,
                    title: Text(
                      'About us',
                      style: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: 16,
                          color: _tabController!.index == 8
                              ? ColorCodeGen.colorFromHex('#ffd022')
                              : Colors.grey[700]),
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const AboutUs(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: List<Widget>.generate(tabNames.length, (int index) {
                  return Container(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: index == 0
                          ? Column(children: [
                              Container(
                                height: 0,
                                // width: 350,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/back.jpg"),
                                      fit: BoxFit.cover),
                                  // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                                ),
                              ),

                              Container(
                                height: 0,
                                // width: 350,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/plane.webp"),
                                      fit: BoxFit.cover),
                                  // color: ColorCodeGen.colorFromHex('#2A4058').withOpacity(0.8),
                                ),
                              ),
                              //this is pre loaded image in RAM for flight page
                              Expanded(
                                child: Container(
                                  width: SizeConfig.screenWidth,
                                  // height: SizeConfig.screenHeight/2,
                                  height: SizeConfig.blockSizeVertical * 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: const AssetImage(
                                      "assets/hotel.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  )),

                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          ColorCodeGen.colorFromHex('#ffd022')
                                              .withOpacity(0.5),
                                          ColorCodeGen.colorFromHex('#000000')
                                              .withOpacity(0.8),
                                        ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Container(
                                      // color: Colors.red,
                                      //  height: SizeConfig.blockSizeVertical*25,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.blockSizeVertical *
                                                43.9),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.grey,
                                              onTap: () async {
                                                HapticFeedback.vibrate();
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child:
                                                            const SearchFromHotel()));
                                                // setState(() {
                                                //   hotelselecteddestination =
                                                //       _controller.text;

                                                //   cityid = prefs.getString(
                                                //       'hotel_city_code');

                                                //   hotelsearchedCountryCode =
                                                //       prefs.getString(
                                                //           'hotel_CountryCode');
                                                // });
                                                if (context
                                                        .read<
                                                            SelectedHotelData>()
                                                        .hotelCityName ==
                                                    null) {
                                                  log('==================hotel city name if' +
                                                      context
                                                          .read<
                                                              SelectedHotelData>()
                                                          .hotelCityName
                                                          .toString());
                                                } else {
                                                  _hotelSearchFieldcontroller
                                                          .text =
                                                      context
                                                          .read<
                                                              SelectedHotelData>()
                                                          .hotelCityName!;
                                                  log('else===========' +
                                                      context
                                                          .read<
                                                              SelectedHotelData>()
                                                          .hotelCityName
                                                          .toString());
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0)),
                                                  // color: Colors.white,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      100,
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      6,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 0.0),
                                                            child: Text(
                                                              _hotelSearchFieldcontroller
                                                                  .text,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons.search,
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),

                                            //sarfaraz
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 10,),
                              Container(
                                color: Colors.white,
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.blockSizeVertical * 50,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        HapticFeedback.vibrate();

                                        await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (route) =>
                                                    CustomeDateScreen(
                                                        isRangeMode: true,
                                                        type:
                                                            'HotelCalender')));
                                        setState(() {
                                          departuredate.text = context
                                              .read<ModuleName>()
                                              .departureDate!;
                                          returndate.text = context
                                              .read<ModuleName>()
                                              .returnDate!;
                                        });
                                      },
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 12,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  'CHECK-IN',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0,
                                                              top: 6),
                                                      child: Text(
                                                        departuredate.text
                                                            .split(' ')[0],
                                                        style: TextStyle(
                                                            color: ColorCodeGen
                                                                .colorFromHex(
                                                                    '#ffd022'),
                                                            fontSize: 30),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          departuredate.text
                                                              .split(' ')[1],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                        Text(
                                                          departuredate.text
                                                              .split(' ')[2],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      7,
                                              width: 1,
                                              color: Colors.grey,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  'CHECK-OUT',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0,
                                                              top: 6),
                                                      child: Text(
                                                        returndate.text
                                                            .split(' ')[0],
                                                        style: TextStyle(
                                                            color: ColorCodeGen
                                                                .colorFromHex(
                                                                    '#ffd022'),
                                                            fontSize: 30),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          returndate.text
                                                              .split(' ')[1],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                        Text(
                                                          returndate.text
                                                              .split(' ')[2],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        HapticFeedback.vibrate();

                                        List? totalHotelRoomData =
                                            await Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: HotelRoomsSelect()));

                                        if (totalHotelRoomData != null) {
                                          totalAdult = 0;
                                          totalChild = 0;
                                          setState(() {
                                            adultParam = '';
                                            childParam = '';
                                            childAgeParam = '';
                                            rooms = int.parse(
                                                totalHotelRoomData[0]);
                                          });

                                          var totalRoom =
                                              totalHotelRoomData[0] + ' Room, ';

                                          int i = 0;
                                          while (i <
                                              int.parse(
                                                  totalHotelRoomData[0])) {
                                            if (i != 0) {
                                              childAgeParam += '-';
                                            }
                                            if (i != 0) {
                                              adultParam += ',';
                                              childParam += ',';
                                            }
                                            totalAdult += int.parse(
                                                totalHotelRoomData[1][i]);
                                            adultParam +=
                                                totalHotelRoomData[1][i];
                                            totalChild += int.parse(
                                                totalHotelRoomData[2][i]);
                                            childParam +=
                                                totalHotelRoomData[2][i];
                                            int j = 0;
                                            while (j <
                                                int.parse(
                                                    totalHotelRoomData[2][i])) {
                                              if (j != 0) {
                                                childAgeParam += ',';
                                              } else {
                                                childAgeParam +=
                                                    i.toString() + '_';
                                              }

                                              childAgeParam +=
                                                  totalHotelRoomData[3][i][j];
                                              j++;
                                            }
                                            if (j == 0) {
                                              childAgeParam += i.toString();
                                            }

                                            i++;
                                          }

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          prefs.setInt('total_room', rooms);
                                          prefs.setInt(
                                              'total_adult', totalAdult);
                                          prefs.setInt(
                                              'total_child', totalChild);
                                          prefs.setString(
                                              'child_age_param', childAgeParam);

                                          prefs.setString(
                                              'adultParam', adultParam);
                                          prefs.setString(
                                              'childParam', childParam);

                                          setState(() {
                                            // totalAdultData =
                                            //     totalAdult.toString();

                                            _controllerRooms.text = totalRoom +
                                                totalAdult.toString() +
                                                ' Adult';
                                            if (totalChild != 0) {
                                              // totalChildData = totalChild.toString();

                                              _controllerRooms.text += ', ' +
                                                  totalChild.toString() +
                                                  ' Children';
                                            }

                                            //  else {
                                            //   totalChildData = '';
                                            // }
                                          });
                                          print(
                                              'childParam=============$childParam');
                                          print(
                                              'adultParam=============$adultParam');
                                          print(
                                              'childAgeParam=============$childAgeParam');
                                        }
                                      },
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 12,
                                        width: SizeConfig.screenWidth,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  14,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Room',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                        _controllerRooms.text,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 12,
                                    ),
                                    Container(
                                      height: SizeConfig.blockSizeVertical * 6,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 85,
                                      child: ElevatedButton(
                                        // color: ColorCodeGen.colorFromHex(
                                        //     '#0e3957'),
                                        style: ElevatedButton.styleFrom(
                                          primary: ColorCodeGen.colorFromHex(
                                              '#0e3957'),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.vibrate();
                                          // print(selectedDate1);
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          if (prefs.getString(
                                                  'selected_currency_code') !=
                                              null) {
                                            lastSelectedCurrency =
                                                prefs.getString(
                                                    'selected_currency_code');
                                          }

                                          if (_hotelSearchFieldcontroller
                                                      .text !=
                                                  null &&
                                              _hotelSearchFieldcontroller
                                                      .text !=
                                                  'Where ?') {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: HotelDetail(
                                                      checkInDate: context
                                                          .read<ModuleName>()
                                                          .departureStandardDate
                                                          .toString()
                                                          .split(' ')[0],
                                                      checkOutDate: context
                                                          .read<ModuleName>()
                                                          .returnStandardDate
                                                          .toString()
                                                          .split(' ')[0],
                                                      destination:
                                                          _hotelSearchFieldcontroller
                                                              .text,
                                                      cityid: context
                                                          .read<
                                                              SelectedHotelData>()
                                                          .hotelCityCode,
                                                      hotelsearchedCountryCode:
                                                          context
                                                              .read<
                                                                  SelectedHotelData>()
                                                              .hotelCountryName,
                                                      rooms: rooms,
                                                      childParam: childParam,
                                                      adultParam: adultParam,
                                                      childAgeParam:
                                                          childAgeParam,
                                                      totalAdult: totalAdult,
                                                      totalChild: totalChild,
                                                      selectedCurrency:
                                                          lastSelectedCurrency,
                                                      hotelNationalityCountryCode:
                                                          hotelNationalityCountryCode),
                                                ));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Fill all above Field");
                                          }
                                        },
                                        child: const Text(
                                          'SEARCH HOTELS',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])
                          : FlightUI()

                      // color: Colors.red,
                      //   decoration: new BoxDecoration(
                      // image: new DecorationImage(
                      //   image: new AssetImage(
                      // "assets/hotel.jpg",
                      //   ),
                      //   fit: BoxFit.cover,
                      // )),
                      );
                }),
              ),
              Positioned(
                left: 10,
                top: 36,
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => scaffoldKey.currentState!.openDrawer(),
                ),
              ),
              Positioned(
                top: 50,
                right: 0,
                child: AnimatedCrossFade(
                  firstChild: Material(
                    color: Colors.transparent,
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),

                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      // indicatorPadding: const EdgeInsets.all(2),
                      isScrollable: true,
                      tabs: List.generate(
                        tabNames.length,
                        (index) => InkWell(
                          onTap: () {
                            HapticFeedback.vibrate();
                            setState(() {
                              _tabController!.index = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(
                              height: 20,
                              child: Tab(
                                text: tabNames[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  secondChild: Container(),
                  crossFadeState: _screen == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
