import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateController with ChangeNotifier {
  final picker = ImagePicker();
  String? caption;
  String? location;
  File? _image;
  File? get image => _image;
  String imageURL = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Method to download image from URL and set it to _image
  Future<void> setImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/image.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        _image = file;
        imageURL = url;
        notifyListeners();
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> pickGalleryImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> pickCameraImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  void pickImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera, color: Colors.black),
                  title: const Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.photo_library, color: Colors.black),
                  title: const Text("Gallery"),
                ),
                ListTile(
                  onTap: () {
                    _showURLInputDialog(context);
                  },
                  leading: const Icon(Icons.link, color: Colors.black),
                  title: const Text("Image URL"),
                  subtitle: Text(
                    imageURL.isNotEmpty ? "Link added" : "No URL provided",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                imageURL = urlController.text;
                setImageFromUrl(imageURL);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addPost(String userID) async {
    if (caption == null || location == null || imageURL.isEmpty) {
      throw Exception("All fields are required");
    }

    setLoading(true);
    try {
      String postId = FirebaseFirestore.instance.collection("Post").doc().id;

      await FirebaseFirestore.instance.collection("Post").doc(postId).set({
        'id': postId,
        'user_id': userID,
        'like_cnt': 0,
        'comment_cnt': 0,
        'share_cnt': 0,
        'caption': caption,
        'location': location,
        'imgUrl': imageURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding post: $e");
      throw e;
    } finally {
      setLoading(false);
    }
  }

  Future<void> uploadImage(File image) async {
    setLoading(true);
    try {
      String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
      var request = http.MultipartRequest("POST", uri);
      var fileBytes = await image.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: image.path.split("/").last,
      );

      request.files.add(multipartFile);
      request.fields['upload_preset'] = "preset-for-post-img-upload";
      request.fields['resource_type'] = "raw";
      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      String imgUrl = jsonResponse["secure_url"];

      if (response.statusCode == 200) {
        print("Uploaded successfully");
        imageURL = imgUrl;
      } else {
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    } finally {
      setLoading(false);
    }
  }
}
