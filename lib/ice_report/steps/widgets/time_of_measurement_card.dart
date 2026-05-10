import 'package:flutter/material.dart';
import '../../ice_report_model.dart';

class TimeOfMeasurementCard extends StatefulWidget {
  final IceReportModel report;

  const TimeOfMeasurementCard({
    super.key,
    required this.report,
  });

  @override
  State<TimeOfMeasurementCard> createState() =>
      _TimeOfMeasurementCardState();
}

class _TimeOfMeasurementCardState
    extends State<TimeOfMeasurementCard> {

  bool isNow = true;
  DateTime? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          const Text(
            'Time of measurement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          RadioListTile(
            title: const Text("Just Now"),
            value: true,
            groupValue: isNow,
            onChanged: (v) {
              setState(() {
                isNow = true;
                widget.report.isNow = true;
                widget.report.selectedDateTime = null;
              });
            },
          ),

          RadioListTile(
            title: const Text("Earlier / Select Time"),
            value: false,
            groupValue: isNow,
            onChanged: (v) {
              setState(() {
                isNow = false;
                widget.report.isNow = false;
              });
            },
          ),

          if (!isNow)
            ElevatedButton(
              onPressed: () async {

                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );

                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null) return;

                final dt = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                setState(() {
                  selected = dt;
                  widget.report.selectedDateTime = dt;
                });
              },
              child: const Text("Select Date & Time"),
            ),
        ],
      ),
    );
  }
}