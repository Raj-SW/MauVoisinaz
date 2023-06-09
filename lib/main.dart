// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mauvoisinaz/Services/DistressSystem/NotificationServices.dart';
import 'package:mauvoisinaz/UI/AuthenticationPages/LoginController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().initNotification();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MauVoisinaz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const LoginController(),
    );
  }
}
