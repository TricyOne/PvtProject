import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_model.dart';

class LocationService {

  static const String baseUrl =
      'http://194.104.94.159:8080/api/locations';

  static Future<List<LocationModel>> fetchLocations() async {

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load locations");
    }

    final List data = jsonDecode(response.body);

    return data
        .map((json) => LocationModel.fromJson(json))
        .toList();
  }
}