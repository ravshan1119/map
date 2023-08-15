import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/utils/constants/constants.dart';

class OrderTrakingScreen extends StatefulWidget {
  const OrderTrakingScreen({super.key});

  @override
  State<OrderTrakingScreen> createState() => _OrderTrakingScreenState();
}

class _OrderTrakingScreenState extends State<OrderTrakingScreen> {
  List<LatLng> polylineCoordinates = [];
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 15),
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.tealAccent
          )
        },
        markers: {
          const Marker(
            markerId: MarkerId("course"),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
      ),
    );
  }
}
