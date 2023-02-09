
// ignore_for_file: sort_child_properties_last

// import 'package:store_launcher/store_launcher.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:oneclicktravel/AboutUsFAQ.dart';
import 'package:oneclicktravel/AboutUsPrivacyPolicy.dart';
import 'package:oneclicktravel/AboutUsTermsandCond.dart';
import 'package:oneclicktravel/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils/color_code_generator.dart';
import 'utils/size_config.dart';
import 'utils/strings.dart';

class AboutUs extends StatefulWidget {

const  AboutUs({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  void onShareTap(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
        'https://play.google.com/store/apps/details?id=com.app.oneclicktravel',
        subject: 'LWL Vacations',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  openURL(String url) async {
    print('fb==========$url');
    // const url = url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        title: Text('About us'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 10,
                top: 40,
                right: SizeConfig.blockSizeHorizontal * 10,
              ),
              child: Container(
                // color: Colors.red,
                height: 130,
                decoration: new BoxDecoration(
                    // color: ColorCodeGen.colorFromHex('#e85d21').withOpacity(.2),
                    // border: Border.all(
                    //   color: ColorCodeGen.colorFromHex('#e85d21'),
                    // ),
                    // borderRadius: BorderRadius.circular(20),
                    image: new DecorationImage(
                  // colorFilter: ColorFilter.linearToSrgbGamma(),
                  // colorFilter: ColorFilter.srgbToLinearGamma(),
                  image: new AssetImage(
                    "assets/logo.png",
                  ),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 10,
                top: 30,
                right: SizeConfig.blockSizeHorizontal * 10,
              ),
              child: Container(
                // width: SizeConfig.blockSizeHorizontal * 80,
                child: Center(
                    child: Text(
                  Strings.about_us,
                  style: TextStyle(
                      color: Colors.blueGrey[600],
                      //
                      fontSize: 14,
                      letterSpacing: .2),
                )),
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 4,
            ),
            Column(
              children: [
                returnMyRow('Rate this app', Icons.star),
                // returnMyRow('Social networks', Icons.thumb_up),
                returnMyRow('Recommend the app', Icons.share),
                returnMyRow('FAQ', FontAwesomeIcons.question),
                // returnMyRow('oneclicktravel FAQ', FontAwesomeIcons.question),
                // returnMyRow('oneclicktravel-does-not-guarantee-prices',
                //     FontAwesomeIcons.info),
                // returnMyRow('Disclaimer', FontAwesomeIcons.exclamation),
                // returnMyRow(
                //     'How oneclicktravel Works', FontAwesomeIcons.question),
                returnMyRow('Privacy Policy', Icons.lock_rounded),
                returnMyRow('Terms and Conditions', Icons.event_note_sharp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void doWork(String title) {
    if (title == 'Social networks') {
      showBottomDialogSocialnetworks();
    } else if (title == 'Recommend the app') {
      onShareTap(context);
    } else if (title == 'Rate this app') {
      // openWithStore();
      openURL(MyConstants.rateTheApp);
    } else if (title == 'FAQ') {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AboutUsFAQScreen(),
        ),
      );
    } else if (title == 'Privacy Policy') {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const AboutUSPrivacyScreen(),
        ),
      );
    } else if (title == 'Terms and Conditions') {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AboutUSTermsandCScreen(),
        ),
      );
    }
  }

  showBottomDialogSocialnetworks() {
    showGeneralDialog(
      barrierLabel: "Social networks",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () async {
                      openURL(MyConstants.fbLink);
                    },
                    child: Icon(
                      FontAwesomeIcons.facebook,
                      color: ColorCodeGen.colorFromHex('#4267B2'),
                    ),
                    // color: Colors.red,
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      openURL(MyConstants.youtubeLink);
                    },
                    child: Icon(
                      FontAwesomeIcons.youtube,
                      color: ColorCodeGen.colorFromHex('#FF0000'),
                    ),
                    // color: Colors.red,
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                      onPressed: () {
                        openURL(MyConstants.instaLink);
                      },
                      child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return ui.Gradient.linear(
                              Offset(4.0, 20.0),
                              Offset(2.0, 4.0),
                              [
                                // Colors.blue[200],
                                ColorCodeGen.colorFromHex('#C13584'),
                                ColorCodeGen.colorFromHex('#405DE6'),
                              ],
                            );
                          },
                          child: Icon(
                            FontAwesomeIcons.instagram,
                          ))

                      // Icon(
                      //   FontAwesomeIcons.instagram,
                      //   color: Colors.orange,
                      // ),
                      // color: Colors.red,
                      ),
                ),
                Container(
                  color: Colors.white,
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      openURL(MyConstants.twitterLink);
                    },
                    child: Icon(
                      FontAwesomeIcons.twitter,
                      color: ColorCodeGen.colorFromHex('#1DA1F2'),
                    ),
                    // color: Colors.red,
                  ),
                ),
              ],
            ),
            // margin: EdgeInsets.only(bottom: 0, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(5),
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

  Widget returnMyRow(String title, IconData icon) {
    return InkWell(
      onTap: () {
        doWork(title);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.blockSizeVertical * 6,
        decoration: BoxDecoration(
          // color: Colors.red,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: .5,
            ),
            top: BorderSide(
              color: Colors.grey[300]!,
              width: .5,
            ),
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey[600],
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                  )),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[500],
                    overflow: TextOverflow.ellipsis,
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
