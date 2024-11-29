import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileController with ChangeNotifier{
  CollectionReference ref = FirebaseFirestore.instance.collection('User');
  User? user = FirebaseAuth.instance.currentUser;

  final picker = ImagePicker();
  File? _image;
  File? get image => _image;
  String imageURL = "";
  String name = "";
  String phone = "";
  String description = "";
  
  Future pickGalleryImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      uploadImage(_image!);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      uploadImage(_image!);
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
                  changeData(imageURL, "imgUrl");// Save input to the variable
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void showUsernameDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Name"),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Name",
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
                name = urlController.text;
                changeData(name, "name");// Save input to the variable
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void showPhoneDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Phone No"),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Phone No",
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
                phone = urlController.text;
                changeData(phone, "phone");// Save input to the variable
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void showDescriptionDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Description"),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Description",
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
                description = urlController.text;
                changeData(description, "description");// Save input to the variable
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  void changeData(String value, String doc) async {
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
            .update({doc: value});

        debugPrint("Image URL updated successfully!");
      } else {
        debugPrint("No user document found.");
      }
    } catch (e) {
      debugPrint("Error updating image URL: $e");
    }
  }

  Future<void> uploadImage(File image) async {
    File? file = image;
    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
    var request = http.MultipartRequest("POST", uri);
    var fileBytes = await file.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: file.path.split("/").last,
    );

    request.files.add(multipartFile);
    request.fields['upload_preset'] = "preset-for-file-upload";
    request.fields['resource_type'] = "raw";
    var response = await request.send();

    var responseBody = await response.stream.bytesToString();
    print(responseBody);
    var jsonResponse = jsonDecode(responseBody);
    String imgUrl = jsonResponse["secure_url"];

    if(response.statusCode == 200){
      print("Uploaded succesfully");
      changeData(imgUrl, "imgUrl");
      return;
    }else{
      print("Uploaded failed with status: ${response.statusCode}");
      return;
    }
  }


}