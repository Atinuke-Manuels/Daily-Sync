import 'package:daily_sync/views/user/daily_standup_screen.dart';
import 'package:daily_sync/views/user/user_home_screen.dart';
import 'package:flutter/material.dart';

import 'all_submissions_screen.dart';


class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({super.key});

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _screenOptions = <Widget>[
    UserHomeScreen(),
    MyDailyStandupReportsScreen(),
    AllSubmissionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _screenOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My report'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'All StandUps'),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}