import 'package:flutter/material.dart';

const List<(String, String, String)> _feelings = [
  ('HAPPY', 'glad', '\u{1F600}'),
  ('EXCITED', 'upprymd', '\u{1F929}'),
  ('CALM', 'lugn', '\u{1F60C}'),
  ('TIRED', 'trött', '\u{1F971}'),
  ('COLD', 'frusen', '\u{1F976}'),
];

class FeelingPickerScreen extends StatelessWidget {
  const FeelingPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1E4FF),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nytt inlägg',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            'Hur känner du dig?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _feelings.map((f) {
                final (id, label, emoji) = f;
                return _EmojiCard(id: id, label: label, emoji: emoji);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiCard extends StatelessWidget {
  final String id;
  final String label;
  final String emoji;
  const _EmojiCard({
    required this.id,
    required this.label,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pop(context, id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
