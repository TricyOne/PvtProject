import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'main.dart';
import 'main_navigation.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '731181554026-tqpv1p3nmve3qjqvoninhfmhutqo0vmt.apps.googleusercontent.com',
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token kunde inte hämtas från Google'),
          ), //svenska/engelska?
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://194.104.94.159:8080/api/auth/oauth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'jwt_token', value: data['accessToken']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
           // builder: (context) => const MyHomePage(title: 'Rapportera-is-app'),
            builder: (context) => const MainNavigation(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log in failed')), //svenska/engelska?
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5D8FF),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),

            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Image.asset('assets/skate.png', height: 100),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _handleGoogleSignIn(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/g-logo.png', height: 24, width: 24),
                    const SizedBox(width: 12),
                    const Text('Continue with Google'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Spacer(flex: 2),

            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                     // builder: (context) => const MyHomePage(title: 'Rapportera-is-app'),
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Continue as a guest',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black,
                      size: 20,
                      weight: 700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
