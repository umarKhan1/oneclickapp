import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';

import 'package:oneclicktravel/LoaderCustom.dart';
import 'package:oneclicktravel/utils/ModuleName.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'HotelDetailsPaymentScreen.dart';
import 'utils/color_code_generator.dart';

class HotelDetail extends StatefulWidget {
  final checkInDate;
  final checkOutDate;
  final destination;
  final cityid;
  final hotelsearchedCountryCode;
  final childAgeParam;
  final rooms;
  final childParam;
  final adultParam;
  final totalAdult;
  final totalChild;
  final myappbarcheckindat;
  final myappbarcheckoutdat;
  final selectedCurrency;
  final hotelNationalityCountryCode;
  HotelDetail({
    this.checkInDate,
    this.checkOutDate,
    this.cityid,
    this.hotelsearchedCountryCode,
    this.childAgeParam,
    this.destination,
    this.rooms,
    this.childParam,
    this.adultParam,
    this.totalAdult,
    this.totalChild,
    this.myappbarcheckindat,
    this.myappbarcheckoutdat,
    this.selectedCurrency,
    this.hotelNationalityCountryCode,
  });
  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  // InAppWebViewController _myController;
  late WebViewController _myController;
  bool filteropen = false;
  bool mapopen = false;
  // var loader = true;
  bool pageFinished = false;
  int count = 1;
  bool loading = true;
  String? hotelResultURL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    hotelResultURL =
        "https://www.abengines.com/search-results/?version=v2&pid=${Strings.app_pid}&mid=ADTBOH6C437514F03&mt=result&wlaid=&aid=&usertype=undefined&dest=${widget.destination}&cityId=${widget.cityid}&checkIn=${widget.checkInDate}&checkOut=${widget.checkOutDate}&rooms=${widget.rooms}&countrycode=${widget.hotelsearchedCountryCode}&GuestNationality=${widget.hotelsearchedCountryCode}&adults=${widget.adultParam}&children=${widget.childParam}&childAge=${widget.childAgeParam}&currency=${widget.selectedCurrency}&language=en&ParentRestParam==&isMobile=1";

    hotelResultURL = hotelResultURL!.replaceAll(' ', '%20');

    log(hotelResultURL!);
  }

  String? appbardata;
  @override
  Widget build(BuildContext context) {
    // log(widget.hotelNationalityCountryCode);
    // log(widget.hotelsearchedCountryCode);
    // log("Cehck===========build");

    appbardata = context.read<ModuleName>().departureDate!.split(' ')[0] +
        ' ' +
        context.read<ModuleName>().departureDate!.split(' ')[1] +
        ' - ' +
        context.read<ModuleName>().returnDate!.split(' ')[0] +
        ' ' +
        context.read<ModuleName>().returnDate!.split(' ')[1] +
        ', ' +
        widget.rooms.toString() +
        ' Rooms' +
        ' | ${widget.totalAdult + widget.totalChild} Guest';
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Color(0xFF147dfe),
          backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
          iconTheme: IconThemeData(color: Colors.white),

          title: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.destination.toString()}',
                style: TextStyle(
                  color: Colors.white,

                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                appbardata!,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                filteropen ? Icons.close : Icons.filter_alt_sharp,
                color: Colors.white,
              ),
              onPressed: () async {
                setState(() {
                  if (filteropen) {
                    filteropen = false;
                  } else {
                    filteropen = true;
                  }
                });
                if (filteropen) {
                  print('filteropen true ===============');
                  _myController.evaluateJavascript(
                      "document.getElementsByClassName(\"menu-toggle\")[0].click();");
                } else {
                  print('filteropen FALSE ===============');
                  _myController.evaluateJavascript(
                      "document.getElementsByClassName(\"hidden-panel-close\")[0].click();");
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebView(
                initialUrl: hotelResultURL,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _myController = webViewController;
                },
                onPageFinished: (finish) {
                  setState(() {
                    loading = false;
                  });
                  // log('finish============');
                  // log(finish.toString());
                },
                onPageStarted: (start) {
                  // log("getting response in webview on page started===================");
                  // log(start);
                },
                navigationDelegate: (NavigationRequest request) async {
                  // log('running navigator ');
                  // log('Request url=============' + request.toString());
                  if (request.url.toString().contains('mt=booking')) {
                    // log('Request url==NavigationRequest============' +
                    // request.toString());
                    await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HotelDetailsPaymentScreen(
                                request, appbardata)));
                    return NavigationDecision.prevent;
                  } else {
                    // log('not mt=details===========');
                    return NavigationDecision.navigate;
                  }

                  // count = count + 1;
                }),
            loading == true ? SafeArea(child: LoaderCustom()) : Container(),
            loading == true
                ? Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
