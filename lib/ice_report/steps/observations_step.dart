import 'package:flutter/material.dart';
import '../ice_report_model.dart';

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

          // TITLE
          const Text(
            'Observations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // TEXT FIELD
          TextField(
            controller: controller,
            onChanged: _onChanged,
            maxLines: 6,

            decoration: InputDecoration(
              hintText:
                  'Add notes on ice texture, snow cover, shore access or share your thoughts...',

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              suffixIcon: const Icon(Icons.edit),
            ),
          ),

          const SizedBox(height: 20),

          // PHOTO BOX
          Container(
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
                      onPressed: _addPhoto,
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

                    const Text(
                      'Tap to add image from camera or gallery',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // RATING TITLE
          const Text(
            'Rate Your Ice Experience!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // STARS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= rating;

              return IconButton(
                onPressed: () => _setRating(starIndex),
                icon: Icon(
                  Icons.star,
                  color: isFilled ? Colors.black : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}