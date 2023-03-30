// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class requesterHelperDetails extends StatefulWidget {
  const requesterHelperDetails({super.key});

  @override
  State<requesterHelperDetails> createState() => _requesterHelperDetailsState();
}

class _requesterHelperDetailsState extends State<requesterHelperDetails> {
  bool hasRiderMatched = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 8), () {
      setState(() {
        hasRiderMatched = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasClicked = false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 0, 224, 206),
        toolbarHeight: 250,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (hasRiderMatched)
                          ? Text(
                              "RIDE",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0,
                              ),
                            )
                          : AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                RotateAnimatedText(
                                  'HELPER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                RotateAnimatedText(
                                  'RIDER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                RotateAnimatedText(
                                  'DRIVER',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
                    "is On the Way",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
          ],
        ),
      ),
      body: (hasRiderMatched)
          ? Column(
              children: [
                helpDetailsWidget(),
                ElevatedButton(
                  onPressed: hasClicked ? null: () { setState(() {hasClicked = true;
                  }); 
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasClicked? Color.fromARGB(31, 138, 138, 138): Color.fromARGB(255, 247, 224, 24),
                    
                  ),
                  child: Text("HELPER ARRIVED",),
                )
              ],
            )
          : Center(child: Lottie.asset('images/117478-delivery.json')),
    );
  }

  Widget helpDetailsWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(Icons.person,color: Colors.blue,size: 120.0,),
          SizedBox(height: 20.0),
          Column(
            children: [
              Text(
                "Suman Sahoo",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "+91 8144498292",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(151, 18, 75, 25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
