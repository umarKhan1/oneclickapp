import 'dart:developer';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneclicktravel/LoaderCustom.dart';

import 'package:oneclicktravel/flightdetailstempscreen.dart';
import 'package:oneclicktravel/utils/ModuleName.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:oneclicktravel/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'utils/size_config.dart';

class FlightDetail extends StatefulWidget {
  final check_in_date;
  final check_out_date;
  final destinationto;
  final destinationfrom;
  final one_way;
  final children;
  final adults;
  final infants;
  final cabin;
  final code;
  final code1;
  final isDomestic;
  final selectedCurrency;
  FlightDetail(
      {this.check_in_date,
      this.cabin,
      this.check_out_date,
      this.destinationto,
      this.destinationfrom,
      this.one_way,
      this.code,
      this.code1,
      this.adults,
      this.children,
      this.infants,
      this.isDomestic,
      this.selectedCurrency});

  @override
  _FlightDetailState createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  String? myappbardeparturedate;
  String? myappbarreturndate;
  WebViewController? _myController;
  var loader = true;
  var code;
  var code1;
  DateTime? checkindate;
  DateTime? checkoutdate;
  int count = 1;
  String? flightResultURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myappbardeparturedate = context.read<ModuleName>().departureDate;
    myappbarreturndate = context.read<ModuleName>().returnDate;
    log(myappbardeparturedate!);
    log(myappbarreturndate!);
    // getvalues();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    flightResultURL =
        "https://www.abengines.com/search-results/?version=v2&pid=${Strings.app_pid}&mid=ADIM5C66A1BF56M1Y&mt=result&wlaid=&aid=&usertype=undefined&origin_name=${widget.destinationfrom}&origin_iata=${widget.code}&destination_name=${widget.destinationto}&destination_iata=${widget.code1}&depart_date=${widget.check_in_date}&return_date=${widget.check_out_date}&one_way=${widget.one_way}&adults=${widget.adults}&children=${widget.children}&infants=${widget.infants}&currency=${widget.selectedCurrency}&language=en&isDomestic=${widget.isDomestic}&cabin=${widget.cabin}&ParentRestParam=&isMobile=1";

    flightResultURL = flightResultURL!.replaceAll(' ', '%20');
    log(flightResultURL!);
  }

  late String appbardata;
  bool filteropen = false;
  var res1;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    if (widget.one_way == 'Yes') {
      if (widget.children != 0 && widget.children.toString() != '0') {
        appbardata = myappbardeparturedate.toString().split(" ")[0] +
            ' ' +
            myappbardeparturedate.toString().split(" ")[1] +
            ' | ${widget.adults.toString()} Adult,${widget.children.toString()} Child';
      } else {
        appbardata = myappbardeparturedate.toString().split(" ")[0] +
            ' ' +
            myappbardeparturedate.toString().split(" ")[1] +
            ' | ${widget.adults.toString()} Adult';
      }

      if (widget.infants != 0 && widget.infants.toString() != '0') {
        appbardata += ',${widget.infants.toString()} infants';
      }
    } else {
      if (widget.children != 0 && widget.children.toString() != '0') {
        appbardata = myappbardeparturedate.toString().split(" ")[0] +
            ' ' +
            myappbardeparturedate.toString().split(" ")[1] +
            ' - ' +
            myappbarreturndate.toString().split(" ")[0] +
            ' ' +
            myappbarreturndate.toString().split(" ")[1] +
            ' | ${widget.adults.toString()} Adult,${widget.children.toString()} Child';
      } else {
        appbardata = myappbardeparturedate.toString().split(" ")[0] +
            ' ' +
            myappbardeparturedate.toString().split(" ")[1] +
            ' - ' +
            myappbarreturndate.toString().split(" ")[0] +
            ' ' +
            myappbarreturndate.toString().split(" ")[1] +
            ' | ${widget.adults.toString()} Adult';
      }

      if (widget.infants != 0 && widget.infants.toString() != '0') {
        appbardata += ',${widget.infants.toString()} infant';
      }
    }

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
          iconTheme: IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${widget.destinationfrom.toString().split(',')[0]} ',
                    style: context.read<ModuleName>().buttonLoginRegStyle,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 6,
                    child: Icon(
                      '${widget.one_way}' == 'Yes'
                          ? Icons.arrow_right_alt_sharp
                          : Icons.compare_arrows_sharp,
                      size: 20,
                    ),
                  ),
                  Flexible(
                    child: Text(
                        ' ${widget.destinationto.toString().split(',')[0]}',
                        overflow: TextOverflow.ellipsis,
                        style: context.read<ModuleName>().buttonLoginRegStyle),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                appbardata,
                style: context
                    .read<ModuleName>()
                    .buttonLoginRegStyle
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
          actions: [
            loading == false
                ? IconButton(
                    icon: Icon(
                      filteropen ? Icons.close : Icons.filter_alt_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (filteropen) {
                          filteropen = false;
                        } else {
                          filteropen = true;
                        }
                      });

                      if (filteropen) {
                        print('filteropen true ===============');
                        _myController!.evaluateJavascript(
                            "document.getElementsByClassName(\"menu-toggle\")[0].click();");
                      } else {
                        print('filteropen FALSE ===============');
                        _myController!.evaluateJavascript(
                            "document.getElementsByClassName(\"hidden-panel-close\")[0].click();");
                      }
                    },
                  )
                : SizedBox()
          ],
        ),
        body: Stack(
          children: [
            WebView(
                initialUrl: flightResultURL,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _myController = webViewController;
                },
                onPageStarted: (start) {},
                onPageFinished: (finish) {
                  if (this.mounted) {
                    setState(() {
                      loading = false;
                    });
                  }
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.contains('mt=result')) {
                    return NavigationDecision.navigate;
                  } else {
                    if (request.isForMainFrame != false &&
                        request.url.contains('mt=booking')) {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FlightDetailsScreen(request, appbardata);
                        },
                        transitionDuration: Duration(milliseconds: 350),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SharedAxisTransition(
                              child: child,
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal);
                          // return new FadeTransition(opacity: animation, child: new HotelUI());
                        },
                      ));
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  }
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
