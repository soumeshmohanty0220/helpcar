// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpcar/RequestScreens/requesterPickUp.dart';

class RequesterRideDetails extends StatefulWidget {
  @override
  _RequesterRideDetailsState createState() => _RequesterRideDetailsState();
}

class _RequesterRideDetailsState extends State<RequesterRideDetails> {
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  GoogleMapController? _controller;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default location: San Francisco
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {},
              markers: {
                Marker(
                  markerId: MarkerId('Current Location'),
                  position: LatLng(37.7749, -122.4194),
                ),
                Marker(
                  markerId: MarkerId('Destination'),
                  position: LatLng(37.7749, -122.4312),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('Route'),
                  color: Colors.blue,
                  points: [
                    LatLng(37.7749, -122.4194),
                    LatLng(37.7749, -122.4312),
                  ],
                ),
              },
            ),
          ),
          Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _currentLocationController,
                  decoration: InputDecoration(
                    hintText: "PickUp Location",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: "Destination",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                width: double.infinity,
                height: 70,
                margin: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequesterPickUpScreen()));
                  },
                  child: Text(
                    "HelpCar",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 221, 46, 69),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}