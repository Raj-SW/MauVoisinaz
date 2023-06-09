// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  Future<bool> addUserDetails(String name, int counter) async {
    await FirebaseFirestore.instance
        .collection('collection1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'Name': name, 'Counter': counter});
    return true;
  }

  Future<String> getName() async {
    return FirebaseAuth.instance.currentUser!.displayName!;
  }

  Future<String> getEmail() async {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  updateUserCounter(int num, String uid) {
    FirebaseFirestore.instance
        .collection('collection1')
        .doc(uid)
        .update({'Counter': num});
  }

  Stream<QuerySnapshot> getFriends() {
    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Friends')
        .doc('myFriends')
        .collection('friendDetails')
        .snapshots();

    return stream;
  }

  void addFriends(String name, String number) {
    FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Friends')
        .doc('myFriends')
        .collection('friendDetails')
        .add({'Name': name, 'Number': number});
  }

  void removeFriends(String name) {
    FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Friends')
        .doc('myFriends')
        .collection('friendDetails')
        .where('Name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }
}
