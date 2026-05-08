import 'package:flutter/material.dart';
import '../ice_report_model.dart';

class AddReportForStep extends StatelessWidget {
  final IceReportModel report;

  const AddReportForStep({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          report.addReportFor = value;
        },
        decoration: const InputDecoration(
          labelText: 'Add Report For',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}