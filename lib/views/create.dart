import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khuje_pai/controller/create_controller.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            fontSize: 25, // Set the font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: ChangeNotifierProvider(
        create: (_) => CreateController(),
        child: Consumer<CreateController>(
          builder: (context, provider, child){
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child:GestureDetector(
                  onTap: (){
                    provider.pickImage(context);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xffff9d14),
                        borderRadius: BorderRadius.circular(20)// Makes the container circular
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
