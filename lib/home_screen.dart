import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  final Map<String, double> temperatures = {
    '03': -5.5,
    '06': -4.2,
    '09': -2.1,
    '12': 0.4,
    '15': 1.0,
    '18': -0.8,
    '21': -2.5,
  };

  String selectedLocation = '[Location/Choose location/Solna]';

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
      height: 200,
      child: Image.asset('assets/karta_placeholder.png', fit: BoxFit.cover),
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
                        backgroundColor: _ratingColor(report['rating']),
                      ),
                    ),
                    TextSpan(
                      text: ' ${report['unit']}',
                      style: reportTextStyle.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildStars(report['rating']),
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
                onTap: () {
                  //att göra senare: visa lista med sjöar/platser (från Backend)
                },
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
                        selectedLocation,
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
                  const Text('Today', style: TextStyle(fontSize: 14)),
                  Image.asset('assets/icon_cloud.png', width: 24, height: 24),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: temperatures.length,
              itemBuilder: (context, index) {
                final time = temperatures.keys.elementAt(index);
                final temp = temperatures[time]!;
                return _buildWeatherColumn(time, temp);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherColumn(String time, double temp) {
    return Container(
      width: 65,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$time:00', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Image.asset('assets/icon_snowflake.png', width: 24, height: 24),
          const SizedBox(height: 8),
          Text(
            '${temp.toStringAsFixed(0)}\u00B0C',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
