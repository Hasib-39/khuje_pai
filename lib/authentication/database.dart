import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUser(String userId, Map<String, dynamic>  userInfoMap) async {
    return await FirebaseFirestore.instance.collection("User").add(userInfoMap);
  }
}