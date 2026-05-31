import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Saved Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('[in development]'),
          ],
        ),
      ),
    );
  }
}
