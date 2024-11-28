import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Profile'),
      ),
      body: Stack(
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
                          Container(
                            width: 70, // Size of the image (matching CircleAvatar's radius * 2)
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Set shape to rectangle
                              // 50% border radius makes it circular
                              image: DecorationImage(
                                image: userDoc['imgUrl'] == "" ? AssetImage("images/default_profile.png") : NetworkImage(userDoc['imgUrl']),
                                fit: BoxFit.contain, // Ensures the image is contained within the box
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Displaying user fields in a list manner
                          ListTile(
                            title: const Text("Name"),
                            subtitle: Text(userDoc['name'] ?? 'N/A'),
                          ),
                          ListTile(
                            title: const Text("Email"),
                            subtitle: Text(userDoc['email'] ?? 'N/A'),
                          ),
                          ListTile(
                            title: const Text("Phone"),
                            subtitle: Text(userDoc['phone'] ?? 'N/A'),
                          ),
                          ListTile(
                            title: const Text("Description"),
                            subtitle: Text(userDoc['description'] ?? 'N/A'),
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
      ),
    );
  }
}
