class IceReportModel {
  String? addReportFor;
  String? iceType;
  String? iceSurface;
  String? observations;

  double iceThickness = 0;

  bool isNow = true;
  DateTime? selectedDateTime;

  int rating = 0;
  Map<String, dynamic> toJson() {
    final DateTime finalDateTime = isNow
        ? DateTime.now()
        : (selectedDateTime ?? DateTime.now());

    return {
      "addReportFor": addReportFor,
      "iceType": iceType, 
      "iceSurface": iceSurface,
      "observations": observations,
      "iceThickness": iceThickness,
      "rating": rating,
      "dateTime": finalDateTime.toIso8601String(),
    };
  }
}