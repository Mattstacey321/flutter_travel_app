import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_travel_app/app/data/models/places_models.dart';

class ApiProvider {
  Future<List<dynamic>> loadJson() async {
    String data = await rootBundle.loadString('assets/data.json');
    final jsonResult = json.decode(data);
    return jsonResult;
  }

  Future<List<PlacesModel>> getData() async {
    return [];
  }
}
