// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, prefer_const_constructors, sort_child_properties_last
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../AllWidgets/progressdialog.dart';
import '../../Assistants/requestassistant.dart';
import '../../DataHandler/appData.dart';
import '../../Models/address.dart';
import '../../Models/placepredictions.dart';
import '../../configmaps.dart';

class helperAddPath extends StatefulWidget {
  const helperAddPath({Key? key}) : super(key: key);

  @override
  _helperAddPathState createState() => _helperAddPathState();
}

class _helperAddPathState extends State<helperAddPath> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Future<void> _savePath() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // If the user is not logged in, do not save the path.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save the path')),
      );
      return;
    }

    String currentLocation = currentLocationController.text.trim();
    String destination = destinationController.text.trim();
    String time = timeController.text.trim();

    if (currentLocation.isEmpty || destination.isEmpty || time.isEmpty) {
      // show an error message if any of the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      // get the current position using Geolocator package
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double currentLat = currentPosition.latitude;
      double currentLong = currentPosition.longitude;

      // get the position of the destination location using Geolocator package
      List<Location> locations = await locationFromAddress(destination);
      double destinationLat = locations[0].latitude;
      double destinationLong = locations[0].longitude;

      // save the path to Firebase Realtime Database
      _database.child('users').child(user.uid).child('paths').set({
        'currentLocation': currentLocation,
        'destination': destination,
        'time': time,
        'currentLatitude': currentLat,
        'currentLongitude': currentLong,
        'destinationLatitude': destinationLat,
        'destinationLongitude': destinationLong,
      });

      // show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Path added successfully')),
      );

      // clear the text fields
      currentLocationController.clear();
      destinationController.clear();
      timeController.clear();
    } catch (e) {
      print(e);
      // show an error message if any error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding path')),
      );
    }
  }

  List<PlacePredictions> placePredictionsList = [];

  bool isTextFieldSelected1 = false;
  bool isTextFieldSelected2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 206, 238, 235),
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Add Path'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Enter Details',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            TextFormField(
              controller: currentLocationController,
              onTap: () {
                setState(() {
                  isTextFieldSelected1 = true;
                  isTextFieldSelected2 = false;
                });
              },
              onChanged: (val) {
              },
              decoration: InputDecoration(
                hintText: 'Enter your current location',
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Visibility(
              visible: isTextFieldSelected1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionsList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 0,
                  ),
                  itemCount: placePredictionsList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: destinationController,
              onTap: () {
                setState(() {
                  isTextFieldSelected2 = true;
                  isTextFieldSelected1 = false;
                });
              },

              decoration: InputDecoration(
                hintText: 'Enter your destination',
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Visibility(
              visible: isTextFieldSelected2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionsList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 0,
                  ),
                  itemCount: placePredictionsList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: timeController,
              onChanged: (val) {},
              decoration: InputDecoration(
                hintText: 'Enter the time of leaving',
                prefixIcon: Icon(
                  Icons.access_time,
                  color: Colors.blue,
                  size: 30,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  timeController.text = DateFormat('HH:mm').format(DateTime(
                    0,
                    0,
                    0,
                    selectedTime.hour,
                    selectedTime.minute,
                  ));
                }
              },
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                _savePath();
                Navigator.pop(context);
              },
              child: Text(
                'Save Path',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class PredictionTile extends StatelessWidget {
  final PlacePredictions? placePredictions;
  PredictionTile({Key? key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
      onPressed: () {
        // getPlaceAddressDetails(placePredictions!.place_id, context);
      },
      child: Container(
          child: Column(
        children: [
          SizedBox(width: 10.0),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 61, 45, 43),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.0),
                    Text(
                      placePredictions!.main_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      placePredictions!.secondary_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    SizedBox(height: 1.0),
                  ],
                ),
              )
            ],
          ),
          SizedBox(width: 10.0),
        ],
      )),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));
    // ignore: unused_local_variable
    String placeAddress = "";
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);

    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address(
        placeFormattedAddress: placeAddress,
        placeName: placeAddress,
        placeId: "123456789",
        latitude: 0.0,
        longitude: 0.0,
      );
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];
      address.placeId = res["result"]["place_id"];
      address.placeName = res["result"]["name"];
      Provider.of<AppData>(context, listen: false)
          .updatedropOffLocationAddress(address);
      print("This is drop off location:: ");
      print(address.placeName);
      Navigator.pop(context, "obtainDirection");
    }
  }
}
