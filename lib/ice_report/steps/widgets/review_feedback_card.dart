import 'package:flutter/material.dart';
import '../../ice_report_model.dart';

class ReviewFeedbackCard extends StatelessWidget {
  final IceReportModel report;

  const ReviewFeedbackCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================
          // STARS
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= report.rating;

              return Icon(
                Icons.star,
                color: isFilled ? Colors.black : Colors.grey,
              );
            }),
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 12),

          // =========================
          // OBSERVATIONS
          // =========================
          const Text(
            "Observations",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            report.observations?.isNotEmpty == true
                ? report.observations!
                : "No observations added",
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}