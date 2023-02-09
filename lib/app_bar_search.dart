import 'package:flutter/material.dart';

import 'utils/color_code_generator.dart';
import 'utils/size_config.dart';

class MyAppBarSearch extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = SizeConfig.blockSizeVertical * 16 + 10;

  final Function? textChangedRef;
  final String? appbarTitle;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);
  MyAppBarSearch({this.textChangedRef, this.appbarTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.blue,
              height:
                  SizeConfig.statusBarHeight + SizeConfig.blockSizeVertical * 3,
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 4,
              // color: Colors.amber,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        SizedBox(width: 15),
                        Text(
                          appbarTitle!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              // color:  ColorCodeGen.colorFromHex('#ffd022'),
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3,
                ),
                Container(
                  color: Colors.white,
                  width: SizeConfig.blockSizeHorizontal * 94,
                  height: SizeConfig.blockSizeVertical * 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      cursorColor: ColorCodeGen.colorFromHex('#ffd022'),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      onChanged: textChangedRef as void Function(String)?,
                      autofocus: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: 'Search Here',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        // color: Colors.red,
        color: ColorCodeGen.colorFromHex('#ffd022'),
      ),
    );
  }
}
