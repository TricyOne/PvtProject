import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'ice_report/ice_report_screen.dart';

class Location {
  final int id;
  final String name;
  final GeoPoint? point;
  final int? latestThickness;
  final String? imageUrl;

  Location({
    required this.id,
    required this.name,
    this.point,
    this.latestThickness,
    this.imageUrl,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['title'] ?? 'Unknown',
      point: (json['lat'] != null && json['lng'] != null)
          ? GeoPoint(latitude: (json['lat'] as num).toDouble(), longitude: (json['lng'] as num).toDouble())
          : null,
      latestThickness: (json['iceThickness'] as num?)?.toInt(),
      imageUrl: json['imageUrl'],
    );
  }
}

class IceReport {
  final String body;
  final int iceThickness;
  final String iceType;
  final String iceSurface;
  final String measuredAt;
  final int rating;
  final String? imageUrl;

  IceReport({
    required this.body,
    required this.iceThickness,
    required this.iceType,
    required this.iceSurface,
    required this.measuredAt,
    required this.rating,
    this.imageUrl,
  });

  factory IceReport.fromJson(Map<String, dynamic> json) {
    return IceReport(
      body: json['body'] ?? '',
      iceThickness: json['iceThickness'] ?? 0,
      iceType: json['iceType'] ?? 'Unknown',
      iceSurface: json['iceSurface'] ?? 'Unknown',
      measuredAt: json['measuredAt'] ?? '',
      rating: json['rating'] ?? 1,
      imageUrl: json['imageUrl'] ?? json['imageKey'],
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Location> _locations = [];
  bool _isLoading = false;
  late MapController _mapController;
  
  // State for points grouped by color
  List<GeoPoint> _redPoints = [];
  List<GeoPoint> _yellowPoints = [];
  List<GeoPoint> _greenPoints = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(latitude: 58.54000, longitude: 16.21908),
    );
    _fetchLocations();
  }

  void _applyMarkersToMap() {
      _mapController.setStaticPosition(_redPoints, "red_group");
      _mapController.setStaticPosition(_yellowPoints, "yellow_group");
      _mapController.setStaticPosition(_greenPoints, "green_group");

  }

