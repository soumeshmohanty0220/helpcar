
// ignore_for_file: unused_import, unused_field, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:helpcar/Allscreens/HelperScreens/helperCurrentPath.dart';
import 'package:helpcar/Allscreens/HelperScreens/helpersearchscreen.dart';
import 'helperPreviousPath.dart';

class HelperHomePage extends StatefulWidget {
  const HelperHomePage({Key? key}) : super(key: key);

  @override
  _HelperHomePageState createState() => _HelperHomePageState();
}

class _HelperHomePageState extends State<HelperHomePage> {
  final int _selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.greenAccent,
        backgroundColor: Color.fromARGB(255, 255, 127, 67),
        toolbarHeight: 250,
        title: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey Helper !",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 40.0,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Add your way",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: HelperCurrentPath(),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrentPathPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Color.fromARGB(255, 67, 160, 71),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Add Path",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



