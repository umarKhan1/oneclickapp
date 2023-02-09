import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oneclicktravel/utils/strings.dart';

class HotelData {
  Future<List> getHotelData(val) async {
    print('val in api call $val');
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha//apps/modules/adivaha-two-hotels/update_rates.php?action=getLocations&limit=5&locale=en&pid=${Strings.app_pid}&term=$val";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    List<dynamic> values = data['cities'];
    print(data.toString() + "check hotel data printed");
    return values;
  }
}
