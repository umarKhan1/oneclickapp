import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:oneclicktravel/screens/mybooking/HistoryFlight.dart';
import 'package:oneclicktravel/screens/mybooking/HistoryHotel.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  bool loadedHistory = false;
  String? history;

  @override
  void initState() {
    super.initState();
  }

  Future loadHistory() async {
    return history;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('History'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  icon: Icon(
                Icons.hotel,
                color: ColorCodeGen.colorFromHex('#ffffff'),
              )),
              Tab(
                  icon: Icon(
                Icons.flight,
                color: ColorCodeGen.colorFromHex('#ffffff'),
              )),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              HistoryHotelScreen(),
              HistoryFlightScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
