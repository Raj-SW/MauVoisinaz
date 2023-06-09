// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart' as fl_back;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mauvoisinaz/Services/DistressSystem/DistressSystem.dart';
import 'package:mauvoisinaz/Services/DistressSystem/Notificationservices.dart';
import 'package:mauvoisinaz/Services/Maps/MapServices.dart';
import 'package:shake/shake.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => HeatMapState();
}

class HeatMapState extends State<HeatMap> {
  MapServices mapServices = MapServices();
  DistressSystem distress = DistressSystem();
//Distress System variables
  bool distressBool = false;
  String name = "";

//Google Map Variables
  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(-20.245555, 57.473308),
    zoom: 16,
  );
  late GoogleMapController googleMapController;
  double zoom = 16;
  late String lat;
  late String long;

  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 100,
  );

//Search places variables
  final Mode _mode = Mode.overlay;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

//Google Map Overlay variables
  List<Circle> manyCircles = [];
  List<Marker> manyMarkers = [];

// Init Function
  @override
  void initState() {
    //Background Service Initialize
    backgroundinit();

    //Shake detector
    // ShakeDetector shakeDetector = ShakeDetector.autoStart(
    //     onPhoneShake: () {
    //       print('shake detected');
    //       // Do stuff on phone shake
    //       ScaffoldMessenger.of(context)
    //           .showSnackBar(const SnackBar(content: Text("Shake Detected")));
    //       dispose();
    //     },
    //     minimumShakeCount: 3,
    //     shakeSlopTimeMS: 500,
    //     shakeCountResetTime: 3000,
    //     shakeThresholdGravity: 2.7);
    //Notification Initialization
    NotificationServices().initNotification();
    super.initState();

    //Listen to user details db
    final doc = FirebaseFirestore.instance
        .collection('collection2')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyCoordinates')
        .doc('MyCoords')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        distressBool = snapshot['Distress'];
        name = snapshot['UserName'];
      });
    });
    //listen to changes in UserGlobal
    final UserGlobal = FirebaseFirestore.instance
        .collection('UsersGlobal')
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        manyMarkers.clear();
      });
      for (var doc in querySnapshot.docs) {
        var name = doc.data()['name'];
        var isDistress = doc.data()['isDistress'];
        var lat = doc.data()['lat'];
        var lng = doc.data()['lng'];
        //var location = doc.data()['location'];
        if (isDistress == true) {
          print('name:123 $name');
          //broadcast message to every user
          NotificationServices().showSimpleBroadCast(name);
          setState(() {
            //add markers on the map
            manyMarkers.add(Marker(
                markerId: MarkerId("${manyMarkers.length}"),
                position: LatLng(lat, lng),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(title: '$name is unsafe at')));
          });
        }
      }
    });
    // fetch Locations and add to circles
    final locations = FirebaseFirestore.instance
        .collection('Location')
        .snapshots()
        .listen((locationSnapshot) {
      for (var location in locationSnapshot.docs) {
        var locName = location['id'];
        var xloc = location['x'];
        var yloc = location['y'];
        var incidents = location['abuse'] +
            location['accident'] +
            location['assault'] +
            location['death'] +
            location['drugs'] +
            location['larceny'] +
            location['miscellaneous'] +
            location['murder'] +
            location['sexual assault'] +
            location['unrest'];
        setState(() {
          manyCircles.add(Circle(
              radius: 500 * 2,
              visible: true,
              circleId: CircleId("${manyCircles.length + 1}"),
              strokeColor: Colors.red.shade300,
              strokeWidth: 2,
              fillColor: incidents < 20
                  ? Color.fromARGB(116, 179, 239, 154)
                  : incidents < 50
                      ? Color.fromARGB(121, 239, 239, 154)
                      : Color.fromARGB(134, 239, 154, 154),
              center: LatLng(xloc, yloc)));
        });
      }
    });
  }

//on click event
  void onClickedNotifications(String? payload) {}

//Widget Start
  @override
  Widget build(BuildContext context) {
    AddMarker(String name, double lat, doublelng) {}
    return Scaffold(
      key: homeScaffoldKey,
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              circles: Set<Circle>.from(manyCircles),
              padding: EdgeInsets.all(25),
              compassEnabled: true,
              onCameraMove: (position) {},
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.satellite,
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              markers: Set<Marker>.from(manyMarkers),
              zoomControlsEnabled: false,
            ),
            //Search Maps Text Box UI
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                  onPressed: _handlePressButton, child: Text('SearchPlaces')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await mapServices.getPosition();
          distressBool = !distressBool;
          //if distress then
          if (distressBool) {
            //send to firebase
            distress.sendDistressToFirebase(position, distressBool, name);
            //Send distress message to friends
            //distress.sendDistressSMS();
          }
          //remove marker in case distress solved by updating firebase
          manyMarkers.remove("${manyMarkers.length}");
          FirebaseFirestore.instance
              .collection('UsersGlobal')
              .doc(name)
              .update({'isDistress': distressBool});
        },
        child: Icon(Icons.crisis_alert),
      ),
    );
  }

//Search Places
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyDFqzfgotg6784NLJ8Mh0l2whFoeI-UwDA",
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, 'mu')]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  onError(PlacesAutocompleteResponse reponse) {
    homeScaffoldKey.currentState!
        .showBottomSheet((context) => Text(reponse.errorMessage.toString()));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: 'AIzaSyDFqzfgotg6784NLJ8Mh0l2whFoeI-UwDA',
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse details =
        await places.getDetailsByPlaceId(p.placeId!);
    final lat = details.result.geometry!.location.lat;
    final long = details.result.geometry!.location.lng;
    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom));
  }

  Future<void> backgroundinit() async {
    final androidConfig = fl_back.FlutterBackgroundAndroidConfig(
        notificationTitle: "flutter_background example app",
        notificationText:
            "Background notification for keeping the example app running in the background",
        notificationImportance: fl_back.AndroidNotificationImportance.Default,
        notificationIcon: fl_back.AndroidResource(name: 'background_icon'),
        enableWifiLock: true,
        showBadge: true);
    var hasPermissions = await fl_back.FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      print('Does not have background service problem');
    }
    hasPermissions = await fl_back.FlutterBackground.initialize(
        androidConfig: androidConfig);
    if (hasPermissions) {
      if (hasPermissions) {
        final backgroundExecution =
            await fl_back.FlutterBackground.enableBackgroundExecution();
        if (backgroundExecution) {
          print('Background Service working');
          //Shake detector
          ShakeDetector shakeDetector = ShakeDetector.autoStart(
              onPhoneShake: () async {
                distressBool = true;
                Position currPos = await mapServices.getPosition();
                distress.sendDistressToFirebase(currPos, distressBool, name);
                distress.sendDistressSMS();
              },
              minimumShakeCount: 3,
              shakeSlopTimeMS: 500,
              shakeCountResetTime: 3000,
              shakeThresholdGravity: 2.7);
          //listen to firebase and receive broadcast
          final UserGlobal = FirebaseFirestore.instance
              .collection('UsersGlobal')
              .snapshots()
              .listen((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              var name = doc.data()['name'];
              var isDistress = doc.data()['isDistress'];
              if (isDistress == true) {
                //broadcast message to every user
                NotificationServices().showSimpleBroadCast(name);
              }
            }
          });
        }
      }
    }
  }
}
