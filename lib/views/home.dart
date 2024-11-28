import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khuje_pai/components/app.dart';
import 'package:khuje_pai/user_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("User").where("id", isEqualTo: user?.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data?.docs[index]['name']),
                        ),
                      );
                    }
                );
              }

              return Container();
            }
        ),
      )
    );
  }
}