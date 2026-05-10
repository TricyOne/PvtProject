import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'report_screen.dart';
import 'saved_screen.dart';
import 'login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MenuExtended extends StatelessWidget {
  final bool isGuest;
  const MenuExtended({super.key, this.isGuest = false});

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
              enabled: !isGuest,
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
              enabled: !isGuest,
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
              enabled: !isGuest,
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
              enabled: !isGuest,
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                await GoogleSignIn().signOut();

                if (!context.mounted) return;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
