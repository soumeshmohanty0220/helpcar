// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, unused_import, library_private_types_in_public_api

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
  int _selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 162, 103),
        toolbarHeight: 300,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey Helper",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  "Add Your Way",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("Current Path", 0),
                _buildButton("Previous Paths", 1),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildBody(_selectedButtonIndex)),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromARGB(255, 247, 90, 0),
                ),
                child: const Text(
                  "Add Path",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildButton(String label, int index) {
    final isSelected = _selectedButtonIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedButtonIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          // border: Border.all(
          //   color: isSelected ? Colors.white : Colors.transparent,
          //   width: 2,
          // ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(int index) {
    final isSelected = _selectedButtonIndex == 0;
    if (isSelected) {
      // return Text(
      //   "No Current Active Path",
      //   style: TextStyle(
      //     fontSize: 15,
      //   ),
      // );
      return helperCurrentPath();
    } else {
      return helperPreviousPath();
    }
  }
}
