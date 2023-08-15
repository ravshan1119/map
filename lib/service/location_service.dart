import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../utils/constants/constants.dart';
Set<Marker> markers = {};


initLocationService() async {
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

  locationData = await location.getLocation();

  debugPrint("LONGITUDE:${locationData.longitude} AND LAT:${locationData.longitude}");

  location.enableBackgroundMode(enable: true);

  location.onLocationChanged.listen((LocationData newLocation) async{
    Uint8List uint8list = await getBytesFromAsset("assets/person.png", 150);
    markers.add(Marker(
        markerId: MarkerId(
          DateTime.now().toString(),
        ),
        position: LatLng(newLocation.latitude!, newLocation.longitude!),
        icon: BitmapDescriptor.fromBytes(uint8list),
        //BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
            title: "Samarqand", snippet: "Falonchi Ko'chasi 45-uy ")));
    // setState(() {});

    debugPrint("LONGITUDE:${newLocation.longitude}");
  });



}

