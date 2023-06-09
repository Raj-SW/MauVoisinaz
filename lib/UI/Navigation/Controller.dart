// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, file_names
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mauvoisinaz/Services/Authentication/UserAuthentication.dart';
import 'package:mauvoisinaz/Services/DBConnection/UserDetails.dart';
import 'package:mauvoisinaz/UI/MainPage/HeatMapPage.dart';
import 'package:mauvoisinaz/UI/MainPage/SettingsPage.dart';
import 'package:mauvoisinaz/UI/MainPage/StoryPage.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  UserAuthentication UserAuth = UserAuthentication();
  UserDetails userDetails = UserDetails();
  int counter = 0;
  int currentIndex = 0;
  List<Widget> Screen = [HeatMap(), StoryPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      body: Screen[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          color: Colors.blueAccent[200],
        ),
        child: GNav(
          padding: EdgeInsets.all(12),
          tabMargin: EdgeInsets.all(5),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          style: GnavStyle.google,
          backgroundColor: Colors.transparent,
          tabBackgroundColor: Colors.white24,
          gap: 8,
          activeColor: Colors.white,
          tabs: [
            GButton(icon: Icons.map, text: 'Near Me'),
            GButton(
              icon: Icons.map,
              text: 'Story',
            ),
            GButton(
              icon: Icons.map,
              text: 'Setting',
            )
          ],
          onTabChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
