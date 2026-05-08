import 'package:flutter/material.dart';
import '../ice_report_model.dart';

class IceTypeStep extends StatelessWidget {
  final IceReportModel report;

  const IceTypeStep({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          report.iceType = value;
        },
        decoration: const InputDecoration(
          labelText: 'Ice Type',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}