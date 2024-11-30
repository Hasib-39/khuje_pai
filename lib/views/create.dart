import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khuje_pai/controller/create_controller.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateController(), // Provide a single instance
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            'Create Post',
            style: GoogleFonts.poppins(
              fontSize: 25, // Set the font size
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Consumer<CreateController>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () async {
                    try {
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null || provider.image == null) {
                        await provider.uploadImage(provider.image!);
                        await provider.addPost(userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Post added successfully!")),
                        );
                      } else {
                        throw Exception("User not authenticated.");
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add post: $e")),
                      );
                    }
                  },
                  icon: const Icon(Icons.send, size: 30, color: Color(0xffff9d14)), // Use your desired icon
                );
              },
            ),
          ],
        ),
        floatingActionButton: Consumer<CreateController>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  provider.pickImage(context);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xffff9d14),
                    borderRadius: BorderRadius.circular(20), // Rounded edges
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Consumer<CreateController>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Caption Input
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Add a Caption...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onChanged: (value) {
                            provider.caption = value; // Update the caption in the provider
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Add Location...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onChanged: (value) {
                            provider.location = value; // Update the location in the provider
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 400,
                          height: 400,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 4,
                              color: Colors.black,
                            ),
                            image: provider.image == null
                                ? const DecorationImage(
                              image: AssetImage("images/default_create.jpg"),
                              fit: BoxFit.contain,
                            )
                                : DecorationImage(
                              image: FileImage(File(provider.image!.path).absolute),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
