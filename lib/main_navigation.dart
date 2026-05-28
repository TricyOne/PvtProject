import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'community_screen.dart';
import 'ice_report/ice_report_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'search_page.dart';
import 'menu_extended.dart';

class MainNavigation extends StatefulWidget {
  final bool isGuest;
  const MainNavigation({super.key, this.isGuest = false});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CommunityScreen(),
    IceReportScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    const guestBlockedIndexes =
        <int>{}; //1 = gästinlogg kan inte använda community-knappen
    if (widget.isGuest && guestBlockedIndexes.contains(index)) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1E4FF),
      drawer: MenuExtended(isGuest: widget.isGuest),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: Image.asset('assets/noto-v1_ice-skate.png', height: 60),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
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

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Ice Report',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
