import 'package:flutter/material.dart';

import '../main_navigation.dart';

import 'ice_report_model.dart';
import 'report_service.dart';

import 'steps/add_report_for_step.dart';
import 'steps/ice_type_step.dart';
import 'steps/ice_surface_step.dart';
import 'steps/observations_step.dart';
import 'steps/review_submit_step.dart';

class IceReportScreen extends StatefulWidget {
  const IceReportScreen({super.key});

  @override
  State<IceReportScreen> createState() => _IceReportScreenState();
}

class _IceReportScreenState extends State<IceReportScreen> {
  int _currentStep = 0;

  final int _totalSteps = 5;

  final IceReportModel report = IceReportModel();

  // NEXT STEP
  void _nextStep() {
    final isLastStep = _currentStep == _totalSteps - 1;

    if (isLastStep) {
      _submitReport();
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  // PREVIOUS STEP
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // SUBMIT REPORT
  void _submitReport() async {
    final success = await ReportService.submitReport(report);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Report submitted!"),
        ),
      );

      // Go to Home and clear stack (fixes black screen issue)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to submit report"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // STEP CONTENT ONLY
            Expanded(
              child: _buildStep(),
            ),

            // NAVIGATION
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  // STEP SWITCH
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

      case 4:
        return ReviewSubmitStep(report: report);

      default:
        return const SizedBox();
    }
  }

  // NAVIGATION
  Widget _buildNavigation() {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),

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
              isLastStep
                  ? Icons.check
                  : Icons.arrow_forward_ios,
            ),
          ),
        ],
      ),
    );
  }
}