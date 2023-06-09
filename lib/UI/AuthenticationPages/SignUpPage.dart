// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauvoisinaz/Services/Authentication/UserAuthentication.dart';
import 'package:mauvoisinaz/Services/DBConnection/UserDetails.dart';
import 'package:mauvoisinaz/UI/AuthenticationPages/LoginController.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //text controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  UserAuthentication userAuthentication = UserAuthentication();
  UserDetails userDetails = UserDetails();
  late String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name'),
                TextField(
                  controller: nameController,
                ),
                Text('Email'),
                TextField(
                  controller: emailController,
                ),
                Text('Password'),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (await userAuthentication.signUp(
                            emailController.text.trim(),
                            passwordController.text.trim())) {
                          //create user document in DB with name and counter
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user == null) {
                              print('User is not logged in yet');
                            } else {
                              userDetails.addUserDetails(
                                  nameController.text, 0);
                            }
                          });
                          await FirebaseFirestore.instance
                              .collection(
                                  FirebaseAuth.instance.currentUser!.uid)
                              .doc('MyCoordinates')
                              .collection('MyCoords')
                              .doc()
                              .set({'UserName': nameController.text});
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginController()),
                              (route) => false);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text('SignUp')),
              ]),
        ),
      ),
    );
  }
}
