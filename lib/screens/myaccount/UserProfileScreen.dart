import 'package:oneclicktravel/Model/FetchUpdateCustomerDetails.dart';
import 'package:oneclicktravel/helperwidgets/circularProgIndi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';
import 'package:oneclicktravel/helperwidgets/MyTextField.dart';

import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController iscCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  List title = [];

  @override
  void initState() {
    super.initState();
    title = ['Mr', 'Ms', 'Mrs'];
    selectedIndexTitle = context
                .read<FetchUpdateCustomerDetails>()
                .preTitle
                .toString() ==
            'Mr'
        ? 0
        : context.read<FetchUpdateCustomerDetails>().preTitle.toString() == 'Ms'
            ? 1
            : 2;
    firstNameController.text =
        context.read<FetchUpdateCustomerDetails>().firstName.toString();

    lastNameController.text =
        context.read<FetchUpdateCustomerDetails>().lastName.toString();

    emailController.text =
        context.read<FetchUpdateCustomerDetails>().email.toString();
    phoneController.text =
        context.read<FetchUpdateCustomerDetails>().phone.toString();
    iscCodeController.text =
        context.read<FetchUpdateCustomerDetails>().extPhone.toString();

    addressController.text =
        context.read<FetchUpdateCustomerDetails>().address.toString();
    cityController.text =
        context.read<FetchUpdateCustomerDetails>().city.toString();
    stateController.text =
        context.read<FetchUpdateCustomerDetails>().state.toString();
    postalCodeController.text =
        context.read<FetchUpdateCustomerDetails>().postalCode.toString();
    countryController.text =
        context.read<FetchUpdateCustomerDetails>().countryName.toString();
  }

  TextStyle moduleNameStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400, color: Colors.black87, fontSize: 13));
  int selectedIndexTitle = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: context.watch<FetchUpdateCustomerDetails>().status == true
          ? ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical! * 32,
                      child: Image.asset(
                        'assets/edit_profile_back.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical! * 32,
                      color: Colors.black54,
                    ),
                    SafeArea(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30, top: 10),
                            child: Text(
                              'Edit Profile',
                              style: moduleNameStyle.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Material(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: new IconButton(
                                // splashColor: Colors.amber,
                                // highlightColor: Colors.red,
                                icon: new Icon(Icons.check),
                                onPressed: () async {
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .setStatus(false);
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .preTitle = title[selectedIndexTitle];

                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .firstName = firstNameController.text;
                                  // context.read<MyUser>().name =
                                  //     firstNameController.text;
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .lastName = lastNameController.text;
                                  context.read<MyUser>().setName(
                                      firstNameController.text,
                                      lastNameController.text);

                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .phone = phoneController.text;
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .city = cityController.text;
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .state = stateController.text;
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .postalCode = postalCodeController.text;
                                  context
                                      .read<FetchUpdateCustomerDetails>()
                                      .address = addressController.text;
                                  // context
                                  //     .read<FetchUpdateCustomerDetails>()
                                  //     .countryCode = countryController.text;

                                  var updateResponse = await context
                                      .read<FetchUpdateCustomerDetails>()
                                      .updateCustomerDetails();

                                  if (updateResponse['status'] == 200) {
                                    Fluttertoast.showToast(
                                        msg: 'Details Updated Sucessfully');
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: updateResponse['message']
                                            .toString());
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: SizeConfig.blockSizeVertical! * 1,
                      left: SizeConfig.blockSizeHorizontal! * 2,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/avtar.png'),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Hi, ' +
                                    context
                                        .read<FetchUpdateCustomerDetails>()
                                        .firstName
                                        .toString() +
                                    ' ' +
                                    context
                                        .read<FetchUpdateCustomerDetails>()
                                        .lastName
                                        .toString(),
                                style: moduleNameStyle.copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Positioned(
                              bottom: SizeConfig.blockSizeVertical! * 1,
                              left: 40,
                              child: FaIcon(FontAwesomeIcons.camera))
                        ],
                      ),
                    ),
                    // Positioned(
                    //     bottom: SizeConfig.blockSizeVertical * 2,
                    //     left: SizeConfig.blockSizeHorizontal * 12,
                    //     child: FaIcon(FontAwesomeIcons.camera))
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 3),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal! * 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey

                          //  ColorCodeGen
                          //     .colorFromHex(
                          //         '#186900')
                          ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndexTitle = 0;

                                  print(
                                      'get adult title of ms============$selectedIndexTitle');

                                  // print(
                                  //     titleMrMsMrsAdult);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: selectedIndexTitle == 0
                                        ? Colors.grey.shade400
                                        : Colors.transparent,
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.blueGrey,
                                        // ColorCodeGen.colorFromHex(
                                        //     '#189600'),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    title[0],
                                    style: moduleNameStyle.copyWith(
                                        color: ColorCodeGen.colorFromHex(
                                            '#0e3957')),
                                  ))),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndexTitle = 1;

                                  print(
                                      'get adult title of ms============$selectedIndexTitle');

                                  // print(
                                  //     titleMrMsMrsAdult);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedIndexTitle == 1
                                        ? Colors.grey.shade400
                                        : Colors.transparent,
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.blueGrey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    title[1],
                                    style: moduleNameStyle.copyWith(
                                        color: ColorCodeGen.colorFromHex(
                                            '#0e3957')),
                                  ))),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndexTitle = 2;

                                  print(
                                      'get adult title of ms============$selectedIndexTitle');

                                  // print(
                                  //     titleMrMsMrsAdult);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedIndexTitle == 2
                                        ? Colors.grey.shade400
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                      child: Text(
                                    title[2],
                                    style: moduleNameStyle.copyWith(
                                        color: ColorCodeGen.colorFromHex(
                                            '#0e3957')),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'First Name',
                          controller: firstNameController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'Last Name',
                          controller: lastNameController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  child: MyTextField(
                    labelText: 'Email',
                    controller: emailController,
                    keyboardtype: TextInputType.emailAddress,
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'ISD Code',
                          controller: iscCodeController,
                          keyboardtype: TextInputType.number,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'Mobile Number',
                          controller: phoneController,
                          keyboardtype: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'City',
                          controller: cityController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'State',
                          controller: stateController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  child: MyTextField(
                    labelText: 'Address',
                    controller: addressController,
                    keyboardtype: TextInputType.text,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'Postal Code',
                          controller: postalCodeController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 20.0),
                        child: MyTextField(
                          labelText: 'Country',
                          controller: countryController,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
                // Spacer(),
                // context.watch<MyUser>().email != null
                //     ? ActionChip(
                //         backgroundColor: ColorCodeGen.colorFromHex('#0e3957'),
                //         avatar: Icon(Icons.logout),
                //         label: Text(
                //           'LOG OUT',
                //           style: GoogleFonts.poppins(
                //             textStyle: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white,
                //                 fontSize: 16),
                //           ),
                //         ),
                //         onPressed: () {
                //           returnLogoutPopup(context);
                //         })
                //     : SizedBox(),
                // Text(
                //   'LOG OUT',
                //   style: context
                //       .read<ModuleName>()
                //       .moduleNameStyle
                //       .copyWith(color: ColorCodeGen.colorFromHex('#0e3957')),
                // ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          : CircularProgIndicator(),

      bottomNavigationBar: context.watch<MyUser>().email != null
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: ActionChip(
                  backgroundColor: ColorCodeGen.colorFromHex('#0e3957'),
                  avatar: Icon(Icons.logout),
                  label: Text(
                    'LOG OUT',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    returnLogoutPopup(context);
                  }),
            )
          : SizedBox(),
    );
  }

  returnLogoutPopup(BuildContext context) {
    // set up the AlertDialog

    dynamic alert = CupertinoAlertDialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text("Are you sure , You want to logout ?",
                textAlign: TextAlign.center,
                style: moduleNameStyle.copyWith(
                    color: ColorCodeGen.colorFromHex('#0e3957'))),
          ),
          Container(height: 25),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    child: Text('Cancel',
                        style: moduleNameStyle.copyWith(
                            color: ColorCodeGen.colorFromHex('#0e3957'))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                ElevatedButton(
                    child: Text('Yes',
                        style: moduleNameStyle.copyWith(
                            color: ColorCodeGen.colorFromHex('#0e3957'))),
                    onPressed: () async {
                      Navigator.pop(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove("signInUser");
                      context.read<MyUser>().setEmail(null);

                      Navigator.pop(context);
                    })
              ])
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
