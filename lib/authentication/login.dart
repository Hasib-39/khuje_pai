import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khuje_pai/authentication/forgot_password.dart';
import 'package:khuje_pai/views/home.dart';
import 'package:khuje_pai/authentication/auth.dart';
import 'package:khuje_pai/authentication/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email="", password = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "No User Found for that Email",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter'
                  ),
                )
            )
        );
      } else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "Wrong Password Provided by User",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter'
                  ),
                )
            )
        );
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
                  height: MediaQuery.of(context).size.height * 0.38,
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
                                color: const Color(0xffedf0f8),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: TextFormField(
                              controller: mailcontroller,
                              validator: (value){
                                if(value == null || value.isEmpty){
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
                                    fontFamily: 'Inter',

                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                            decoration: BoxDecoration(
                                color: const Color(0xffedf0f8),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: TextFormField(
                              controller: passwordcontroller,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please Enter Password';
                                }
                                return null;
                              },

                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xffb2b7bf),
                                    fontSize: 18,
                                    fontFamily: 'Inter'
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          GestureDetector(
                            onTap: (){
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  email= mailcontroller.text;
                                  password=passwordcontroller.text;
                                });
                              }
                              userLogin();
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
                                  "Sign In",
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
                      )
                  )
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword())
                  );
                },
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Color(0xFF8c8e98),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter'
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              const Text(
                "or Login with",
                style: TextStyle(
                    color: Color(0xff073727),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      AuthMethods().signInWithGoogle(context);
                    },
                    child: Image.asset(
                      "images/google.png",
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // const SizedBox(width: 30,),
                  // GestureDetector(
                  //   onTap: (){
                  //     // AuthMethods().signInWithFacebook();
                  //   },
                  //   child: Image.asset(
                  //     "images/apple.png",
                  //     height: 50,
                  //     width: 50,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
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
                          MaterialPageRoute(builder: (context) => const Signup())
                      );
                    },
                    child: const Text(
                      "SignUp",
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