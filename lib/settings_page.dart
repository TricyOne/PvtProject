import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle updateStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      textStyle: const TextStyle(fontSize: 20),
    );

    final textHeadStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Inställningar')),
      body: Column(
        children: [
          Text('Användarnamn', style: textHeadStyle),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Användarnamn',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: updateStyle,
              onPressed: () {},
              child: const Text('Uppdatera'),
            ),
          ),
        ],
      ),
    );
  }
}
