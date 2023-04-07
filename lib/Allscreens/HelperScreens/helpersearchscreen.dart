// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CurrentPathPage extends StatefulWidget {
  const CurrentPathPage({Key? key}) : super(key: key);

  @override
  _CurrentPathPageState createState() => _CurrentPathPageState();
}

class _CurrentPathPageState extends State<CurrentPathPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Future<void> _savePath() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // If the user is not logged in, do not save the path.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save the path')),
      );
      return;
    }

    String currentLocation = currentLocationController.text.trim();
    String destination = destinationController.text.trim();
    String time = timeController.text.trim();

    if (currentLocation.isEmpty || destination.isEmpty || time.isEmpty) {
      // show an error message if any of the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      // get the current position using Geolocator package
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double currentLat = currentPosition.latitude;
      double currentLong = currentPosition.longitude;

      // get the position of the destination location using Geolocator package
      List<Location> locations = await locationFromAddress(destination);
      double destinationLat = locations[0].latitude;
      double destinationLong = locations[0].longitude;

      // save the path to Firebase Realtime Database
      _database.child('users').child(user.uid).child('paths').set({
        'currentLocation': currentLocation,
        'destination': destination,
        'time': time,
        'currentLatitude': currentLat,
        'currentLongitude': currentLong,
        'destinationLatitude': destinationLat,
        'destinationLongitude': destinationLong,
      });

      // show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Path added successfully')),
      );

      // clear the text fields
      currentLocationController.clear();
      destinationController.clear();
      timeController.clear();
    } catch (e) {
      print(e);
      // show an error message if any error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding path')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Path'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: currentLocationController,
              decoration: const InputDecoration(
                labelText: 'Current location',
                hintText: 'Enter your current location',
                icon: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'Enter your destination location',
                icon: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time of leaving (hh:mm)',
                icon: Icon(
                  Icons.lock_clock,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                // show a time picker when the user taps on the time field
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  timeController.text = DateFormat('HH:mm').format(DateTime(
                    0,
                    0,
                    0,
                    selectedTime.hour,
                    selectedTime.minute,
                  ));
                }
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _savePath,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}