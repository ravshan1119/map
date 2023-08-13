import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/data/model/user_address.dart';
import 'package:map/providers/address_call_provider.dart';
import 'package:map/providers/location_provider.dart';
import 'package:map/providers/user_locations_provider.dart';
import 'package:map/ui/map/widgets/address_kind_selector.dart';
import 'package:map/ui/map/widgets/address_lang_selector.dart';
import 'package:map/ui/map/widgets/save_button.dart';
import 'package:provider/provider.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialCameraPosition;
  late CameraPosition currentCameraPosition;
  bool onCameraMoveStarted = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    initialCameraPosition = CameraPosition(
      target: locationProvider.latLong!,
      zoom: 13,
    );

    currentCameraPosition = CameraPosition(
      target: locationProvider.latLong!,
      zoom: 13,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen"),
        actions: const [
          AddressKindSelector(),
          AddressLangSelector()

        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (CameraPosition cameraPosition) {
              currentCameraPosition = cameraPosition;
            },
            onCameraIdle: () {
              debugPrint(
                  "CURRENT CAMERA POSITION: ${currentCameraPosition.target.latitude}");

              context
                  .read<AddressCallProvider>()
                  .getAddressByLatLong(latLng: currentCameraPosition.target);

              setState(() {
                onCameraMoveStarted = false;
              });

              debugPrint("MOVE FINISHED");
            },
            liteModeEnabled: false,
            myLocationEnabled: false,
            padding: const EdgeInsets.all(16),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.terrain,
            onCameraMoveStarted: () {
              setState(() {
                onCameraMoveStarted = true;
              });
              debugPrint("MOVE STARTED");
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: initialCameraPosition,
          ),
          Align(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: onCameraMoveStarted ? 50 : 32,
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: Center(
                  child: Text(
                    context.watch<AddressCallProvider>().scrolledAddressText,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: context.watch<AddressCallProvider>().canSaveAddress(),
              child: SaveButton(onTap: () {
                AddressCallProvider adp =
                    Provider.of<AddressCallProvider>(context, listen: false);
                context.read<UserLocationsProvider>().insertUserAddress(
                      UserAddress(
                        lat: currentCameraPosition.target.latitude,
                        long: currentCameraPosition.target.longitude,
                        address: adp.scrolledAddressText,
                        created: DateTime.now().toString(),
                      ),
                    );
                const snackBar = SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Location Saqlandi!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _followMe(cameraPosition: initialCameraPosition);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  Future<void> _followMe({required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}