  Future<void> _enableUserLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _mapController.currentLocation();
      await _mapController.enableTracking();
    }
  }

  Future<void> _fetchLocations() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // 1. Fetch all locations
      final response = await http.get(Uri.parse('http://194.104.94.159:8080/api/locations'));
      if (response.statusCode != 200) throw Exception('Failed to load locations');
      
      final List<dynamic> data = jsonDecode(response.body);
      final List<Location> baseLocations = data.map((json) => Location.fromJson(json)).toList();

      // 2. Fetch latest thickness for each location by inspecting its reports
      final updatedLocations = await Future.wait(baseLocations.map((loc) async {
        try {
          final reportRes = await http.get(
            Uri.parse('http://194.104.94.159:8080/api/locations/${loc.id}/comments'),
          );
          if (reportRes.statusCode == 200) {
            final List<dynamic> reports = jsonDecode(reportRes.body);
            if (reports.isNotEmpty) {
              // Sort by measuredAt descending to find the newest report
              reports.sort((a, b) {
                DateTime dtA = DateTime.parse(a['measuredAt']);
                DateTime dtB = DateTime.parse(b['measuredAt']);
                return dtB.compareTo(dtA);
              });
              
              final latestReport = reports.first;
              final thickness = (latestReport['iceThickness'] as num?)?.toInt();
              // Try 'imageUrl' first, then 'imageKey' as a possible alternative
              String? imgUrl = latestReport['imageUrl'] as String?;
              if (imgUrl == null || imgUrl.isEmpty) {
                imgUrl = latestReport['imageKey'] as String?;
              }
              
              debugPrint('IMAGE DATA for ${loc.name}: url=$imgUrl');
              if (loc.name == "Lillsjö") imgUrl = "https://picsum.photos/200";
              
              return Location(
                id: loc.id,
                name: loc.name,
                point: loc.point,
                latestThickness: thickness,
                imageUrl: imgUrl,
              );
            }
          }
        } catch (e) {
          debugPrint('Error fetching report for ${loc.name}: $e');
        }
        return loc;
      }));

      if (mounted) {
        final red = <GeoPoint>[];
        final yellow = <GeoPoint>[];
        final green = <GeoPoint>[];

        for (final loc in updatedLocations) {
          if (loc.point == null) continue;
          
          final thickness = loc.latestThickness ?? 0;
          if (thickness <= 10) {
            red.add(loc.point!);
          } else if (thickness <= 14) {
            yellow.add(loc.point!);
          } else {
            green.add(loc.point!);
          }
        }

        setState(() {
          _locations = updatedLocations;
          _redPoints = red;
          _yellowPoints = yellow;
          _greenPoints = green;
        });

        // Try to apply markers immediately
        _applyMarkersToMap();
      }
    } catch (e) {
      debugPrint('Error fetching locations: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: OSMFlutter(
              key: ValueKey('map_${_redPoints.length}_${_yellowPoints.length}_${_greenPoints.length}'),
              controller: _mapController,
              onMapIsReady: (isReady) async {
                if (isReady) {
                  _applyMarkersToMap();
                  await _enableUserLocation();
                }
              },
              osmOption: OSMOption(
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56.0,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.navigation,
                      color: Colors.blue,
                      size: 56.0,
                    ),
                  ),
                ),
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                staticPoints: [
                  StaticPositionGeoPoint(
                    "red_group",
                    const MarkerIcon(
                      icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
                    ),
                    _redPoints,
                  ),
                  StaticPositionGeoPoint(
                    "yellow_group",
                    const MarkerIcon(
                      icon: Icon(Icons.location_pin, color: Colors.orange, size: 48),
                    ),
                    _yellowPoints,
                  ),
                  StaticPositionGeoPoint(
                    "green_group",
                    const MarkerIcon(
                      icon: Icon(Icons.location_pin, color: Colors.green, size: 48),
                    ),
                    _greenPoints,
                  ),
                ],
              ),
              onGeoPointClicked: (point) {
                // Find location by matching coordinates
                final location = _locations.firstWhere(
                  (l) =>
                      l.point != null &&
                      l.point!.latitude == point.latitude &&
                      l.point!.longitude == point.longitude,
                  orElse: () => Location(id: -1, name: 'Unknown'),
                );

                if (location.id != -1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(location.name),
                      content: const Text('Would you like to see the ice reports for this location?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IceReportsScreen(
                                  locationId: location.id,
                                  locationName: location.name,
                                ),
                              ),
                            );
                          },
                          child: const Text('See reports'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.07,
            minChildSize: 0.07,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: _isLoading || _locations.isEmpty ? 1 : _locations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Ice Locations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (_locations.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(child: Text('No locations found')),
                            ),
                        ],
                      );
                    }

                    final location = _locations[index - 1];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: location.imageUrl != null && location.imageUrl!.isNotEmpty
                              ? Image.network(
                                  location.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.blue[50], child: const Icon(Icons.image_not_supported, color: Colors.blue)),
                                )
                              : Container(
                                  color: Colors.blue[50],
                                  child: const Icon(Icons.water, color: Colors.blue),
                                ),
                        ),
                      ),
                      title: Text(location.name),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IceReportsScreen(
                              locationId: location.id,
                              locationName: location.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class IceReportsScreen extends StatefulWidget {
  final int locationId;
  final String locationName;

  const IceReportsScreen({
    super.key,
    required this.locationId,
    required this.locationName,
  });

  @override
  State<IceReportsScreen> createState() => _IceReportsScreenState();
}

class _IceReportsScreenState extends State<IceReportsScreen> {
  List<IceReport> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final response = await http.get(
        Uri.parse('http://194.104.94.159:8080/api/locations/${widget.locationId}/comments'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<IceReport> reports = data.map((json) => IceReport.fromJson(json)).toList();
        
        // Sort by measuredAt descending (newest first)
        reports.sort((a, b) {
          DateTime dtA = DateTime.tryParse(a.measuredAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
          DateTime dtB = DateTime.tryParse(b.measuredAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
          return dtB.compareTo(dtA);
        });

        if (mounted) {
          setState(() {
            _reports = reports;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName),
        backgroundColor: Colors.blue[100],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No reports yet for ${widget.locationName}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    final userNumber = _reports.length - index; // User #1 for first report, etc.
                    
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage('assets/icon_sample_user.png'),
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'User #$userNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${report.iceThickness} cm',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              report.iceType,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Surface: ${report.iceSurface}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                _buildStars(report.rating),
                              ],
                            ),
                            if (report.body.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(report.body),
                            ],
                            if (report.imageUrl != null && report.imageUrl!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  report.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildImagePlaceholder(),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 12),
                              _buildImagePlaceholder(),
                            ],
                            const Divider(height: 24),
                            Text(
                              'Reported at: ${report.measuredAt}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IceReportScreen()),
          );
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
          const SizedBox(height: 8),
          Text(
            'No image provided',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      ),
    );
  }
}
