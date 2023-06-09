// ignore_for_file: avoid_print

import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mauvoisinaz/Services/Maps/MapServices.dart';
import 'package:permission_handler/permission_handler.dart';

class DistressSystem {
  //change firebase
  //send distress coordiates
  Future<void> sendDistressToFirebase(
      Position position, bool distressBool, String name) async {
    await FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyCoordinates')
        .doc('MyCoords')
        .set({
      'UserName': name,
      'Distress': distressBool,
      'Latitude': position.latitude,
      'Longituted': position.longitude
    });
    print('User global Name $name Distress: $distressBool position $position');
    await FirebaseFirestore.instance
        .collection('UsersGlobal')
        .doc(name)
        .update({
      'lat': position.latitude,
      'lng': position.longitude,
      'isDistress': distressBool,
      'name': name
    });
  }

  void sendDistressSMS() async {
    Position currentPosition = await MapServices().getPosition();
    String message =
        "I am in trouble!!   https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude},${currentPosition.longitude}";

    final snapshots = FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Friends')
        .doc('myFriends')
        .collection('friendDetails')
        .snapshots()
        .listen((snapshot) async {
      var docs = snapshot.docs;
      for (var d in docs) {
        var a = d.data();
        var num = a['Number'];
        _getPermission() async => await [
              Permission.sms,
            ].request();
        Future<bool> _isPermissionGranted() async =>
            await Permission.sms.status.isGranted;
        var result = (await BackgroundSms.sendMessage(
            phoneNumber: num, message: message, simSlot: 1));
        if (result == SmsStatus.sent) {
          print("Background SMS Sent");
        } else {
          print("Background SMS Failed");
        }
      }
    });
  }
}
