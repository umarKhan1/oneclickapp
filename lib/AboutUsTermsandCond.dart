import 'package:flutter/material.dart';
import 'package:oneclicktravel/helperwidgets/circularProgIndi.dart';
import 'package:oneclicktravel/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'utils/color_code_generator.dart';

class AboutUSTermsandCScreen extends StatefulWidget {
  const AboutUSTermsandCScreen({Key? key}) : super(key: key);

  @override
  _AboutUSTermsandCScreenState createState() => _AboutUSTermsandCScreenState();
}

class _AboutUSTermsandCScreenState extends State<AboutUSTermsandCScreen> {
  bool loading = true;
  // WebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
          title: Text('Terms and Conditions'),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: MyConstants.termsConditionWebURL,
              javascriptMode: JavascriptMode.unrestricted,
              // onWebViewCreated: (WebViewController controller) {
              //   _webViewController = controller;
              // },
              onPageStarted: (onPageStartedvalue) {},
              onPageFinished: (onPageFinishedValue) {
                print(onPageFinishedValue);
                setState(() {
                  loading = false;
                });
              },
            ),
            loading == true
                ? Center(child: CircularProgIndicator())
                : Container(),
          ],
        ));
  }
}
