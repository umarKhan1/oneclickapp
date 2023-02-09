import 'package:oneclicktravel/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class FetchUpdateCustomerDetails with ChangeNotifier {
  Future<dynamic> fetchCustomerDetails(String? emailX, String? useridX) async {
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/customer-management/custom-ajax.php?action=fetch_customer_details&pid=${Strings.app_pid}&email=$emailX&user_id=$useridX";

    var response = await http.get(Uri.parse(url));
    log('fetch customer details ------' +
        json.decode(response.body).toString());

    setFetchCustomerData(json.decode(response.body));
    setStatus(true);
    log('countrycode in provider model-------' + countryCode!);
    return json.decode(response.body);
  }

  String? id;
  String? preTitle;
  String? firstName;
  String? lastName;
  String? email;
  String? extPhone;
  String? phone;
  String? address;
  String? city;
  String? countryCode;
  String? countryName;
  String? postalCode;
  String? state;
  dynamic dob;
  dynamic customerWalletCurrency;
  dynamic customerWalletBalance;
  bool status = false;
  setFetchCustomerData(Map<String, dynamic> json) {
    id = json['id'];
    preTitle = json['pre_title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    extPhone = json['ext_phone'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    countryCode = json['country'];
    postalCode = json['postal_code'];
    state = json['state'];
    dob = json['dob'];
    customerWalletCurrency = json['customer_wallet_currency'];
    customerWalletBalance = json['customer_wallet_balance'];

    notifyListeners();
  }

  setStatus(bool statusX) {
    status = statusX;

    notifyListeners();
  }

  Future<dynamic> updateCustomerDetails() async {
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha/apps/modules/customer-management/custom-ajax.php?action=update_customer_details&isautologin=Yes&pid=${Strings.app_pid}&pre_title=$preTitle&first_name=$firstName&last_name=$lastName&email=$email&address=$address&city=$city&postal_code=$postalCode&state=$state&country=$countryCode&ext_phone=$extPhone&phone=$phone&user_id=$id";

    var response = await http.get(Uri.parse(url));
    log('update customer details ------' +
        json.decode(response.body).toString());
    // fetchCustomerDetails(json.decode(response.body));
    setStatus(true);
    return json.decode(response.body);
  }
}
