import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    void _onItemTapped(int index){
      setState((){
        _selectedIndex = index;
      });
    }
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.house_fill, ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.clear_circled_solid),
            label: 'Lost',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.check_mark_circled_solid),
            label: 'Found',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person_crop_square_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
