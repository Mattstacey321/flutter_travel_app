import 'package:flutter_travel_app/app/data/models/places_models.dart';

class CountryModel {
  String id;
  String name;
  String video;
  String? description;
  List<PlacesModel> placeVisit;
  int get totalPlaceVisit => placeVisit.length;
  CountryModel({
    required this.id,
    required this.name,
    required this.video,
    this.description,
    this.placeVisit = const <PlacesModel>[],
  });
  static fromList(List<dynamic> json) {
    return json.map(
      (item) => CountryModel(
        id: item["id"],
        name: item["name"],
        video: item["video"],
        description: item["description"],
        placeVisit: PlacesModel.fromList(item["placeVisit"]),
      ),
    ).toList();
  }
}
