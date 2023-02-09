import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightData {
  Future<List> getFlightData(val) async {
    var url =
        "https://www.abengines.com/wp-content/plugins/adivaha//apps/modules/adivaha-fly-smart/apiflight_update_rates.php?action=getLocations&limit=5&locale=en&term=$val";
    var response = await http.get(Uri.parse(url));
    List<dynamic> data = jsonDecode(response.body)['airports'];
    return data;
  }
}
