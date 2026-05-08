import 'package:flutter/material.dart';
import 'ice_report_model.dart';
import 'steps/add_report_for_step.dart';
import 'steps/ice_type_step.dart';
import 'steps/ice_surface_step.dart';
import 'steps/observations_step.dart';

class IceReportScreen extends StatefulWidget {
  const IceReportScreen({super.key});

  @override
  State<IceReportScreen> createState() => _IceReportScreenState();
}

class _IceReportScreenState extends State<IceReportScreen> {
  int _currentStep = 0;

  final IceReportModel report = IceReportModel();

  final List<String> _titles = [
    'Add Report For',
    'Ice Type',
    'Ice Surface',
    'Observations',
  ];

  void _nextStep() {
    if (_currentStep < _titles.length - 1) {
      setState(() => _currentStep++);
    } else {
      _submitReport();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitReport() {
    // Later: send to backend
    debugPrint("Submitting report:");
    debugPrint("AddFor: ${report.addReportFor}");
    debugPrint("IceType: ${report.iceType}");
    debugPrint("Surface: ${report.iceSurface}");
    debugPrint("Obs: ${report.observations}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentStep]),
      ),

      body: Column(
        children: [
          Expanded(
            child: _buildStep(),
          ),

          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return AddReportForStep(report: report);

      case 1:
        return IceTypeStep(report: report);

      case 2:
        return IceSurfaceStep(report: report);

      case 3:
        return ObservationsStep(report: report);

      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // BACK
          if (_currentStep > 0)
            IconButton(
              iconSize: 40,
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back_ios),
            )
          else
            const SizedBox(width: 48),

          // NEXT / SUBMIT
          IconButton(
            iconSize: 40,
            onPressed: _nextStep,
            icon: Icon(
              _currentStep == _titles.length - 1
                  ? Icons.check
                  : Icons.arrow_forward_ios,
            ),
          ),
        ],
      ),
    );
  }
}