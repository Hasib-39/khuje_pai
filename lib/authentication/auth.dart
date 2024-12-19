import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khuje_pai/user_model.dart';

import '../components/app.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Ensure sign-out before initiating a new login
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // User canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    try {
      UserCredential result = await firebaseAuth.signInWithCredential(credential);

      User? userDetails = result.user;

      if (userDetails != null) {
        // Check if the user already exists in the Firestore database
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("User")
            .doc(userDetails.uid)
            .get();

        if (userDoc.exists) {
          // User already exists, navigate to the app
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const App()));
        } else {
          // Create a new user entry if not exists
          UserModel userModel = UserModel(
            email: userDetails.email?.trim(),
            name: userDetails.displayName?.trim(),
            imgUrl: userDetails.photoURL ?? "",
            description: "",
            phone: "",
            id: userDetails.uid,
          );

          await FirebaseFirestore.instance
              .collection("User")
              .doc(userDetails.uid)
              .set(userModel.toJson());

          // Navigate to the app
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const App()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error during Google Sign-In: $e")));
      // Show error message to the user if needed
    }
  }

}
