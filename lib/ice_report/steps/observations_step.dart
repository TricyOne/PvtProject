import 'package:flutter/material.dart';
import '../ice_report_model.dart';

class ObservationsStep extends StatelessWidget {
  final IceReportModel report;

  const ObservationsStep({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          report.observations = value;
        },
        decoration: const InputDecoration(
          labelText: 'Observations',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}