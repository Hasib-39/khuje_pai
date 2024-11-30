import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khuje_pai/components/post.dart';
import 'package:khuje_pai/widget/post_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontSize: 25, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Post").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading posts!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Use a ListView.builder to ensure all posts are scrollable
            return ListView.builder(
              physics: const BouncingScrollPhysics(), // Adds smooth scrolling
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Parse the post data into a Post object
                Post post = Post.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return PostTile(post: post); // Use PostTile to display the post
              },
            );
          }

          // If no posts are available
          return const Center(
            child: Text(
              "No posts found!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
