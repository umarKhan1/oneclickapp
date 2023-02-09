import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:oneclicktravel/LoaderCustom.dart';
import 'package:oneclicktravel/hotelui.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'utils/size_config.dart';

// ignore: must_be_immutable
class HotelCheckOutPage extends StatefulWidget {
  // HotelDetailsTempScreen({Key key}) : super(key: key);
  static String? hoteldetailspageURL;
  static String? appbardetails;
  @override
  _HotelCheckOutPageState createState() => _HotelCheckOutPageState();
  HotelCheckOutPage(String request) {
    hoteldetailspageURL = request;

    print('=============this is hotel page checkout url===========');
    print(hoteldetailspageURL);
  }
}

class _HotelCheckOutPageState extends State<HotelCheckOutPage> {
  // ignore: unused_field
  WebViewController? _myController;
  bool loader = true;
  @override
  Widget build(BuildContext context) {
    print('=============this is hotel page checkout url== build=========');

    print(HotelCheckOutPage.hoteldetailspageURL);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
          iconTheme: IconThemeData(color: Colors.white),
          title: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Review Your Booking",
                // hotelName,
                style: TextStyle(
                  color: Colors.white,

                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            WebView(
                initialUrl: HotelCheckOutPage.hoteldetailspageURL,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _myController = webViewController;
                },
                onPageStarted: (start) {
                  print('Hotel checkout start');
                  print(start);
                },
                onPageFinished: (finished) {
                  print('Hotel checkout finished');
                  print(finished);
                  if (this.mounted) {
                    setState(() {
                      loader = false;
                    });
                  }
                },
                navigationDelegate: (NavigationRequest request) async {
                  print('Request url==NavigationRequest============checkout ' +
                      request.toString());
                  print(NavigationDecision.navigate);
                  return NavigationDecision.navigate;
                }),
            Positioned(
              top: SizeConfig.blockSizeVertical * 80,
              left: SizeConfig.blockSizeHorizontal * 10,
              right: SizeConfig.blockSizeHorizontal * 10,
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom( backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),),
                 
                  child: Text(
                    'Go to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: HotelUI()),
                        (route) => false);
                  },
                ),
              ),
            ),
            loader == true ? SafeArea(child: LoaderCustom()) : Container(),
            loader == true
                ? Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    print('on will pop============from checkout');
    Navigator.pop(context, true);
    return true;
  }
}
