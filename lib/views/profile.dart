import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khuje_pai/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
            'Profile',
          style: GoogleFonts.poppins(
            fontSize: 25, // Set the font size
            fontWeight: FontWeight.bold,
            // Set the font weight
          ),
        ),
      ),
      body: ChangeNotifierProvider(
          create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
            builder: (context, provider, child){
              return Stack(
                children: [
                  Column(
                    children: [
                      // StreamBuilder to fetch user data from Firestore
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("User")
                            .where("id", isEqualTo: user?.uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(child: Text("An error occurred."));
                          }

                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                            var userDoc = snapshot.data!.docs.first;

                            return Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(16.0),
                                children: [
                                  // Displaying profile image in a container with border radius
                                  Stack(
                                      alignment: Alignment.bottomCenter,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                                          child: Container(
                                            width: 140, // Size of the image (matching CircleAvatar's radius * 2)
                                            height: 140,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 4,
                                                color: Colors.black,
                                              ),
                                              // Set shape to rectangle
                                              // 50% border radius makes it circular
                                              image: DecorationImage(
                                                image: provider.image == null
                                                    ? userDoc['imgUrl'] == ""
                                                    ? const AssetImage("images/default_profile.png")
                                                    : NetworkImage(userDoc['imgUrl']) as ImageProvider
                                                    : FileImage(File(provider.image!.path).absolute),

                                                    fit: BoxFit.contain, // Ensures the image is contained within the box
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            provider.pickImage(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle
                                            ),
                                            child: const CircleAvatar(
                                              radius: 14,

                                              backgroundColor: Colors.black,
                                              child: Icon(Icons.add, size: 20, color: Colors.white,),
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                  const SizedBox(height: 24),
                                  // Displaying user fields in a list manner
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Personal Information",
                                        style: GoogleFonts.poppins(
                                          fontSize: 22, // Set the font size
                                          fontWeight: FontWeight.bold, // Set the font weight
                                        ),
                                      )
                                    ],
                                  ),

                                  const Divider(thickness: 2,),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                              "Name",
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500
                                            ),
                                          ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                      userDoc['name'] ?? 'N/A',
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        flex: 8,
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              provider.showUsernameDialog(context);
                                            },
                                            child: Icon(
                                                Icons.arrow_forward_ios,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 26),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Email",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500
                                          ),
                                        ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                          userDoc['email'] ?? 'N/A',
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        flex: 8,
                                      ),
                                      Expanded(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey.shade400,
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 26),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Phone",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500
                                          ),
                                        ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                          userDoc['phone'] ?? 'N/A',
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        flex: 8,
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              provider.showPhoneDialog(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 26),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Description",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500
                                          ),
                                        ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              provider.showDescriptionDialog(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        flex: -1,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          userDoc['description'] ?? 'N/A',
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                          ),
                                        ),
                                        flex: 8,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }

                          return const Center(child: Text("No data available."));
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
        ),
      )
    );
  }
}
