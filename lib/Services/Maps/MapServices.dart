import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  static const String kGoogleAPIKey = 'AIzaSyDFqzfgotg6784NLJ8Mh0l2whFoeI-UwDA';
// Getting Location using Geolocator dependency
  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location Services are disabled');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permissions are denied permanently');
    }

    Position position =
        await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);

    return position;
  }

  void onCameraMove(CameraPosition position) {
    print(position);
  }
}
