import 'package:flutter/material.dart';

class PreviewLakeCard extends StatelessWidget {
  final String lakeName;

  const PreviewLakeCard({
    super.key,
    required this.lakeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'Lake',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            lakeName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}