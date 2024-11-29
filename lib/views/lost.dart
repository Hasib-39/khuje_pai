import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/app.dart';

class LostPage extends StatelessWidget {
  const LostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Lost',
          style: GoogleFonts.poppins(
            fontSize: 25, // Set the font size
            fontWeight: FontWeight.bold,
            // Set the font weight
          ),
        ),
      ),
    );
  }
}
