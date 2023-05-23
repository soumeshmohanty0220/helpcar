// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, sort_child_properties_last
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:firebase_database/firebase_database.dart';

class requesterHelperDetails extends StatefulWidget {
  const requesterHelperDetails({super.key});
  final String userName = "";
  final String userPhoneNumber = "";

  @override
  State<requesterHelperDetails> createState() => _requesterHelperDetailsState();
}

class _requesterHelperDetailsState extends State<requesterHelperDetails> {
  bool hasRiderMatched = false;
  final double startLatitude = 37.7749;
  final double startLongitude = -122.4194;
  final double endLatitude = 34.0522;
  final double endLongitude = -118.2437;

  Set<Polyline> _polylines = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        hasRiderMatched = true;
      });
    });
    _performPathCalculation(context);
    _drawPolyline();
  }

  void _drawPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.black,
      jointType: JointType.round,
      width: 3,
      points: [
        LatLng(startLatitude, startLongitude),
        LatLng(endLatitude, endLongitude),
      ],
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  Future<Map<String, String>?> _performPathCalculation(
      BuildContext context) async {
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
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      // Iterate over all the paths and check if it contains the user's input locations
      for (var value in values.values) {
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
            var id = await getIdsByValue(values, value);
            final User? user = _auth.currentUser;
            print(id);
            _database.child('users').child(user!.uid).child('ID').set({
              'helperID': id,
            });
            _database.child('users').child(id).child('ID').set({
              'requesterID': user.uid,
            });
            String userName = userData['name'];
            String userPhoneNumber = userData['phone'];
            print('User name: $userName');
            print('User phone number: $userPhoneNumber');

            // Return the user's name and phone number in a Map
            return {
              'userName': userName,
              'userPhoneNumber': userPhoneNumber,
            };
          } else {
            print('No match found');
          }
        }
      }
    }

    // Return null if no match was found
    return null;
  }

  Future<String> getIdsByValue(
      Map<dynamic, dynamic> data, Map<dynamic, dynamic> value) async {
    for (var entry in data.entries) {
      dynamic id = entry.key;
      Map<dynamic, dynamic> entryValue = entry.value;

      if (entryValue.toString() == value.toString()) {
        return id.toString();
      }
    }

    return "";
  }

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
    _database.child('users').child(helperID['helperID']).child('ID').remove();
  }

  // Cross product algorithm to check if the user's input locations are on the path
  bool crossProductAlgorithm(
      LatLng pathStartLatLng,
      LatLng pathDestinationLatLng,
      LatLng startLatLng,
      LatLng destinationLatLng) {
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

    if (x < min(x1, x2) ||
        x > max(x1, x2) ||
        x < min(x3, x4) ||
        x > max(x3, x4)) {
      return false;
    }
    if (y < min(y1, y2) ||
        y > max(y1, y2) ||
        y < min(y3, y4) ||
        y > max(y3, y4)) {
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
      body: WillPopScope(
        onWillPop: () async {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Cancel Ride'),
              content: const Text('Are you sure to cancel the ride ?'),
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

          return false;
        },
        child: !hasRiderMatched
            ? Center(child: Lottie.asset('images/117478-delivery.json'))
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: FutureBuilder<Map<String, String>?>(
                        future: _performPathCalculation(context),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, String>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While the future is still running, display a loading indicator.
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            // Once the future is complete, check if it has an error or a result.
                            if (snapshot.hasError) {
                              // If there was an error, display an error message.
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              // If there is data, display the userName and userPhoneNumber.
                              String userName = snapshot.data!['userName']!;
                              String userPhoneNumber =
                                  snapshot.data!['userPhoneNumber']!;
                              return Container(
                                // height:100,
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color:
                                      const Color.fromARGB(255, 126, 126, 126),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName,
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            '(IN) $userPhoneNumber',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(148, 1, 36, 0),
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    FlutterPhoneDirectCaller
                                                        .callNumber(
                                                            userPhoneNumber);
                                                  },
                                                  child: Text(
                                                    'Contact',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.black,
                                                    onPrimary: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Cancel Ride'),
                                                      content: const Text(
                                                          'Are you sure to cancel the ride ?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => {
                                                            Navigator.pop(
                                                                context),
                                                          },
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => {
                                                            deleteID(),
                                                            Navigator.pop(
                                                                context),
                                                            Navigator.pop(
                                                                context),
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //deleteID();

                                                  //   Navigator.pop(context);
                                                  // },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.black,
                                                    onPrimary: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // If there is no data, display a message indicating that no match was found.
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.car_crash,
                                        color: Colors.red,
                                        size: 80,
                                      ),
                                      Text(
                                        'No match found!',
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              37.4219999, -122.0840575), // Set initial location
                          zoom: 15,
                        ),
                        polylines: _polylines,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
