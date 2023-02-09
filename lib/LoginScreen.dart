import 'dart:convert';
import 'dart:developer';

import 'package:oneclicktravel/AboutUsPrivacyPolicy.dart';
import 'package:oneclicktravel/AboutUsTermsandCond.dart';
import 'package:oneclicktravel/Model/CountryListModel.dart';
import 'package:oneclicktravel/Model/FetchUpdateCustomerDetails.dart';
import 'package:oneclicktravel/Model/my_user.dart';
import 'package:oneclicktravel/WebSignupScreen.dart';
import 'package:oneclicktravel/deviceType/SizeConfig.dart';

import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:oneclicktravel/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? _passwordController, _emailController;

  bool isLoginBTN = true, isForgetPassword = false;
  bool isLogin = false, credMatched = false, _obscureTextPassword = true;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Image.asset(
              'assets/loginScreen.png',
              fit: BoxFit.fill,
              gaplessPlayback: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              // ColorCodeGen.colorFromHex('#ffd022').withOpacity(.5),
              ColorCodeGen.colorFromHex('#ffd022').withOpacity(.5),
              ColorCodeGen.colorFromHex('#0e3957').withOpacity(.7),
              // ColorCodeGen.colorFromHex('#0e3957').withOpacity(.8),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 6,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 20, right: 20),
                    height: 140,
                    child: Image.asset(
                      Strings.logoUrl,
                      color: Colors.white,
                      fit: BoxFit.fitHeight,
                    )),
                Text(
                  "Let's travel".toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is Required';
                            }

                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return 'Please a valid Email';
                            }

                            return null;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            prefixIcon: Container(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        bottomLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                        bottomRight: Radius.circular(4.0))),
                                child: Icon(LineIcons.user,
                                    color:
                                        ColorCodeGen.colorFromHex('#0000000'))),
                            hintText: "Enter your email",
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        AnimatedSwitcher(
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            // scale: animation,
                            opacity: animation,
                            child: child,
                          ),
                          duration: const Duration(milliseconds: 400),
                          child: isLoginBTN == true && isForgetPassword == false
                              ? TextFormField(
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password is Required';
                                    }
                                    if (value.length < 5) {
                                      return 'Password length must be greater than 5';
                                    }

                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    prefixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        margin:
                                            const EdgeInsets.only(right: 8.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft:
                                                    Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                                bottomRight:
                                                    Radius.circular(4.0))),
                                        child: Icon(
                                          LineIcons.lock,
                                          color: ColorCodeGen.colorFromHex(
                                              '#0000000'),
                                        )),
                                    suffixIcon: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        margin:
                                            const EdgeInsets.only(right: 8.0),
                                        // decoration: BoxDecoration(
                                        //     // color: Colors.white,
                                        //     // borderRadius: BorderRadius.only(
                                        //     //     topLeft: Radius.circular(30.0),
                                        //     //     bottomLeft: Radius.circular(30.0),
                                        //     //     topRight: Radius.circular(30.0),
                                        //     //     bottomRight: Radius.circular(10.0))
                                        //     ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureTextPassword =
                                                  !_obscureTextPassword;
                                            });
                                          },
                                          child: Icon(
                                            _obscureTextPassword
                                                ? LineIcons.eyeSlash
                                                : LineIcons.eye,
                                            color: Colors.white,
                                          ),
                                        )),
                                    hintText: "Enter your password",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                  ),
                                  obscureText: _obscureTextPassword,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(height: 30.0),
                        isLoginBTN != false &&
                                isForgetPassword != true &&
                                credMatched == true
                            ? const Text(
                                'Credentials did not match.',
                                style: TextStyle(color: Colors.white),
                              )
                            : const SizedBox(height: 0),
                        isLoginBTN != false &&
                                isForgetPassword != true &&
                                credMatched == true
                            ? const SizedBox(
                                height: 20,
                              )
                            : const SizedBox(height: 0),
                        SizedBox(
                          width: double.infinity,
                          child: isLogin == false
                              ? ElevatedButton(
                                style: ElevatedButton.styleFrom(    backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  padding: const EdgeInsets.all(20.0),),
                              
                                  child: isLoginBTN
                                      ? Text("Login".toUpperCase())
                                      : Text("Reset Password".toUpperCase()),
                                  onPressed: () async {
                                    if (isLoginBTN == false &&
                                        isForgetPassword == true) {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        setState(() {
                                          log('set =====1====' +
                                              isLogin.toString());

                                          isLogin = true;
                                        });

                                        var response = await forgotPassword(
                                            _emailController!.text);
                                        log(response.toString());
                                        if (response == 1) {
                                          // Navigator.pop(context);
                                          showResponseDialog(response);
                                        } else {
                                          log('else pass');
                                          Navigator.pop(context);
                                          showResponseDialog(response);
                                        }

                                        setState(() {
                                          log('set =====2====' +
                                              isLogin.toString());
                                          isLogin = false;
                                        });
                                      }
                                    } else {
                                      log('set =========' + isLogin.toString());
                                      // isLogin = true;

                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        setState(() {
                                          log('set =====1====' +
                                              isLogin.toString());
                                          isLogin = true;
                                        });
                                        var response =
                                            await requestServerForLogIn(
                                                _emailController!.text,
                                                _passwordController!.text);
                                        log('response ' + response.toString());
                                        if (response['flag'].toString() !=
                                            '0') {
                                          log('got response login');
                                          setState(() {
                                            credMatched = false;
                                          });

                                          log(response['user_email']
                                              .toString());
                                          SharedPreferences _userSignInPrefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await _userSignInPrefs.setString(
                                              "signInUser",
                                              context
                                                  .read<MyUser>()
                                                  .fromJson(response)
                                                  .toJson());
                                          if (context.read<MyUser>().email !=
                                                  null &&
                                              context.read<MyUser>().userid !=
                                                  null) {
                                            context
                                                .read<
                                                    FetchUpdateCustomerDetails>()
                                                .setStatus(false);

                                            if (await context
                                                    .read<
                                                        FetchUpdateCustomerDetails>()
                                                    .fetchCustomerDetails(
                                                        context
                                                            .read<MyUser>()
                                                            .email!,
                                                        context
                                                            .read<MyUser>()
                                                            .userid!) !=
                                                null) {
                                              final CountryListModel
                                                  countryListModel =
                                                  CountryListModel();
                                              log('country code setted=======' +
                                                  context
                                                      .read<
                                                          FetchUpdateCustomerDetails>()
                                                      .countryCode
                                                      .toString());
                                              for (int i = 0;
                                                  i <
                                                      countryListModel
                                                          .countryList.length;
                                                  i++) {
                                                if (countryListModel.countryList
                                                        .elementAt(
                                                            i)['country_code']!
                                                        .toLowerCase() ==
                                                    context
                                                        .read<
                                                            FetchUpdateCustomerDetails>()
                                                        .countryCode!
                                                        .toLowerCase()) {
                                                  context
                                                          .read<
                                                              FetchUpdateCustomerDetails>()
                                                          .countryName =
                                                      countryListModel
                                                              .countryList
                                                              .elementAt(i)[
                                                          'country_name']!;
                                                }
                                              }
                                              Navigator.pop(context);
                                              // Navigator.pop(context);
                                            }
                                          }
                                        } else {
                                          log('null response login');
                                          setState(() {
                                            credMatched = true;
                                          });
                                        }
                                        setState(() {
                                          log('set =====2====' +
                                              isLogin.toString());
                                          isLogin = false;
                                        });
                                      }
                                    }
                                  },
                               
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                    
                      child: const Text(
                        "Create Account",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return WebSignupScreen();
                          },
                          // transitionDuration: Duration(milliseconds: 500),
                          // reverseTransitionDuration: Duration(milliseconds: 200),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // return SharedAxisTransition(
                            //     child: child,
                            //     animation:
                            //         CurvedAnimation(curve: Curves.decelerate, parent: animation),
                            //     secondaryAnimation: secondaryAnimation,
                            //     transitionType: SharedAxisTransitionType.vertical);
                            return FadeTransition(
                                opacity: CurvedAnimation(
                                    curve: Curves.decelerate,
                                    parent: animation),
                                child: child);
                            // return RotationTransition(
                            //   turns: animation,
                            //   child: child,
                            // );
                          },
                        ));
                      },
                    ),
                    Container(
                      color: Colors.white54,
                      width: 2.0,
                      height: 20.0,
                    ),
                    ElevatedButton(
                    
                      child: isLoginBTN != false && isForgetPassword != true
                          ? const Text(
                              "Forgot Password",
                              style: TextStyle(fontSize: 12),
                            )
                          : Text("Login".toUpperCase()),
                      onPressed: () {
                        if (isLoginBTN == false && isForgetPassword == true) {
                          setState(() {
                            credMatched = false;
                            isLoginBTN = true;
                            isForgetPassword = false;
                          });
                        } else {
                          _passwordController!.text = '';
                          setState(() {
                            credMatched = false;
                            isLoginBTN = false;
                            isForgetPassword = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'Terms of Service'.toUpperCase(),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.5,
                            fontSize: 13,
                            color: Colors.cyanAccent
                            // fontWeight: FontWeight.bold,
                            // fontFamily: 'Roboto-Regular',
                            ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const AboutUSTermsandCScreen();
                          },
                          // transitionDuration: Duration(milliseconds: 500),
                          // reverseTransitionDuration: Duration(milliseconds: 200),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // return SharedAxisTransition(
                            //     child: child,
                            //     animation:
                            //         CurvedAnimation(curve: Curves.decelerate, parent: animation),
                            //     secondaryAnimation: secondaryAnimation,
                            //     transitionType: SharedAxisTransitionType.vertical);
                            return FadeTransition(
                                opacity: CurvedAnimation(
                                    curve: Curves.decelerate,
                                    parent: animation),
                                child: child);
                            // return RotationTransition(
                            //   turns: animation,
                            //   child: child,
                            // );
                          },
                        ));
                      },
                    ),
                    // Text('   and  '),
                    Container(
                      color: Colors.white54,
                      width: 2.0,
                      height: 20.0,
                    ),

                    ElevatedButton(
                    
                      child: Text(
                        'Privacy Policy'.toUpperCase(),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.5,
                            fontSize: 13,
                            color: Colors.cyanAccent
                            // fontWeight: FontWeight.bold,
                            // fontFamily: 'Roboto-Regular',
                            ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const AboutUSPrivacyScreen();
                          },
                          // transitionDuration: Duration(milliseconds: 500),
                          // reverseTransitionDuration: Duration(milliseconds: 200),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: CurvedAnimation(
                                    curve: Curves.decelerate,
                                    parent: animation),
                                child: child);
                          },
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  // setState(() {
                  //   gotoHomeScreen = !gotoHomeScreen;
                  // });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    // color: ColorCodeGen.colorFromHex('#0000000'),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showResponseDialog(int i) {
    Dialogs.materialDialog(
      customView: Container(
        // color: Colors.green,
        padding: EdgeInsets.zero,
        height: 60,
        width: 60,
        child: Lottie.asset(
          i == 2
              ? 'assets/lottieAnimations/54117-invalid.json'
              : 'assets/lottieAnimations/68994-success.json',
          fit: BoxFit.contain,
        ),
      ),
      color: Colors.white,
      msg: i == 2
          ? '''Email-id does not exist'''
          : '''Password sent to registed email''',
      title: i == 2 ? 'Password reset failed' : 'Password reset success',

      titleStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: i == 2 ? Colors.red : Colors.green,
              fontSize: 18)),
      msgStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black45,
              fontSize: 14)),
      // lottieBuilder: Lottie.asset(
      //   'assets/38213-error.json',
      //   fit: BoxFit.contain,
      // ),
      context: context,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(SizeConfig.blockSizeHorizontal! * 95,
                  SizeConfig.blockSizeVertical! * 5.5),
              primary: ColorCodeGen.colorFromHex('#010801'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSurface: ColorCodeGen.colorFromHex('#010801')),
          onPressed: () {
            setState(() {
              isLoginBTN = true;
              isForgetPassword = false;
            });
            // Navigator.of(context).pop();
            if (i == 1) {
              Navigator.pop(context);
            }
          },
          child: Text('OK',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 18))),
          // color: ColorCodeGen.colorFromHex('#0e3957'),
          // textStyle: TextStyle(color: Colors.white),
          // iconColor: Colors.white,
        ),
      ],
    );
  }

  Future<dynamic> forgotPassword(String email) async {
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/customer-management/custom-ajax.php?action=ForgetMe&email=$email&login-type=fullpage&pid=${Strings.app_pid}";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    log('forget pass===============');
    log(data.toString());
    return data;
  }

  Future<dynamic> requestServerForLogIn(String email, String password) async {
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/customer-management/custom-ajax.php?action=LoginMe&pid=${Strings.app_pid}&email=${_emailController!.text.trim()}&password=${_passwordController!.text.trim()}&login-type=fullpage";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    // log(response.body.toString());
    return data;
  }
}
