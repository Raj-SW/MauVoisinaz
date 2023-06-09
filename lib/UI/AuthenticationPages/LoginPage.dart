// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:mauvoisinaz/Services/Authentication/UserAuthentication.dart';
import 'package:mauvoisinaz/UI/Navigation/Controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserAuthentication userAuthentication = UserAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      if (await userAuthentication.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim())) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Controller()),
                            (route) => false);
                      } else {
                        print("no credentials");
                      }
                    },
                    child: Text('Login')),
              ]),
        ),
      ),
    );
  }
}
