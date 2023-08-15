import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  LocationProvider() {
    _getLocation();
  }

  LatLng? latLong;


  Future<void> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }


    try{
      locationData = await location.getLocation();
      latLong = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      debugPrint("SUCCESS ERROR:${latLong!.longitude}");
      notifyListeners();
    }catch(er){
      debugPrint("LOCATION ERROR:$er");
    }

    location.enableBackgroundMode(enable: true);

    location.onLocationChanged.listen((LocationData newLocation) {
      debugPrint("LONGITUDE:${newLocation.longitude}");
    });

  }

  updateLatLong(LatLng newLatLng) {
    latLong = newLatLng;
    notifyListeners();
  }


}
