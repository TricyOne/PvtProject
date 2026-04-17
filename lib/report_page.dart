import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedQuality = 'perfect';
  Widget _qualityIcon = const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Välj iskvalitet',
        style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
      ),
      Icon(Icons.arrow_drop_down_sharp, color: Colors.lightBlueAccent),
    ],
  );

  void _handleQualityChanged(String newValue) {
    setState(() {
      _selectedQuality = newValue;
      switch (newValue) {
        case ('perfect'):
          _qualityIcon = const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle_sharp, color: Colors.green),
              SizedBox(width: 8),
              Text('Perfekt', style: TextStyle(fontSize: 18)),
            ],
          );
          break;
        case ('passable'):
          _qualityIcon = const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle_sharp, color: Colors.yellow),
              SizedBox(width: 8),
              Text('OK', style: TextStyle(fontSize: 18)),
            ],
          );
          break;
        case ('poor'):
          _qualityIcon = const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle_sharp, color: Colors.red),
              SizedBox(width: 8),
              Text('Dåligt', style: TextStyle(fontSize: 18)),
            ],
          );
      }
    });
  }

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
      appBar: AppBar(title: Text('Rapportera is')),
      body: Column(
        children: [
          Text('Plats', style: textHeadStyle),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '...',
            ),
          ),

          Text('Kvalitet', style: textHeadStyle),
          //https://api.flutter.dev/flutter/material/PopupMenuButton-class.html
          PopupMenuButton<String>(
            icon: _qualityIcon,
            onSelected: _handleQualityChanged,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'perfect',
                child: Row(
                  children: const [
                    Icon(Icons.circle_sharp, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Perfekt'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'passable',
                child: Row(
                  children: const [
                    Icon(Icons.circle_sharp, color: Colors.yellow),
                    SizedBox(width: 8),
                    Text('OK'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'poor',
                child: Row(
                  children: const [
                    Icon(Icons.circle_sharp, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Dåligt'),
                  ],
                ),
              ),
            ],
          ),

          Text('Anteckning (valfritt)', style: textHeadStyle),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '...',
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: updateStyle,
              //https://docs.flutter.dev/cookbook/design/snackbars
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Bekräftelse!')));
                Navigator.pop(context);
              },
              child: const Text('Skapa rapport'),
            ),
          ),
        ],
      ),
    );
  }
}
