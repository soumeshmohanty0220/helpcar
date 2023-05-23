// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, camel_case_types, unused_local_variable, unnecessary_string_interpolations

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpcar/Models/directiondetails.dart';
import 'package:provider/provider.dart';

import '../../AllWidgets/progressdialog.dart';
import '../../AllWidgets/requesterRideDetails.dart';
import '../../Assistants/assistantmethods.dart';
import '../../DataHandler/appData.dart';
import '../../searchScreen.dart';
import '../HelperScreens/helperHomePage.dart';
import '../login_screen.dart';

class requesterHomePage extends StatefulWidget {
  const requesterHomePage({Key? key}) : super(key: key);

  static const String idScreen = "home";

  @override
  State<requesterHomePage> createState() => _requesterHomePageState();
}

class _requesterHomePageState extends State<requesterHomePage> {
  static var currentPageState = 1;
  DirectionDetails? Details;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  // ignore: prefer_final_fields, unused_field
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late LatLng _center = LatLng(0, 0);
  String _currentAddress = "";

  // ignore: prefer_final_fields

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
// ignore: todo
// TODO: Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
// ignore: todo
// TODO: Handle denied permission forever
    } else {
// Permission granted
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });

    Position position = Position(
      latitude: _center.latitude,
      longitude: _center.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      floor: null,
      isMocked: false,
    );

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _currentAddress = address;
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 15));

    print("This is your address :: $address");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "HelpCAR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            if (currentPageState == 1) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            } else if (currentPageState == 2) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentPageState = 1;
                    polylineSet.clear();
                    markersSet.clear();
                    circlesSet.clear();

                    mapController
                        .animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
                  });
                  // _onMapCreated(_controller as GoogleMapController);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      drawer: Container(
        color: Color.fromARGB(255, 166, 235, 228),
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Name of the user fetched from firebase
                            "Your Profile",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Brand Bold",
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text(
                  "Visit Profile",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.history, color: Colors.blue),
                title: Text(
                  "History",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {},
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelperHomePage()),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.car_rental, color: Colors.blue),
                  title: Text(
                    "Provide Help",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.idScreen);
                  } catch (e) {
                    print("Error logging out: $e");
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (currentPageState == 2) {
            setState(() {
              currentPageState = 1;

              polylineSet.clear();
              markersSet.clear();
              circlesSet.clear();
              mapController
                  .animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
            });
          } else {
            SystemNavigator.pop();
          }

          return false;
        },
        child: _center == LatLng(0, 0)
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 10.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    polylines: polylineSet,
                    markers: markersSet,
                    circles: circlesSet,
                  ),
                  Positioned(
                      left: 10.0,
                      right: 10.0,
                      bottom: 10.0,
                      child: (currentPageState == 2)
                          ? requestRideDetails(
                              loc1: Provider.of<AppData>(context, listen: false)
                                  .userPickUpLocation!
                                  .placeName,
                              loc2: Provider.of<AppData>(context, listen: false)
                                  .dropOfflocation!
                                  .placeName,
                              distanceText: Details?.distanceText ?? 'Unknown',
                              durationText: Details?.durationText ?? 'Unknown',
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 241, 228, 199),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.0),
                                      Text(
                                        "Hi there !",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        "Need Help ?",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var res = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchScreen()));
                                          if (res == "obtainDirection") {
                                            await getPlaceDirection();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.blueAccent,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text("Search Destination"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Builder(builder: (context) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    _currentAddress,
                                                    textAlign: TextAlign.left,
                                                    softWrap: true,
                                                    maxLines: 5,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                Text(
                                                  "Your Current Location",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12.0),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  )),
                            )),
                ],
              ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    currentPageState = 2;
    var initialPos =
        Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOfflocation;
    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      Details = details;
    });
    print("Details: $details");
    if (details != null) {
      print("Distance: ${details.distanceText}");
      print("Duration: ${details.durationText}");
    }

    Navigator.pop(context);
    print("This is Encoded Points :: ");
    print(details!.encodedPoints);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;

    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    setState(() {
      mapController
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 80));
    });

    Marker pickUpMarker = Marker(
      markerId: MarkerId("pickUpId"),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "My Location"),
    );
    Marker dropOffMarker = Marker(
      markerId: MarkerId("dropOffId"),
      position: dropOffLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "Drop Off Location"),
    );
    Circle pickUpCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );
    Circle dropOffCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpMarker);
      markersSet.add(dropOffMarker);
      circlesSet.add(pickUpCircle);
      circlesSet.add(dropOffCircle);
    });
  }
}
