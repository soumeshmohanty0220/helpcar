// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api, prefer_const_constructors, unnecessary_string_interpolations, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HelperCurrentPath extends StatefulWidget {
  const HelperCurrentPath({Key? key}) : super(key: key);

  @override
  _HelperCurrentPathState createState() => _HelperCurrentPathState();
}

class _HelperCurrentPathState extends State<HelperCurrentPath> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    final DatabaseReference _database = FirebaseDatabase.instance.reference();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef = _database.child('users').child(user.uid);

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
            _currentLocation = 'N/A';
            _destination = 'N/A';
            _time = 'N/A';
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
    width: 350,
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 226, 223, 223),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.deepOrange,
              ),
            ),
            Text(
              "CURRENT PATH",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 50,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${_currentLocation ?? "N/A"}',
                maxLines: 2,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_right_alt,
              size: 50,
              color: Colors.black,
            ),
            Expanded(
              child: Text(
                '${_destination ?? "N/A"}',
                maxLines: 2,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "OUT TIME",
          style: TextStyle(
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          '${_time ?? "No time set"}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _removePath();
              },
              icon: Icon(Icons.delete),
              label: Text('Remove'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              ),
            ),
            SizedBox(width: 16.0),
          ],
        ),
      ],
    ),
  );
}

}
