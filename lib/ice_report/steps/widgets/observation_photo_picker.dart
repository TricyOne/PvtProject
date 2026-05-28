import 'package:flutter/material.dart';

class ObservationPhotoPicker extends StatelessWidget {
  final VoidCallback onAddPhoto;

  const ObservationPhotoPicker({
    super.key,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Add photo...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.image, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 12),

          // BUTTON ROW
          Row(
            children: [

              ElevatedButton(
                onPressed: onAddPhoto,

                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.blue,
                ),

                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Tap to add image from camera or gallery',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}