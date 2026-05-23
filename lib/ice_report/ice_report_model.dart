class IceReportModel {

  // LOCATION
  int? locationId;

  String? addReportFor;

  // ICE DATA
  String? iceType;
  String? iceSurface;

  double iceThickness = 1;

  // USER INPUT
  String? observations;

  int rating = 1;

  // TIME
  bool isNow = true;
  DateTime? selectedDateTime;

  // =========================
  // ENUM MAPPING
  // =========================

  String mapIceType(String? value) {

    switch (value) {

      case 'Kärnis':
        return 'KARNIS';

      case 'Stöpis':
        return 'STOPIS';

      case 'Nyis':
        return 'NYIS';

      case 'Snöis':
        return 'SNOIS';

      case 'Övrigt/Osäker':
        return 'OVRIGT';

      default:
        return 'KARNIS';
    }
  }

  String mapIceSurface(String? value) {

    switch (value) {

      case 'Spegelslät':
        return 'SPEGELSLAT';

      case 'Knaggig':
        return 'KNAGGIG';

      case 'Snötäckt':
        return 'SNOTACKT';

      case 'Överis':
        return 'OVERIS';

      case 'Övrigt/Osäker':
        return 'OVRIGT';

      default:
        return 'SPEGELSLAT';
    }
  }

  // =========================
  // JSON
  // =========================

  Map<String, dynamic> toJson() {

    final measuredTime = isNow
        ? DateTime.now()
        : (selectedDateTime ?? DateTime.now());

    return {


      "body": observations,

      "iceThickness": iceThickness.toInt(),

      "iceType": mapIceType(iceType),

      "iceSurface":
          mapIceSurface(iceSurface),

      "rating": rating,

      "measuredAt":
          measuredTime.toIso8601String(),

      // LATER:
      // image upload support
      "imageKey": null,
    };
  }
}