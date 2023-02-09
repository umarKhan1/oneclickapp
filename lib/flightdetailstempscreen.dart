import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:oneclicktravel/LoaderCustom.dart';
import 'package:oneclicktravel/flightcheckoutpage.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class FlightDetailsScreen extends StatefulWidget {
  // FlightDetailsTempScreen({Key key}) : super(key: key);
  String? flightdetailspageURL;
  String? appbardetails;
  @override
  _FlightDetailsScreenState createState() => _FlightDetailsScreenState();
  FlightDetailsScreen(NavigationRequest request, String appbardata) {
    flightdetailspageURL = request.url.toString();

    appbardetails = appbardata;
    print(
        '==========================this is Flight page navigationrequest url');
    print(flightdetailspageURL);
  }
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  // ignore: unused_field
  InAppWebViewController? _myController;
  InAppWebViewController? _myController1;
  late String flightName;
  late int startindexFlightName;
  late int endindexFlightName;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    print('==========================this is Flight page  url in string');

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
              "Review Flight Details",
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
            Text(
              widget.appbardetails!,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse(widget.flightdetailspageURL!)),
              // javascriptMode: JavascriptMode.unrestricted,
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      // debuggingEnabled: true,
                      // set this to true if you are using window.open to open a new window with JavaScript
                      javaScriptCanOpenWindowsAutomatically: true),
                  android: AndroidInAppWebViewOptions(
                      // on Android you need to set supportMultipleWindows to true,
                      // otherwise the onCreateWindow event won't be called
                      supportMultipleWindows: true)),
              onWebViewCreated: (InAppWebViewController webViewController) {
                _myController = webViewController;
              },
              onLoadStart: (InAppWebViewController c, Uri? start) async {
                print('_myController1');
                // print(_myController1.c);
                print(start);
                if (start.toString().contains('mt=confirmation')) {
                  print('got mt=confirmation inside if');
                  await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: FlightCheckOutPage(start)));

                  Navigator.pop(context);
                }
              },
              onLoadStop: (InAppWebViewController c, finished) {
                print(finished);
                setState(() {
                  loading = false;
                });
              },
              // onCloseWindow: (controller) {
              //   print('closed window==========');
              //   Navigator.pop(context);
              // },
              // onLoadResource: ,
              onCreateWindow: (controller, createWindowRequest) async {
                print('window created');
                print(createWindowRequest.request);
                print(createWindowRequest.windowId);
                showGeneralDialog(
                  barrierLabel: "Flight Booking Details",
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: Duration(milliseconds: 500),
                  context: context,
                  pageBuilder: (context, anim1, anim2) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: Scaffold(
                          // backgroundColor: ColorCodeGen.colorFromHex('#ba275e'),
                          body: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.clear,
                                        color: ColorCodeGen.colorFromHex(
                                            '#115796'),
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                // height: SizeConfig.screenHeight - 250,
                                // width: SizeConfig.screenWidth,
                                child: InAppWebView(
                                  // Setting the windowId property is important here!
                                  windowId: createWindowRequest.windowId,
                                  initialOptions: InAppWebViewGroupOptions(
                                    crossPlatform: InAppWebViewOptions(
                                      // debuggingEnabled: true,

                                      cacheEnabled: true,
                                    ),
                                  ),
                                  onWebViewCreated: (InAppWebViewController
                                      controller) async {
                                    _myController1 = controller;

                                    print('_myController1 can not go forward');
                                  },
                                  onLoadStart:
                                      (InAppWebViewController controller,
                                          Uri? url) {
                                    // onLoadStart popup $url");
                                  },
                                  onLoadStop:
                                      (InAppWebViewController controller,
                                          Uri? url) async {
                                    // onLoadStop popup $url");
                                    // print(controller.canGoForward());
                                  },
                                  onCloseWindow: (controller) {
                                    print('closed window==========');
                                    Navigator.pop(context);
                                  },
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
                      position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                          .animate(anim1),
                      child: child,
                    );
                  },
                );

                print('popup is launching returning true');
                // Navigator.pop(context);
                return true;
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
      ),
    );
  }
}
