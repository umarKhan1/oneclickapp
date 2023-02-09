class TrendingHotelsModel {
  List<TrendingHotelsDataModel> trendingHotelsDataModel = [];
  List<TrendingHotelsDataModel> fromJson(List<dynamic> json) {
    for (int i = 0; i < json.length; i++) {
      trendingHotelsDataModel.add(TrendingHotelsDataModel(
        countryCode: json[i]['CountryCode'],
        latinFullName: json[i]['latinFullName'],
        locationId: json[i]['regionid'],
      ));
    }
    return trendingHotelsDataModel;
  }
}

class TrendingHotelsDataModel {
  String countryCode;

  String latinFullName;

  String locationId;

  TrendingHotelsDataModel({
    required this.countryCode,
    required this.latinFullName,
    required this.locationId,
  });
}
