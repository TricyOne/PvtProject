import 'package:flutter/material.dart';

import '../../location_model.dart';
import '../../location_service.dart';
import '../../ice_report_model.dart';

class LakeSearchField extends StatefulWidget {
  final IceReportModel report;

  const LakeSearchField({
    super.key,
    required this.report,
  });

  @override
  State<LakeSearchField> createState() =>
      _LakeSearchFieldState();
}

class _LakeSearchFieldState
    extends State<LakeSearchField> {

  List<LocationModel> _locations = [];
  List<LocationModel> _filtered = [];

  bool _loading = true;

  final TextEditingController _controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data =
        await LocationService.fetchLocations();

    setState(() {
      _locations = data;
      _filtered = data;
      _loading = false;
    });
  }

  void _filter(String query) {
    setState(() {
      _filtered = _locations
          .where((l) => l.title
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _select(LocationModel lake) {
    setState(() {
      widget.report.locationId = lake.id;
      widget.report.addReportFor = lake.title;

      _controller.text = lake.title;
      _filtered = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextField(
          controller: _controller,
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

        const SizedBox(height: 8),

        if (_loading)
          const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          )
        else if (_filtered.isNotEmpty)
          Container(
            constraints:
                const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final lake = _filtered[index];

                return ListTile(
                  title: Text(lake.title),
                  onTap: () => _select(lake),
                );
              },
            ),
          ),
      ],
    );
  }
}