import 'package:flutter/material.dart';
import '../ice_report_model.dart';
import 'widgets/ice_type_grid.dart';
import 'widgets/ice_type_item.dart';

class IceTypeStep extends StatelessWidget {
  final IceReportModel report;

  const IceTypeStep({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [

          const SizedBox(height: 20),

          const Text(
            'Ice Type',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Choose one of the following',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: IceTypeGrid(
              report: report,

              onSelected: (value) {
                report.iceType = value;
              },

              items: const [
                IceTypeItem('Kärnis', Icons.ac_unit),
                IceTypeItem('Stöpis', Icons.grain),
                IceTypeItem('Nyis', Icons.water),
                IceTypeItem('Snöis', Icons.cloud),
              ],
            ),
          ),
        ],
      ),
    );
  }
}