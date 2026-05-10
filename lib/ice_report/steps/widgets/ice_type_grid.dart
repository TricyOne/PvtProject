import 'package:flutter/material.dart';
import '../../ice_report_model.dart';
import 'ice_type_item.dart';

class IceTypeGrid extends StatefulWidget {
  final IceReportModel report;
  final Function(String value) onSelected;
  final List<IceTypeItem> items;

  const IceTypeGrid({
    super.key,
    required this.report,
    required this.onSelected,
    required this.items,
  });

  @override
  State<IceTypeGrid> createState() => _IceTypeGridState();
}

class _IceTypeGridState extends State<IceTypeGrid> {
  String? selected;

  void _select(String value) {
    setState(() {
      selected = value;
    });

    widget.onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GRID
        Expanded(
          child: GridView.builder(
            itemCount: widget.items.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemBuilder: (context, index) {
              final item = widget.items[index];

              final isSelected = selected == item.name;

              return GestureDetector(
                onTap: () => _select(item.name),

                child: Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.shade50
                        : Colors.white,

                    border: Border.all(
                      color: isSelected
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.help_outline),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Info for ${item.name}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // IMAGE PLACEHOLDER
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ÖVRIGT / OSÄKER
        Center(
          child: SizedBox(
            width: 220,
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,

              title: const Text(
                'Övrigt / Osäker',
                textAlign: TextAlign.center,
              ),

              value: 'Övrigt/Osäker',
              groupValue: selected,

              onChanged: (value) {
                if (value == null) return;
                _select(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}