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
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference userRef = database.child('users').child(user.uid);

      // Update data in realtime
      userRef.child('paths').onValue.listen((event) {
        final Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          // print("this data ${data}");
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
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller:
                TextEditingController(text: _currentLocation ?? "No Data"),
            readOnly: true,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "No Data",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 10),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller:
                TextEditingController(text: _destination ?? "No Data"),
            readOnly: true,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "No Data",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 10),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller:
                TextEditingController(text: _time ?? "No Data"),
            readOnly: true,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "No Data",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _removePath,
                  icon: Icon(Icons.delete),
                  label: Text('Remove Path'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
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
                    backgroundColor: const Color.fromARGB(255, 59, 59, 59),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
