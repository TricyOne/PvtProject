import 'package:flutter/material.dart';
import '../ice_report_model.dart';

import 'widgets/lake_search_field.dart';
import 'widgets/ice_thickness_card.dart';
import 'widgets/time_of_measurement_card.dart';

class AddReportForStep extends StatelessWidget {
  final IceReportModel report;

  const AddReportForStep({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          const SizedBox(height: 20),

          const Text(
            'Add Report For',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          LakeSearchField(report: report),

          const SizedBox(height: 20),

          IceThicknessCard(report: report),

          const SizedBox(height: 20),

          TimeOfMeasurementCard(report: report),
        ],
      ),
    );
  }
}