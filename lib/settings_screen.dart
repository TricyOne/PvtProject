import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Settings Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('[in development]'),
          ],
        ),
      ),
    );
  }
}
