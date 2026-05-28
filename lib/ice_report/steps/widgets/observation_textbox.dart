import 'package:flutter/material.dart';

class ObservationTextbox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ObservationTextbox({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 6,

      decoration: InputDecoration(
        hintText:
            'Add notes on ice texture, snow cover, shore access or share your thoughts...',

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        suffixIcon: const Icon(Icons.edit),
      ),
    );
  }
}