import 'package:flutter/material.dart';

import '../ice_report_model.dart';

import 'widgets/preview_lake_card.dart';
import 'widgets/review_ice_summary_card.dart';
import 'widgets/review_feedback_card.dart';

class ReviewSubmitStep extends StatelessWidget {
  final IceReportModel report;

  const ReviewSubmitStep({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // TITLE
          const Center(
            child: Text(
              'Preview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // LAKE
          PreviewLakeCard(
            lakeName: report.addReportFor ?? 'No lake selected',
          ),

          const SizedBox(height: 16),

          // ICE SUMMARY
          ReviewIceSummaryCard(
            report: report,
          ),

          const SizedBox(height: 16),

          // FEEDBACK (NEW)
          ReviewFeedbackCard(
            report: report,
          ),
        ],
      ),
    );
  }
}