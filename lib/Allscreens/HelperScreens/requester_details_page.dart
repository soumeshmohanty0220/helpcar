// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequesterDetailsPage extends StatefulWidget {
  @override
  State<RequesterDetailsPage> createState() => _RequesterDetailsPageState();
}

class _RequesterDetailsPageState extends State<RequesterDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> deleteID() async {
    final User? user = _auth.currentUser;

    dynamic helperID;
    try {
      var event =
          await _database.child('users').child(user!.uid).child('ID').once();
      if (event.snapshot.value != null) {
        helperID = event.snapshot.value;
      }
    } catch (error) {
      print('Error retrieving data: $error');
    }

    _database.child('users').child(user!.uid).child('ID').remove();
    _database.child('users').child(user!.uid).child('paths').remove();

    _database
        .child('users')
        .child(helperID['requesterID'])
        .child('ID')
        .remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requester Details'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter contact',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: const GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(37.4219999, -122.0840575), // Set initial location
                  zoom: 15,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Ride Complete'),
                      content: const Text('Are you sure, ride is completed ?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {
                            Navigator.pop(context),
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => {
                            deleteID(),
                            Navigator.pop(context),
                            Navigator.pop(context),
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                ),
                child: Text(
                  "Ride Completed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
