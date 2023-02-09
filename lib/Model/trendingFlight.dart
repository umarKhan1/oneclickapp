class TrendingAirportsModel {
  List<TrendingAirportsDataModel> trendingAirportsDataModel = [];
  List<TrendingAirportsDataModel> fromJson(List<dynamic> json) {
    for (int i = 0; i < json.length; i++) {
      trendingAirportsDataModel.add(TrendingAirportsDataModel(
          cityfullName: json[i]['city_fullname'],
          code: json[i]['code'],
          countryCode: json[i]['CountryCode'],
          cityCode: json[i]['CityCode'],
          cityName: json[i]['CityName'],
          popularSearchCount: json[i]['PopularSearchCount'],
          name: json[i]['name'],
          countryName: json[i]['CountryName']));
    }
    return trendingAirportsDataModel;
  }
}

class TrendingAirportsDataModel {
  String cityfullName;
  String code;
  String countryCode;

  String cityCode;
  String cityName;
  String popularSearchCount;
  String name;
  String countryName;

  TrendingAirportsDataModel({
    required this.cityfullName,
    required this.code,
    required this.countryCode,
    required this.cityCode,
    required this.cityName,
    required this.popularSearchCount,
    required this.name,
    required this.countryName,
  });
}
