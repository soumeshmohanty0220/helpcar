// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:helpcar/Allscreens/requesterScreens/requesterHelperDetails.dart';
import 'package:helpcar/Models/directiondetails.dart';

class requestRideDetails extends StatefulWidget {
  final String loc1;
  final String loc2;
  final String distanceText;
  final String durationText;
   final DirectionDetails? details;

  const requestRideDetails({
    Key? key,
    required this.loc1,
    required this.loc2,
    required this.distanceText,
    required this.durationText,
    this.details,
  }) : super(key: key);

  @override
  State<requestRideDetails> createState() => _requestRideDetailsState();
}


class _requestRideDetailsState extends State<requestRideDetails> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 228, 199),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 16.0,
            spreadRadius: 0.5,
            offset: const Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.loc1,
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  size: 50,
                  color: Colors.blueAccent,
                ),
                Flexible(
                  child: Text(
                    widget.loc2,
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 20,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Distance",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      widget.distanceText,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color.fromARGB(255, 250, 4, 4)),
                          
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estimated Time",
                      style: TextStyle(fontSize: 15,color: Colors.black),
                    ),
                    Text(
                      widget.durationText,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color.fromARGB(255, 245, 4, 4)),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => requesterHelperDetails()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 50,
                      backgroundColor: Color.fromARGB(255, 55, 124, 55),
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      fixedSize: Size(140, 50),
                    ),
                    child: Text("Car Pool"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => requesterHelperDetails()));
                    },
                    child: Text("HelpCAR"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 50,
                      backgroundColor: Color.fromARGB(255, 219, 11, 11),
                      foregroundColor: Color.fromARGB(255, 248, 248, 248),
                      fixedSize: Size(140, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
