import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils/color_code_generator.dart';
import 'utils/size_config.dart';
import 'utils/strings.dart';

class AboutUsFAQScreen extends StatefulWidget {
  AboutUsFAQScreen({Key? key}) : super(key: key);

  @override
  _AboutUsFAQScreenState createState() => _AboutUsFAQScreenState();
}

class _AboutUsFAQScreenState extends State<AboutUsFAQScreen> {
  String companyEmail = Strings.companyEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        title: Text('FAQ'),
      ),
      body: SafeArea(
        // color: Colors.yellow,
        child: ListView(
          // physics: ,
          // shrinkWrap: true,
          children: [
            // SizedBox(
            //   height: SizeConfig.blockSizeVertical * 2,
            // ),
            returnMyRow(Strings.faq1, Strings.ans1),
            returnMyRow(Strings.faq2, Strings.ans2),
            returnMyRow(Strings.faq3, Strings.ans3),
            returnMyRow(Strings.faq4, Strings.ans4),
            returnMyRow(Strings.faq5, Strings.ans5),
            returnMyRow(Strings.faq6, Strings.ans6),
            returnMyRow(Strings.faq7, Strings.ans7),
            returnMyRow(Strings.faq8, Strings.ans8),
            //
            //
            Container(
              // color:  ColorCodeGen.colorFromHex('#ffd022'),
              width: SizeConfig.screenWidth,
              // height: SizeConfig.blockSizeVertical * 5,
              child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 2,
                    bottom: SizeConfig.blockSizeVertical * 2,
                    left: SizeConfig.blockSizeHorizontal * 6,
                    right: SizeConfig.blockSizeHorizontal * 6),
                child: Column(
                  children: [
                    Text(
                      'Nothing Helped?',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey[700],
                          fontSize: 12),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                launchEmail();
              },
              splashColor: Colors.transparent,
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 8,
                child: Center(
                  child: Text(
                    'CONTACT US BY E-MAIL',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnMyRow(String ques, String ans) {
    return Padding(
      padding: EdgeInsets.only(
          // top: SizeConfig.blockSizeVertical * .5,
          // bottom: SizeConfig.blockSizeVertical * .5,
          left: SizeConfig.blockSizeHorizontal * 6,
          right: SizeConfig.blockSizeHorizontal * 6),
      child: Column(
        children: [
          ExpandablePanel(
            // <-- Provides ExpandableController to its children
            collapsed: SizedBox(),
            header: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 2,
                  bottom: SizeConfig.blockSizeVertical * 2),
              // color: Colors.red,
              // height: SizeConfig.blockSizeVertical * 12,
              child: Text(
                ques,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[700],
                    fontSize: 13),
              ),
            ),

            expanded: Padding(
              padding: EdgeInsets.only(top: 0, bottom: 10),
              child: Text(
                ans,
                softWrap: true,
                // maxLines: 10,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.blueGrey[700],
                    fontSize: 14),
              ),
            ),
            // tapHeaderToExpand: true,
            // hasIcon: true,
          ),
          Divider(
            color: Colors.grey,
            height: 0,
          ),
        ],
      ),
    );
  }

  void launchEmail() async {
    final String subject = "Support Request";
    final String stringText = "Hello oneclicktravel,";
    String uri =
        'mailto:$companyEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch';
    }
  }
}
