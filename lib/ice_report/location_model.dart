class LocationModel {
  final int id;
  final String title;
  final double lat;
  final double lng;
  final String? description;

  LocationModel({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    this.description,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      title: json['title'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      description: json['description'],
    );
  }
}