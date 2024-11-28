

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khuje_pai/user_model.dart';
import 'package:khuje_pai/views/home.dart';
import 'package:khuje_pai/authentication/database.dart';

import '../components/app.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle (BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn  googleSignIn = GoogleSignIn();

    final GoogleSignInAccount?  googleSignInAccount =
    await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if(result != null){
      UserModel userModel = UserModel(
          email: userDetails?.email?.trim(),
          name: userDetails?.displayName?.trim(),
          imgUrl: userDetails?.photoURL ?? "",
          description: "",
          phone: "",
          id: userDetails?.uid
      );
      await DatabaseMethods().addUser(userDetails!.uid, userModel.toJson()).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const App()));
      });
    }
  }

}