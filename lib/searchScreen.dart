// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_is_empty, file_names, unused_local_variable, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:helpcar/AllWidgets/divider.dart';
import 'package:helpcar/AllWidgets/progressdialog.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:helpcar/Models/address.dart';
import 'package:helpcar/Models/placepredictions.dart';
import 'package:helpcar/configmaps.dart';
import 'package:provider/provider.dart';

import 'Assistants/requestassistant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();
  String get destinationText => destinationTextEditingController.text;

  List<PlacePredictions> placePredictionsList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).userPickUpLocation!.placeFormattedAddress;
    pickUpTextEditingController.text = placeAddress;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260.0,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 228, 199),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 25.0, top: 70.0, right: 25.0, bottom: 25.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    Stack(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      Center(
                        child: Text(
                          "Enter Ride Details",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      )
                    ]),
                    SizedBox(height: 18.0),
                    Row(
                      children: [
                        Image.asset("images/pickicon.png",
                            height: 40.0, width: 20.0),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset("images/desticon.png",
                            height: 40.0, width: 20.0),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                autofocus: true,
                                onChanged: (val) {
                                  findPlace(val);
                                },
                                controller: destinationTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Destination Location",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //tile for predictions
            SizedBox(
              height: 10.0,
            ),
            (placePredictionsList.length > 0)
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePredictions: placePredictionsList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          CustomDivider(),
                      itemCount: placePredictionsList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionsList = placesList;
        });
      }
    }
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
        getPlaceAddressDetails(placePredictions!.place_id, context);
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
