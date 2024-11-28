import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier{
  CollectionReference ref = FirebaseFirestore.instance.collection('User');
  User? user = FirebaseAuth.instance.currentUser;

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;
  String imageURL = "";

  Future pickGalleryImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedFile != null){
      _image = XFile(pickedFile.path);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(pickedFile != null){
      _image = XFile(pickedFile.path);
      notifyListeners();
    }
  }


  void pickImage(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera, color: Colors.black,),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: (){
                      pickGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.photo_library, color: Colors.black,),
                    title: Text("Gallery"),
                  ),
                  ListTile(
                    onTap: (){
                      _showURLInputDialog(context);
                    },
                    leading: Icon(Icons.link, color: Colors.black,),
                    title: Text("Image URL"),
                    subtitle: Text(imageURL.isNotEmpty? "Link added":"No URL provided",
                    style: const TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
  void _showURLInputDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Image URL"),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Paste your image URL here",
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                  imageURL = urlController.text;
                  changeImageUrl(imageURL);// Save input to the variable
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void changeImageUrl(String newImageUrl) async {
    try {
      // Fetch the user document
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: user?.uid) // Assuming "id" is the user's unique identifier
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the first document
        var userDoc = snapshot.docs.first;

        // Update the image URL
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userDoc.id) // Use the document ID to perform the update
            .update({"imgUrl": newImageUrl});

        debugPrint("Image URL updated successfully!");
      } else {
        debugPrint("No user document found.");
      }
    } catch (e) {
      debugPrint("Error updating image URL: $e");
    }
  }

  void uploadImage(){

  }
}