import 'package:flutter/material.dart';
import '../ice_report_model.dart';

class IceSurfaceStep extends StatelessWidget {
  final IceReportModel report;

  const IceSurfaceStep({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) {
          report.iceSurface = value;
        },
        decoration: const InputDecoration(
          labelText: 'Ice Surface',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}