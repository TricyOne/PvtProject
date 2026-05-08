import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA5D8FF),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    decoration: new BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    height: 190,
                    child: Image.asset('assets/profile.png', fit: BoxFit.fill)
                ),
                Align(
                  alignment: AlignmentGeometry.xy(.3, 1),
                  heightFactor: 4,
                  child: Icon(Icons.edit, size: 40),
                )
              ],
            ),
            /*Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset('assets/profile.png', height: 190),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 80.0, ),
              child: Icon(Icons.edit),
            ),*/

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: 
                Text(
                'UserName',
                style: TextStyle(fontSize: 28),
                ),
            ),

            const SizedBox(height: 24),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.groups,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Friends',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
            ),

            const SizedBox(height: 24),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.edit_note,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Edit profile information',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.library_books_outlined,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Your ice reports',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Saved locations',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            TextButton(
                onPressed: () {
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 30,
                      weight: 700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),
        ]
        )
      )
    );
  }
}