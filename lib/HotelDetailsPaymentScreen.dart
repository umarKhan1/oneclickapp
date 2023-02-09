import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';
import 'package:oneclicktravel/LoaderCustom.dart';
import 'package:oneclicktravel/hotelcheckoutpage.dart';

import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class HotelDetailsPaymentScreen extends StatefulWidget {
  // HotelDetailsTempScreen({Key key}) : super(key: key);
  static late String hoteldetailspageURL;
  static String? appbardetails;
  @override
  _HotelDetailsPaymentScreenState createState() =>
      _HotelDetailsPaymentScreenState();
  HotelDetailsPaymentScreen(NavigationRequest request, String? appbardata) {
    hoteldetailspageURL = request.url;
    //hoteldetailspageURL.contains('hotelName');
    appbardetails = appbardata;
    log('==========================this is hotel page navigationrequest url');
    log(hoteldetailspageURL);
  }
}

class _HotelDetailsPaymentScreenState extends State<HotelDetailsPaymentScreen> {
  // ignore: unused_field
  late InAppWebViewController _myController;
  InAppWebViewController? _myController1;
  late String hotelName;

  bool loading = true;
  late Uri uri;
  Future<bool> _onWillPop() async {
    log("WillPop");
    if (await _myController.canGoBack() == true) {
      _myController.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    log('==========================this is hotel page  url in string');
    uri = Uri.parse(HotelDetailsPaymentScreen.hoteldetailspageURL);
    // return MaterialApp(
    log('==========================this is hotel page  url in string');

    hotelName = uri.queryParameters['hotelName'].toString();
    log(hotelName);
    log(HotelDetailsPaymentScreen.hoteldetailspageURL);

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
                hotelName.toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      // fontWeight: FontWeight.bold,
                      // letterSpacing: .5,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                // 'date',
                HotelDetailsPaymentScreen.appbardetails!,
                // '${widget.myappbarcheckindat.toString().substring(0, 2)} ${widget.myappbarcheckindat.toString().substring(2, 5)} - ${widget.myappbarcheckoutdat.toString().substring(0, 2)} ${widget.myappbarcheckoutdat.toString().substring(2, 5)} | ${widget.adults} Guest ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        HotelDetailsPaymentScreen.hoteldetailspageURL)),
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
                onLoadStart: (InAppWebViewController c, start) async {
                  log('_myController1');
                  // log(_myController1.c);
                  log(start.toString());
                  if (start.toString().contains('mt=confirmation')) {
                    log('got mt=confirmation inside if');
                    await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HotelCheckOutPage(start.toString())));

                    Navigator.pop(context);
                  }
                },
                onLoadStop: (InAppWebViewController c, finished) {
                  log(finished.toString());
                  setState(() {
                    loading = false;
                  });
                },
                // onCloseWindow: (controller) {
                //   log('closed window==========');
                //   Navigator.pop(context);
                // },
                // onLoadResource: ,
                onCreateWindow: (controller, createWindowRequest) async {
                  log('window created');
                  log(createWindowRequest.request.toString());
                  log(createWindowRequest.windowId.toString());
                  showGeneralDialog(
                    barrierLabel: "Hotel History Details",
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

                                      log('_myController1 can not go forward');
                                    },
                                    onLoadStart:
                                        (InAppWebViewController controller,
                                            Uri? url) {
                                      log("onLoadStart popup $url");
                                    },
                                    onLoadStop:
                                        (InAppWebViewController controller,
                                            Uri? url) async {
                                      log("onLoadStop popup $url");
                                      // log(controller.canGoForward());
                                    },
                                    onCloseWindow: (controller) {
                                      log('closed window==========');
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

                  log('popup is launching returning true');
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

        // Stack(
        //   children: [
        //     WebView(
        //         initialUrl: HotelDetailsPaymentScreen.hoteldetailspageURL,
        //         javascriptMode: JavascriptMode.unrestricted,
        //         onWebViewCreated: (WebViewController webViewController) {
        //           _myController = webViewController;
        //         },
        //         onPageStarted: (start) {
        //           log(start);
        //         },
        //         onPageFinished: (finished) {
        //           log(finished);
        //           setState(() {
        //             loading = false;
        //           });
        //         },
        //         navigationDelegate: (NavigationRequest request) async {
        //           log(
        //               'Request url==NavigationRequest hoteltempscreen============' +
        //                   request.toString());

        //           if (!request.url.toString().contains('mt=booking')) {
        //             Navigator.push(
        //                 context,
        //                 PageTransition(
        //                     type: PageTransitionType.rightToLeft,
        //                     child: HotelDetailsPaymentScreen(
        //                         request, HotelDetailsPaymentScreen.appbardetails)));
        //             _myController.goBack();
        //             _myController.goBack();
        //             return NavigationDecision.prevent;
        //           } else {
        //             return NavigationDecision.navigate;
        //           }
        //         }),
        //     loading == true
        //         ? SafeArea(
        //             child: LinearProgressIndicator(
        //               backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
        //             ),
        //           )
        //         : Container(),
        //   ],
        // ),
        // ),
      ),
    );
  }
}
