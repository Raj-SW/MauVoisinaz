// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:mauvoisinaz/UI/Navigation/Controller.dart';

import 'LoginPage.dart';
import 'SignUpPage.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Mauvoisinaz',
        ),
      ),
      body: Center(
        child: Column(children: [
          Text('Welcome to MauVoisinaz App'),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Login')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text('Create New Account')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Controller()));
              },
              child: Text('Login by others..')),
        ]),
      ),
    );
  }
}
