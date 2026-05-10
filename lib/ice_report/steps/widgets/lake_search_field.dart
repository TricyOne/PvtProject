import 'package:flutter/material.dart';
import '../../ice_report_model.dart';

class LakeSearchField extends StatefulWidget {
  final IceReportModel report;

  const LakeSearchField({
    super.key,
    required this.report,
  });

  @override
  State<LakeSearchField> createState() => _LakeSearchFieldState();
}

class _LakeSearchFieldState extends State<LakeSearchField> {

  final List<String> lakes = [
    'Vänern',
    'Vättern',
    'Mälaren',
    'Hjälmaren',
    'Storsjön',
  ];

  List<String> filtered = [];

  void _filter(String query) {
    if (query.isEmpty) {
      setState(() => filtered = []);
      return;
    }

    setState(() {
      filtered = lakes
          .where((l) => l.toLowerCase().contains(query.toLowerCase()))
          .toList();

      widget.report.addReportFor = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextField(
          onChanged: _filter,

          decoration: InputDecoration(
            hintText: 'Search for a lake',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {},
            ),
          ),
        ),

        if (filtered.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final lake = filtered[index];

                return ListTile(
                  title: Text(lake),
                  onTap: () {
                    setState(() {
                      widget.report.addReportFor = lake;
                      filtered = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}