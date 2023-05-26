// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequesterDetailsPage extends StatefulWidget {
  @override
  State<RequesterDetailsPage> createState() => _RequesterDetailsPageState();
}

class _RequesterDetailsPageState extends State<RequesterDetailsPage> {
  var nameController = TextEditingController();
  var contactController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> deleteID() async {
    final User? user = _auth.currentUser;

    dynamic requesterID;
    try {
      var event =
          await _database.child('users').child(user!.uid).child('ID').once();
      if (event.snapshot.value != null) {
        requesterID = event.snapshot.value;
      }
    } catch (error) {
      print('Error retrieving data: $error');
    }




    //user.uid is helper id and requesterID is requester id 
    //what I have to check here is if the user.id current location is equal to a field "destination" in requesterID
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // if ( position.latitude == 50 && position.longitude == 50 ){

    // }

    _database.child('users').child(user!.uid).child('ID').remove();
    _database.child('users').child(user!.uid).child('paths').remove();

    _database
        .child('users')
        .child(requesterID['requesterID'])
        .child('ID')
        .remove();
  }

  @override
  void initState() {
    // TODO: implement initState
    // provideDetails();
    super.initState();
  }

  // Future<void> provideDetails() async {
  //   final User? user = _auth.currentUser;
  //   dynamic requesterID;
  //   try {
  //     var event =
  //         await _database.child('users').child(user!.uid).child('ID').once();
  //     if (event.snapshot.value != null) {
  //       requesterID = event.snapshot.value;
  //     }
  //   } catch (error) {
  //     print('Error retrieving data: $error');
  //   }

  //   DatabaseReference userRef = _database.child('users').child(requesterID);

  //   // Update data in realtime
  //   userRef.child('paths').onValue.listen((event) {
  //     final Map<dynamic, dynamic>? data =
  //         event.snapshot.value as Map<dynamic, dynamic>?;
  //     if (data != null) {
  //       // print("this data ${data}");
  //       setState(() {
  //         nameController = data['name'];
  //         contactController = data['phone'];
  //       });
  //     } else {
  //       print("data is null");
  //     }
  //   });
  // }

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
                    controller: nameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Helper 3',
                    ),
                  ),
                  // Text("Suman Sahoo"),
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
                    controller: contactController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '8658820377',
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

                            //check if the curr location of helper equal to destination location of requester

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
