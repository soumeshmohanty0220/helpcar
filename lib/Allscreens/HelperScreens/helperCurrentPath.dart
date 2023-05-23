// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:helpcar/Allscreens/HelperScreens/requester_details_page.dart';

class HelperCurrentPath extends StatefulWidget {
  const HelperCurrentPath({Key? key}) : super(key: key);

  @override
  _HelperCurrentPathState createState() => _HelperCurrentPathState();
}

class _HelperCurrentPathState extends State<HelperCurrentPath> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  String? _currentLocation;
  String? _destination;
  String? _time;

  @override
  void initState() {
    super.initState();
    _fetchPath();
  }

  Future<void> _fetchPath() async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef = database.child('users').child(user.uid);

      // Update data in realtime
      userRef.child('paths').onValue.listen((event) {
        final Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            _currentLocation = data['currentLocation'];
            _destination = data['destination'];
            _time = data['time'];
          });
        } else {
          setState(() {
            _currentLocation = 'No Data';
            _destination = 'No Data';
            _time = 'No Time Set';
          });
        }
      });
    }
  }

  void _removePath() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef = _database.child('users').child(user.uid);
      await userRef.child('paths').remove();

      setState(() {
        _currentLocation = 'No data';
        _destination = 'No data';
        _time = 'No time set';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 253, 253),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 50,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                Text(
                  "CURRENT PATH",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.red,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Current Location",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _currentLocation ?? "No Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.red,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Destination",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _destination ?? "No Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.red,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Out Time",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                Text(
                  _time ?? "No Time Set",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _removePath,
                icon: Icon(Icons.delete),
                label: Text('Remove Path'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequesterDetailsPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Requested'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
