import 'dart:io';

class MyConstants {
  static String rateTheApp = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=com.app.oneclicktravel"
      : 'https://apps.apple.com/us/app/';
  static String fbLink = 'https://m.facebook.com/www.Oneclicktravel.in/';
  static String instaLink = 'https://www.instagram.com/1click_travel/';
  static String twitterLink = 'https://twitter.com/oneclicktravel';
  static String youtubeLink = 'https://oneclicktravel/';
  static const String privacyPolicyWebURL =
      'https://www.oneclicktravel.in/privacy-policy-mobile/';
  static const String termsConditionWebURL =
      'https://www.oneclicktravel.in/terms-and-conditions-mobile/';

  static String urlCountryInfo =
      'https://www.abengines.com/api/country-list/get-country-code.php?action=getCountryList';
}
