// ignore_for_file: file_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication {
  //Signing In a User
  Future<bool> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Creating a new User
  Future<bool> signUp(String email, String password) async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      signIn(email, password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Signing Out a User
  Future<bool> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Signing in by Google Auth Provider
  Future<void> googleSignIn() async {}
}
