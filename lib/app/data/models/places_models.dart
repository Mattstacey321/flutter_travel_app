class PlacesModel {
  String name;
  String? description;
  List<String> photos;
  PlacesModel({
    required this.name,
    this.description,
    required this.photos,
  });

  static List<PlacesModel> fromList(List json) {
    return json
        .map(
          (item) => PlacesModel(
            name: item["name"],
            description: item["description"],
            photos: List<String>.from(
              item["photos"],
            ),
          ),
        )
        .toList();
  }
}
