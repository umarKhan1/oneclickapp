
import 'package:flutter/cupertino.dart';

class MyUser with ChangeNotifier {
  String? name, lname, email, userType, custid, userid, pid;

  fromJson(Map<String, dynamic> json) {
    name = json['user_name'];
    lname = json['last_name'];
    email = json['user_email'];

    userType = json['user_type'];
    custid = json['cust_id'];
    userid = json['user_id'];
    pid = json['pid'];
    notifyListeners();
    return this;
  }

  setName(dynamic firstName, dynamic lastName) {
    name = firstName;
    lname = lastName;
    notifyListeners();
  }

  setEmail(dynamic emailX) {
    this.email = emailX;
    notifyListeners();
  }

  String toJson() {
    return '{"user_name": "$name", "last_name": "$lname","user_email": "$email","user_type": "$userType", "custid": "$custid", "user_id": "$userid","pid": "$pid"}';
  }
}
// {flag: 1, user_id: 61867d0cd294d, user_email: sarfaraz.adivaha@gmail.com, user_name: sarfaraz, user_type: customer, pid: 77A89008, cust_id: 89008, last_name: Alam}"