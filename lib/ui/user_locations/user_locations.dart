import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/data/model/user_address.dart';
import 'package:map/providers/address_call_provider.dart';
import 'package:map/providers/location_provider.dart';
import 'package:map/providers/tab_box_provider.dart';
import 'package:map/providers/user_locations_provider.dart';
import 'package:map/ui/update/update_screen.dart';
import 'package:provider/provider.dart';

class UserLocationsScreen extends StatefulWidget {
  const UserLocationsScreen({super.key});

  @override
  State<UserLocationsScreen> createState() => _UserLocationsScreenState();
}

class _UserLocationsScreenState extends State<UserLocationsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    List<UserAddress> userAddresses =
        Provider.of<UserLocationsProvider>(context).addresses;
    return Scaffold(
        appBar: AppBar(title: const Text("User Locations Screen")),
        body: ListView(
          children: [
            if (userAddresses.isEmpty) const Text("EMPTY!!!"),
            ...List.generate(userAddresses.length, (index) {
              UserAddress userAddress = userAddresses[index];
              return Slidable(
                  startActionPane:
                      ActionPane(
                          motion: const BehindMotion(), children: [
                    SlidableAction(
                        onPressed: (context) {
                      context
                          .read<UserLocationsProvider>()
                          .deleteUserAddress(userAddress.id!);
                    },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      label: "delete",
                    ),
                    SlidableAction(
                        onPressed: (context) {
                          CameraPosition cameraPosition = CameraPosition(
                              target: LatLng(userAddress.lat, userAddress.long));
                          _followMeUserLocations(cameraPosition: cameraPosition);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpdateMapScreen()));
                          context.read<AddressCallProvider>().getAddressByLatLong(
                              latLng: LatLng(userAddress.lat, userAddress.long));

                          context.read<LocationProvider>().updateLatLong(
                              LatLng(userAddress.lat, userAddress.long));
                    },
                      icon: Icons.update,
                      backgroundColor: Colors.green,
                      label: "update",
                    )
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      shape: Border.all(width: 2,color: Colors.blue),
                      onTap: () {

                      },
                      title: Text(userAddress.address),
                      subtitle: Text(
                          "Lat: ${userAddress.lat} and Longt:${userAddress.long}"),
                    ),
                  ));
            })
          ],
        ));
  }

  Future<void> _followMeUserLocations(
      {required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}
