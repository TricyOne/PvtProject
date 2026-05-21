import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ice_report_model.dart';

class ReportService {
  static const String baseUrl = "http://YOUR_BACKEND_URL/api/reports";

  static Future<bool> submitReport(IceReportModel report) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(report.toJson()),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}