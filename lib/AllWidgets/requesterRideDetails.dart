import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class requestRideDetails extends StatefulWidget {
  final String loc1;
  final String loc2;
  const requestRideDetails({super.key, required this.loc1, required this.loc2});

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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Text(
                    widget.loc1,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  size: 30,
                ),
                Flexible(
                  child: Text(
                    widget.loc2,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "4 km",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 65, 65, 65)),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estimated Time",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "15 mins",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 65, 65, 65)),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Car Pool"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 55, 124, 55),
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      fixedSize: Size(100, 50),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("HelpCar"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 219, 11, 11),
                      foregroundColor: Color.fromARGB(255, 248, 248, 248),
                      fixedSize: Size(100, 50),
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
