// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpcar/main.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:firebase_database/firebase_database.dart';

class requesterHelperDetails extends StatefulWidget {
  const requesterHelperDetails({super.key});

  @override
  State<requesterHelperDetails> createState() => _requesterHelperDetailsState();
}

class _requesterHelperDetailsState extends State<requesterHelperDetails> {
  bool hasRiderMatched = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        hasRiderMatched = true;
      });
    });
    _performPathCalculation(context);
  }

  Future<void> _performPathCalculation(BuildContext context) async {
    // Get user input locations
    LatLng startLatLng = LatLng(
      Provider.of<AppData>(context, listen: false).userPickUpLocation!.latitude,
      Provider.of<AppData>(context, listen: false)
          .userPickUpLocation!
          .longitude,
    );
    LatLng destinationLatLng = LatLng(
      Provider.of<AppData>(context, listen: false).dropOfflocation!.latitude,
      Provider.of<AppData>(context, listen: false).dropOfflocation!.longitude,
    );

// Get all the paths from the database
    DatabaseReference pathsRef =
        FirebaseDatabase.instance.reference().child('users');
    DatabaseEvent event = await pathsRef.once();
    DataSnapshot snapshot = event.snapshot;
    print(snapshot.value);
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

      // Iterate over all the paths and check if it contains the user's input locations
      values.forEach((key, value) {
        Map<dynamic, dynamic> userData = value;
        if (userData['paths'] != null) {
          Map<dynamic, dynamic> path = userData['paths'];
          LatLng pathStartLatLng =
              LatLng(path['currentLatitude'], path['currentLongitude']);
          LatLng pathDestinationLatLng =
              LatLng(path['destinationLatitude'], path['destinationLongitude']);
              
          // Perform ray casting algorithm to check if the user's input locations are on the path
          if (crossProductAlgorithm(pathStartLatLng, pathDestinationLatLng,
              startLatLng, destinationLatLng)) {
            String userName = userData['name'];
            String userPhoneNumber = userData['phone'];
            
            // Display the user's name and phone number
            print("User Name: $userName");
            print("User Phone Number: $userPhoneNumber");
          }
          else{
            print("No match");
          }
        }
      });
    }
  }

  // Cross product algorithm to check if the user's input locations are on the path
  bool crossProductAlgorithm(LatLng pathStartLatLng,
      LatLng pathDestinationLatLng, LatLng startLatLng, LatLng destinationLatLng) {
    double x1 = pathStartLatLng.latitude;
    double y1 = pathStartLatLng.longitude;
    double x2 = pathDestinationLatLng.latitude;
    double y2 = pathDestinationLatLng.longitude;
    double x3 = startLatLng.latitude;
    double y3 = startLatLng.longitude;
    double x4 = destinationLatLng.latitude;
    double y4 = destinationLatLng.longitude;

    double d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (d == 0) {
      return false;
    }

    double pre = (x1 * y2 - y1 * x2), post = (x3 * y4 - y3 * x4);
    double x = (pre * (x3 - x4) - (x1 - x2) * post) / d;
    double y = (pre * (y3 - y4) - (y1 - y2) * post) / d;

    if (x < min(x1, x2) || x > max(x1, x2) || x < min(x3, x4) || x > max(x3, x4)) {
      return false;
    }
    if (y < min(y1, y2) || y > max(y1, y2) || y < min(y3, y4) || y > max(y3, y4)) {
      return false;
    }
    return true;
  }

  //Define min and max functions
  double min(double a, double b) {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  double max(double a, double b) {
    if (a > b) {
      return a;
    } else {
      return b;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasClicked = false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 0, 224, 206),
        toolbarHeight: 250,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (hasRiderMatched)
                          ? Text(
                              "RIDE",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0,
                              ),
                            )
                          : AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                RotateAnimatedText(
                                  'HELPER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                RotateAnimatedText(
                                  'RIDER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                RotateAnimatedText(
                                  'DRIVER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "is On the Way",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
          ],
        ),
      ),
      body: (hasRiderMatched)
          ? Column(
              children: [
                helpDetailsWidget(),
                ElevatedButton(
                  onPressed: hasClicked
                      ? null
                      : () {
                          setState(() {
                            hasClicked = true;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasClicked
                        ? Color.fromARGB(31, 138, 138, 138)
                        : Color.fromARGB(255, 247, 224, 24),
                  ),
                  child: Text(
                    "HELPER ARRIVED",
                  ),
                )
              ],
            )
          : Center(child: Lottie.asset('images/117478-delivery.json')),
    );
  }

  Widget helpDetailsWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Colors.blue,
            size: 120.0,
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Text(
                "Suman Sahoo",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "+91 8144498292",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(151, 18, 75, 25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
