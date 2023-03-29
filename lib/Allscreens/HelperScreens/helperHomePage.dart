// ignore_for_file: prefer_const_constructors, camel_case_types

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:helpcar/Allscreens/HelperScreens/helperCurrentPath.dart';

import 'helperPreviousPath.dart';

class helperHomePage extends StatefulWidget {
  const helperHomePage({super.key});

  @override
  State<helperHomePage> createState() => _helperHomePageState();
}

class _helperHomePageState extends State<helperHomePage> {
  int _selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 255, 162, 103),
        toolbarHeight: 300,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hey Helper!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
            Text(
              "Add Your Way",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Row(
              children: [
                _buildButton("Current Path", 0),
                _buildButton("Previous Paths", 1),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBody(_selectedButtonIndex),
              // Text(
              //   "No Current Active Path",
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color.fromARGB(255, 247, 90, 0),
                  ),
                  child: Text(
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
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
      // return Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       "No History",
      //       style: TextStyle(
      //         fontSize: 20,
      //       ),
      //     ),
      //     Icon(
      //       Icons.history,
      //       size: 40,
      //     ),
      //   ],
      // );
      return helperPreviousPath();
    }
  }
}
