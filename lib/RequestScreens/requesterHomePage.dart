// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:helpcar/RequestScreens/requesterPickUp.dart';

class RequesterHomePage extends StatefulWidget {
  @override
  _RequesterHomePageState createState() => _RequesterHomePageState();
}

class _RequesterHomePageState extends State<RequesterHomePage> {
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _currentLocationController,
              decoration: InputDecoration(
                hintText: "Your Current Location",
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
                hintText: "Search Destination",
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
    );
  }
}