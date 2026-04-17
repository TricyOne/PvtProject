import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle loginStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.cyan,
      textStyle: const TextStyle(fontSize: 20),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Rapportera-is-app')),
      body: Column(
        children: [
          Text('Inloogning'),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Användarnamn',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lösenord',
            ),
            obscureText: true,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: loginStyle,
              onPressed: () {
                //https://docs.flutter.dev/cookbook/navigation/navigation-basics
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Rapportera-is-app'),
                  ),
                );
              },
              child: const Text('Logga in'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Rapportera-is-app'),
                  ),
                );
              },
              child: const Text('Fortsätt som gäst'),
            ),
          ),
        ],
      ),
    );
  }
}
