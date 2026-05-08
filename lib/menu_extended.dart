import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'report_screen.dart';
import 'saved_screen.dart';

class MenuExtended extends StatelessWidget {
  const MenuExtended({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.35,
      backgroundColor: const Color(0xFFC1DAEF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Saved',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SavedScreen()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //to-do: logga ut google-users
              },
            ),
          ],
        ),
      ),
    );
  }
}
