import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  String username="", phone="", email="";

   @override
  void initState() {
    super.initState();
    userdetails();
  }

  Future<void> userdetails() async {
    final User? user = _auth.currentUser;
    var event1 =
        await _database.child('users').child(user!.uid).child('name').once();
        var event2 =
        await _database.child('users').child(user!.uid).child('phone').once();
        var event3 =
        await _database.child('users').child(user!.uid).child('email').once();
    if (event1.snapshot.value != null) {
      // return event.snapshot.value as String;
      setState(() {
        username = event1.snapshot.value as String;
        phone = event2.snapshot.value as String;
        email = event3.snapshot.value as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64.0,
              backgroundImage: AssetImage('assets/profile_photo.jpg'),
            ),
            SizedBox(height: 16.0),
            Text(
              username,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 18.0,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 18.0,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                 email,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
