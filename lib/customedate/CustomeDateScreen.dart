import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oneclicktravel/customedate/controllers/clean_calendar_controller.dart';
import 'package:oneclicktravel/customedate/scrollable_clean_calendar.dart';
import 'package:oneclicktravel/customedate/utils/enums.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/helperwidgets/MyButtonHelperWidget.dart';
import 'package:oneclicktravel/utils/ModuleName.dart';

import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomeDateScreen extends StatefulWidget {
  final isRangeMode, type;
  CustomeDateScreen({this.isRangeMode, this.type});
  @override
  _CustomeDateScreenState createState() => _CustomeDateScreenState();
}

class _CustomeDateScreenState extends State<CustomeDateScreen> {
  List<String> weekName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  List<dynamic> rangeDateTapped = [];
  CleanCalendarController calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      setControllerForDate();
    });
  }

  setControllerForDate() {
    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      initialDateSelected: widget.isRangeMode
          ? context.read<ModuleName>().departureStandardDate
          : context.read<ModuleName>().departureStandardDate,
      endDateSelected: widget.isRangeMode
          ? context.read<ModuleName>().returnStandardDate
          : context.read<ModuleName>().departureStandardDate,
      onRangeSelected: (firstDate, secondDate) {
        log('firstDate=======' + firstDate.toString());
        log('secondDate=======' + secondDate.toString());

        context.read<ModuleName>().setdepartureStandardDate(dateX: firstDate);
        if (secondDate != null) {
          context.read<ModuleName>().setreturnStandardDate(dateX: secondDate);
        } else {
          context.read<ModuleName>().setreturnStandardDate(dateX: firstDate);
        }
        context.read<ModuleName>().setdepartureSelectedDateFormatted(
            departureDateX: context
                .read<ModuleName>()
                .convertStandardDateToFormattedDate(dateX: firstDate));
        context.read<ModuleName>().setreturnSelectedDateFormatted(
            returnDateX: secondDate != null
                ? context
                    .read<ModuleName>()
                    .convertStandardDateToFormattedDate(dateX: secondDate)
                : '--');
      },
      onDayTapped: (date) {
        log('dayTapped=======' + date.toString());
        // context.read<ModuleName>().setSelectedDate(
        //     dateX: context
        //         .read<ModuleName>()
        //         .convertStandardDateToFormattedDate(
        //             dateX: date, israngeModeX: widget.isRangeMode),
        //     israngeModeX: widget.isRangeMode);
      },
      rangeMode: widget.isRangeMode,
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {
        log('onAfterMaxDateTapped=======' + date.toString());
      },
      weekdayStart: DateTime.monday,
      // initialDateSelected: DateTime(2022, 2, 3),
      // endDateSelected: DateTime(2022, 2, 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        title: Text('Select Travel Dates',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ))),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: SizeConfig.blockSizeVertical! * 6,
              width: SizeConfig.blockSizeHorizontal! * 100,
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black45, width: .2),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: weekName
                        .map((item) => Text(
                              item,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 10,
            child: ScrollableCleanCalendar(
              dayBackgroundColor: Colors.white,
              calendarMainAxisSpacing: 0,
              padding: const EdgeInsets.all(0),
              monthBuilder: (ctx, monthName) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    monthName.characters.toString(),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                );
              },
              showWeekdays: false,
              spaceBetweenCalendars: 0,
              spaceBetweenMonthAndCalendar: 0,
              daySelectedBackgroundColorBetween:
                  const Color(0xff000000).withOpacity(.2),
              daySelectedBackgroundColor: const Color(0xff000000),
              dayTextStyle: const TextStyle(fontWeight: FontWeight.normal),
              calendarController: calendarController,
              layout: Layout.BEAUTY,
              calendarCrossAxisSpacing: 0,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: widget.isRangeMode
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.s,
                    children: [
                      returnDateSelectedBox(
                          selectedDateX:
                              context.watch<ModuleName>().departureDate,
                          colorx: ColorCodeGen.colorFromHex('#ffd022')
                              .withOpacity(.8),
                          text: widget.type == 'HotelCalender'
                              ? 'CHECK-IN'
                              : 'DEPARTURE DATE',
                          paddingx: EdgeInsets.only(
                              left: 4, right: 6, top: 4, bottom: 6),
                          box: 0),
                      widget.isRangeMode
                          ? returnDateSelectedBox(
                              selectedDateX: widget.isRangeMode
                                  ? context.watch<ModuleName>().returnDate ==
                                          null
                                      ? '--'
                                      : context.watch<ModuleName>().returnDate
                                  : 'save more on round trips!',
                              colorx: Colors.grey.shade400,
                              text: widget.type == 'HotelCalender'
                                  ? 'CHECK-OUT'
                                  : 'RETURN DATE',
                              paddingx: EdgeInsets.only(
                                  left: 16, right: 0, top: 4, bottom: 6),
                              box: 1)
                          : SizedBox(
                              width: 0,
                            ),
                    ],
                  ),
                  widget.isRangeMode
                      ? Positioned(
                          top: SizeConfig.blockSizeVertical! * 2.8,
                          left: SizeConfig.blockSizeHorizontal! * 41,
                          child: Container(
                            height: SizeConfig.blockSizeVertical! * 3,
                            width: SizeConfig.blockSizeHorizontal! * 16,
                            child: Center(
                              child: Text(
                                context
                                            .read<ModuleName>()
                                            .returnStandardDate!
                                            .difference(context
                                                .read<ModuleName>()
                                                .departureStandardDate!)
                                            .inDays ==
                                        0
                                    ? "Same Day"
                                    : context
                                            .read<ModuleName>()
                                            .returnStandardDate!
                                            .difference(context
                                                .read<ModuleName>()
                                                .departureStandardDate!)
                                            .inDays
                                            .toString() +
                                        ' Days',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              MyButtonHelperWidget(
                  titleX: 'DONE',
                  onPressedFunction: onPressedFunction,
                  widthx: SizeConfig.blockSizeHorizontal! * 92,
                  heightX: SizeConfig.blockSizeVertical! * 6.5,
                  colorx: ColorCodeGen.colorFromHex('#0e3957'),
                  radiusX: 2.0),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedFunction() async {
    if (widget.isRangeMode) {
      if (context.read<ModuleName>().returnDate == '--') {
        if (widget.type == 'HotelCalender') {
          Fluttertoast.showToast(msg: 'Please Select CHECK-OUT Date');
        } else {
          Fluttertoast.showToast(msg: 'Please Select Return Date');
        }
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Widget returnDateSelectedBox(
      {String? selectedDateX,
      Color? colorx,
      String? text,
      EdgeInsetsGeometry? paddingx,
      int? box}) {
    return Container(
      height: SizeConfig.blockSizeVertical! * 8.5,
      width: widget.isRangeMode
          ? SizeConfig.blockSizeHorizontal! * 44
          : SizeConfig.blockSizeHorizontal! * 92,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: colorx!)),
      child: Padding(
        padding: paddingx!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizeConfig.screenWidth! > 320
                ? SizedBox(
                    height: SizeConfig.blockSizeVertical! * 1,
                  )
                : SizedBox(
                    height: SizeConfig.blockSizeVertical! * .2,
                  ),
            Text(text!,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 14,
                  color: colorx,
                  fontWeight: FontWeight.w600,
                ))),
            SizedBox(
              height: 6,
            ),
            Flexible(
              child: Text(
                selectedDateX!,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: widget.isRangeMode == false && box == 1 ? 10 : 14,
                  color: widget.isRangeMode == false && box == 0 ||
                          widget.isRangeMode == true && box == 1 ||
                          widget.isRangeMode == true && box == 0
                      ? Colors.black
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                )),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
