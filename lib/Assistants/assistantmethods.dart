// ignore_for_file: unnecessary_new

import 'package:geolocator/geolocator.dart';
import 'package:helpcar/Assistants/requestassistant.dart';
import 'package:provider/provider.dart';

import '../DataHandler/appData.dart';
import '../Models/address.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC8VZaPR5Hpf5po7MdL25UY9At7vDDl2kc";
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      //placeAddress = response["results"][0]["formatted_address"];
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = new Address(
        placeFormattedAddress: placeAddress,
        placeName: placeAddress,
        placeId: "123456789",
        latitude: position.latitude,
        longitude: position.longitude,
      );

      Provider.of<AppData>(context, listen: false)
          .updatePicupLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);
    if(res == "failed")
    {
      return null;
    }
DirectionDetails directionDetails = DirectionDetails(
  distanceText: res["routes"][0]["legs"][0]["distance"]["text"],
  durationText: res["routes"][0]["legs"][0]["duration"]["text"],
  distanceValue: res["routes"][0]["legs"][0]["distance"]["value"],
  durationValue: res["routes"][0]["legs"][0]["duration"]["value"],
  encodedPoints: res["routes"][0]["overview_polyline"]["points"],
    );

  return directionDetails;
  }
}
