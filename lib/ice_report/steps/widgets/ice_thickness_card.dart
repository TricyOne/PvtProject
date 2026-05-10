import 'package:flutter/material.dart';
import '../../ice_report_model.dart';

class IceThicknessCard extends StatefulWidget {
  final IceReportModel report;

  const IceThicknessCard({
    super.key,
    required this.report,
  });

  @override
  State<IceThicknessCard> createState() => _IceThicknessCardState();
}

class _IceThicknessCardState extends State<IceThicknessCard> {

  double value = 0;
  final controller = TextEditingController();

  void _update(double v) {
    setState(() {
      value = v;
      widget.report.iceThickness = v;
      controller.text = v.toInt().toString();
    });
  }

  @override
  void initState() {
    super.initState();
    value = widget.report.iceThickness;
    controller.text = value.toInt().toString();
  }

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
            'Ice Thickness',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (value > 0) _update(value - 1);
                },
              ),

              Expanded(
                child: Slider(
                  value: value,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  onChanged: _update,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (value < 30) _update(value + 1);
                },
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 70,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed <= 30) {
                      _update(parsed);
                    }
                  },
                ),
              ),

              const SizedBox(width: 8),
              const Text('cm'),
            ],
          ),
        ],
      ),
    );
  }
}