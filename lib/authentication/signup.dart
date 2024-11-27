import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khuje_pai/views/home.dart';
import 'package:khuje_pai/authentication/login.dart';

import '../components/app.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if(password != "" && namecontroller.text != "" && mailcontroller.text!=""){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
              "Registered Successfully",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter'
              ),
            )
            ));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const App()));
      } on FirebaseAuthException catch(e){
        if(e.code == 'weak-pasword'){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                    "Password is too weak. Try Again!",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter'
                    ),
                  )
              ));
        } else if(e.code == "email-already-in-use"){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.orangeAccent,
                  content: Text(
                    "Account Already Exist",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18
                    ),
                  )
              )
          );
        } else if(e.toString().contains('Password should be at least 8 characters')){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                "Password should be at least 8 characters",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18
                ),
              ))
          );
        } else if(e.toString().contains('Password must contain an upper case character')){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                "Password must contain an upper case character",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18
                ),
              ))
          );
        } else if(e.toString().contains('Password must contain a numeric character')){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                "Password must contain a numeric character",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18
                ),
              ))
          );
        } else if(e.toString().contains('Password must contain a non-alphanumeric character')){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                "Password must contain a special character",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18
                ),
              ))
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/nature.png",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: TextFormField(
                          controller: namecontroller,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Color(0xffb2b7bf),
                                  fontSize: 18,
                                  fontFamily: 'Inter'
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: TextFormField(
                          controller: mailcontroller,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Color(0xffb2b7bf),
                                  fontSize: 18,
                                  fontFamily: 'Inter'
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: TextFormField(
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          controller: passwordcontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color(0xffb2b7bf),
                                  fontSize: 18,
                                  fontFamily: 'Inter'
                              )
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              email = mailcontroller.text;
                              name = namecontroller.text;
                              password = passwordcontroller.text;
                            });
                          }
                          registration();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                          decoration: BoxDecoration(
                              color: const Color(0xff073727),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35,),
              const Text(
                "or Login with",
                style: TextStyle(
                    color: Color(0xff073727),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'
                ),
              ),
              const SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/google.png",
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                  // const SizedBox(width: 30,),
                  // Image.asset(
                  //   "images/apple.png",
                  //   width: 50,
                  //   height: 50,
                  //   fit: BoxFit.cover,
                  // )
                ],
              ),
              const SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: Color(0xff8c8e98),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter'
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Login())
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xff073727),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}