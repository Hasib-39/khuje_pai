import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const LostPage(),
    const FoundPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.black,
          indicatorColor: Colors.black, // Optional: subtle highlight for selected item
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Color(0xffe0746e)
                  // Set the font weight
                );
              }
              return GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              );
            },
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: Color(0xffe0746e));
              }
              return IconThemeData(color: Colors.white);
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.house_fill),
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
      ),
    );
  }
}
