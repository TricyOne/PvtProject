import 'package:flutter/material.dart';

class ObservationRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const ObservationRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const Text(
          'Rate Your Ice Experience!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= rating;

            return IconButton(
              onPressed: () => onRatingChanged(starIndex),

              icon: Icon(
                Icons.star,
                color: isFilled ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}