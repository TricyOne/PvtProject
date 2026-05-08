import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'community_screen.dart';
import 'ice_report/ice_report_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'search_page.dart';

class MainNavigation extends StatefulWidget{
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>{
  int _selectedIndex = 0;

  final List<Widget> _pages = const[
    HomeScreen(),
    CommunityScreen(),
    IceReportScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,

        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black),
          onSelected: (value){

          },
          itemBuilder: (context) =>[
            const PopupMenuItem(
              value: 'settings',
              child: Text('Settings'),
            ),
            const PopupMenuItem(
              value: 'saved',
              child: Text('Saved'),
            ),
            const PopupMenuItem(
              value: 'reports',
              child: Text('Reports'),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Log out'),
            ),
          ],
        ),

        title: Image.asset(
          'assets/skate.png',
          height: 40,
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        type: BottomNavigationBarType.fixed,

        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Community',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Ice Report',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}