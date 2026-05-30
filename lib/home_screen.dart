import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

const String _apiBaseUrl = 'http://194.104.94.159:8080';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _userPosition = const LatLng(59.406811, 17.945972);
  String _locationLabel = 'Loading...';
  bool _locationLoaded = false;

  List<Map<String, dynamic>> _locations = [];
  Map<String, dynamic>? _selectedLocation;

  Map<String, double> _temperatures = {};
  Map<String, String> _conditions = {};

  final MapController _mapController = MapController();

  final List<Map<String, dynamic>> reports = [
    {
      'time': '12:45, today',
      'location': 'Ensjö',
      'thickness': 10,
      'unit': 'cm',
      'rating': 3,
    },
    {
      'time': '10:00, today',
      'location': 'Annansjö',
      'thickness': 15,
      'unit': 'cm',
      'rating': 5,
    },
    {
      'time': '17:20, 11/12',
      'location': 'Ensjö',
      'thickness': 9,
      'unit': 'cm',
      'rating': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _fetchLocations();
    await _fetchUserPosition();
    _selectNearestLocation();
  }

  Future<void> _fetchUserPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
        _locationLoaded = true;
      });
    } catch (e) {
      // GPS misslyckades - då behålls Stockholm fallback
      debugPrint('GPS error: $e');
    }
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl/api/locations'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _locations = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint('Could not collect lakes/ice-locations: $e');
    }
  }

  void _selectNearestLocation() {
    if (_locations.isEmpty) return;

    Map<String, dynamic>? nearest;
    double shortestDistance = double.infinity;

    for (final loc in _locations) {
      final dist = _calculateDistance(
        _userPosition.latitude,
        _userPosition.longitude,
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
      if (dist < shortestDistance) {
        shortestDistance = dist;
        nearest = loc;
      }
    }

    if (nearest != null) {
      setState(() {
        _selectedLocation = nearest;
        _locationLabel = nearest!['title'] as String;
      });
      _fetchWeather(nearest['id'] as int);
      _mapController.move(
        LatLng(
          (nearest['lat'] as num).toDouble(),
          (nearest['lng'] as num).toDouble(),
        ),
        13.0,
      );
    }
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = lat1 - lat2;
    final dLng = lng1 - lng2;
    return sqrt(dLat * dLat + dLng * dLng);
  }

  Future<void> _fetchWeather(int locationId) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/api/locations/$locationId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = data['weather'];
        if (weather != null) {
          final tempMap = weather['temperature'] as Map<String, dynamic>;
          final condMap = weather['condition'] as Map<String, dynamic>?;
          setState(() {
            _temperatures = tempMap.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            );
            _conditions =
                condMap?.map((key, value) => MapEntry(key, value as String)) ??
                {};
          });
        }
      }
    } catch (e) {
      debugPrint('Could not collect weather: $e');
    }
  }

  List<String> _getSortedHours() {
    final hours = _temperatures.keys.toList();
    hours.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return hours;
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            final filteredLocations = _locations.where((loc) {
              final title = (loc['title'] as String).toLowerCase();
              return title.startsWith(searchQuery.toLowerCase());
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Choose location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search location...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) {
                        setBottomSheetState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: filteredLocations
                          .map(
                            (loc) => ListTile(
                              title: Text(loc['title'] as String),
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  _selectedLocation = loc;
                                  _locationLabel = loc['title'] as String;
                                });
                                _fetchWeather(loc['id'] as int);
                                _mapController.move(
                                  LatLng(
                                    loc['lat'] as double,
                                    loc['lng'] as double,
                                  ),
                                  13.0,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildMapSection(),
          const SizedBox(height: 16),
          _buildRecentReports(),
          const SizedBox(height: 16),
          _buildWeatherSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: _userPosition, initialZoom: 12.0),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_application',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation != null
                    ? LatLng(
                        (_selectedLocation!['lat'] as num).toDouble(),
                        (_selectedLocation!['lng'] as num).toDouble(),
                      )
                    : _userPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF0090FF),
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReports() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2FF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Image.asset('assets/icon_Paper_alt.png', width: 24, height: 24),
            ],
          ),
          const SizedBox(height: 12),
          ...reports.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildReportCard(r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final reportTextStyle = GoogleFonts.amiko(
      color: const Color(0xDB33363F),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return GestureDetector(
      onTap: () {
        //att göra senare: navigera till rapportdetaljer under Map-fliken
        //(väntar på Map-delen har sin detail-vy klar)
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Color(0x99091340), blurRadius: 4)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '[${report['time']}] ',
                      style: reportTextStyle,
                    ),
                    TextSpan(
                      text: '${report['location']} ',
                      style: reportTextStyle.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: '${report['thickness']}',
                      style: reportTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        backgroundColor: _ratingColor(report['rating'] as int),
                      ),
                    ),
                    TextSpan(
                      text: ' ${report['unit']}',
                      style: reportTextStyle.copyWith(
                        decoration: TextDecoration.underline,
                        backgroundColor: _ratingColor(report['rating'] as int),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildStars(report['rating'] as int),
          ],
        ),
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
          size: 16,
        ),
      ),
    );
  }

  Color _ratingColor(int rating) {
    if (rating >= 4) return const Color(0xFF4CAF50);
    if (rating == 3) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  Widget _buildWeatherSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2FF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _showLocationPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        _locationLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.edit, size: 18),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const Text('Today ', style: TextStyle(fontSize: 14)),
                  Image.asset('assets/icon_cloud.png', width: 24, height: 24),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: _temperatures.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _getSortedHours().length,
                    itemBuilder: (context, index) {
                      final hour = _getSortedHours()[index];
                      final temp = _temperatures[hour]!;
                      return _buildWeatherColumn(hour, temp, _conditions[hour]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherColumn(String time, double temp, String? condition) {
    return Container(
      width: 65,
      height: 133,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$time:00', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            '${temp.toStringAsFixed(0)}\u00B0C',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Icon(_conditionIcon(condition), size: 24, color: Colors.black),
        ],
      ),
    );
  }

  IconData _conditionIcon(String? condition) {
    switch (condition) {
      case 'sunny':
        return Icons.wb_sunny_outlined;
      case 'cloudy':
        return Icons.cloud_outlined;
      case 'snow':
        return Icons.ac_unit_outlined;
      case 'rain':
        return Icons.water_drop_outlined;
      default:
        return Icons.thermostat;
    }
  }
}
