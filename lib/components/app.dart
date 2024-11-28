import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khuje_pai/user_model.dart';
import 'package:khuje_pai/views/home.dart';
import 'package:khuje_pai/views/lost.dart';
import 'package:khuje_pai/views/found.dart';
import 'package:khuje_pai/views/profile.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  User? user = FirebaseAuth.instance.currentUser;
  int selected_index = 0;
  final _pages = [
    const Home(),
    const LostPage(),
    const FoundPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selected_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected_index,
        onDestinationSelected: (index) =>
        setState(() => selected_index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.house_fill,),
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


