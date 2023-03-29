// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class helperCurrentPath extends StatefulWidget {
  const helperCurrentPath({super.key});
  static String idScreen = "currentpath";
  @override
  State<helperCurrentPath> createState() => _helperCurrentPathState();
}

class _helperCurrentPathState extends State<helperCurrentPath> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 0,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 216, 216, 216),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.notifications,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gothapatna",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              Icon(
                Icons.arrow_right_alt,
                size: 30,
              ),
              Flexible(
                child: Text(
                  "Vani Vihar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),

                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Out Time",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "9:45 am",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 65, 65, 65)),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estimated Reaching Time",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "11:45 am",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 65, 65, 65)),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
