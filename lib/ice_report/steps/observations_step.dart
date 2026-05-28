import 'package:flutter/material.dart';

import '../ice_report_model.dart';

import 'widgets/observation_photo_picker.dart';
import 'widgets/observation_rating.dart';
import 'widgets/observation_textbox.dart';

class ObservationsStep extends StatefulWidget {
  final IceReportModel report;

  const ObservationsStep({
    super.key,
    required this.report,
  });

  @override
  State<ObservationsStep> createState() => _ObservationsStepState();
}

class _ObservationsStepState extends State<ObservationsStep> {
  late TextEditingController controller;

  int rating = 0;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: widget.report.observations ?? '',
    );

    rating = widget.report.rating;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.report.observations = value;
  }

  void _setRating(int value) {
    setState(() {
      rating = value;
      widget.report.rating = value;
    });
  }

  void _addPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera/gallery will be added later'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [

          const SizedBox(height: 20),

          const Text(
            'Observations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ObservationTextbox(
            controller: controller,
            onChanged: _onChanged,
          ),

          const SizedBox(height: 20),

          ObservationPhotoPicker(
            onAddPhoto: _addPhoto,
          ),

          const SizedBox(height: 20),

          ObservationRating(
            rating: rating,
            onRatingChanged: _setRating,
          ),
        ],
      ),
    );
  }
}