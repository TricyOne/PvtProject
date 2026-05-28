import 'package:flutter/material.dart';
import '../../ice_report_model.dart';

class ReviewIceSummaryCard extends StatelessWidget {
  final IceReportModel report;

  const ReviewIceSummaryCard({
    super.key,
    required this.report,
  });

  String _formatDateTime(DateTime dt) {
    final date =
        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";

    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

    return "$date at $time";
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = report.isNow
        ? DateTime.now()
        : (report.selectedDateTime ?? DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          // =========================
          // 3 COLUMN SECTION
          // =========================
          IntrinsicHeight(
            child: Row(
              children: [

                // THICKNESS (FIXED)
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Thickness",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Icon(Icons.straighten),

                      const SizedBox(height: 6),

                      Text(
                        "${report.iceThickness.toInt()} cm",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(),

                // TYPE
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Icon(Icons.ac_unit),

                      const SizedBox(height: 6),

                      Text(
                        report.iceType ?? "Unknown",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(),

                // SURFACE
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Surface",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Icon(Icons.terrain),

                      const SizedBox(height: 6),

                      Text(
                        report.iceSurface ?? "Unknown",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 10),

          // DATE/TIME
          Text(
            _formatDateTime(dateTime),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}