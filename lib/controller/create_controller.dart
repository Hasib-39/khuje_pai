

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateController with ChangeNotifier{
  final picker = ImagePicker();
  String? caption;
  String? location;
  File? _image;
  File? get image => _image;
  String imageURL = "";

  Future pickGalleryImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      // uploadImage(_image!);
      notifyListeners();
    }
  }
  Future pickCameraImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      // uploadImage(_image!);
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
                // changeData(imageURL, "imgUrl");
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  Future<void> addPost(String userID) async {
    if(caption == null || location == null || imageURL == ""){
      throw Exception("All fields are required");
    }

    try{
      await FirebaseFirestore.instance.collection("Post").add({
        'user_id': userID,
        'caption' : caption,
        'location' : location,
        'imgUrl' : imageURL,
        'createdAt': FieldValue.serverTimestamp()
      });
      notifyListeners();
    } catch(e){
      print("Error adding post: $e");
      throw e;
    }
  }
}