import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneclicktravel/LoaderCustom.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class FlightCheckOutPage extends StatefulWidget {
  // FlightDetailsTempScreen({Key key}) : super(key: key);
  String? flightdetailspageURL;
  String? appbardetails;
  @override
  _FlightCheckOutPageState createState() => _FlightCheckOutPageState();
  FlightCheckOutPage(Uri? request) {
    flightdetailspageURL = request.toString();

    print('=============this is Flight page checkout url===========');
    print(flightdetailspageURL);
  }
}

class _FlightCheckOutPageState extends State<FlightCheckOutPage> {
  // ignore: unused_field
  late WebViewController _myController;
  late String flightName;
  late int startindexFlightName;
  late int endindexFlightName;
  bool loader = true;
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    print('=============this is Flight page checkout url== build=========');

    print(widget.flightdetailspageURL);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ColorCodeGen.colorFromHex('#0AA422'),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Review your booking",
              // FlightName,
              style: TextStyle(
                color: Colors.white,

                fontSize: 14,
                // fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.flightdetailspageURL,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _myController = webViewController;
            },
            onPageStarted: (start) {
              print('Flight checkout start');
              print(start);
            },
            onPageFinished: (finished) {
              print('Flight checkout finished');
              print(finished);

              if (this.mounted) {
                setState(() {
                  loader = false;
                });
              }
            },
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
    );
  }
}
