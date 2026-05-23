import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'ice_report_model.dart';

class ReportService {

  static const String baseUrl =
      'http://194.104.94.159:8080/api/locations';

  static const FlutterSecureStorage storage =
      FlutterSecureStorage();

  static Future<bool> submitReport(
    IceReportModel report,
  ) async {

    try {

      final token =
          await storage.read(key: 'jwt_token');

      final url =
          '$baseUrl/${report.locationId}/comments';

      final response = await http.post(

        Uri.parse(url),

        headers: {

          'Content-Type':
              'application/json',

          'Authorization':
              'Bearer $token',
        },

        body: jsonEncode(
          report.toJson(),
        ),
      );

      print("STATUS: ${response.statusCode}");

      print("BODY: ${response.body}");

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } catch (e) {

      print("ERROR: $e");

      return false;
    }
  }
}