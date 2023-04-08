import 'package:flutter/material.dart';
import '../Models/address.dart';

class AppData extends ChangeNotifier
{
  Address? userPickUpLocation;   // Initialize with default value of null
  Address? dropOfflocation; 
  void updatePickupLocationAddress(Address pickUpAddress)
  {
    userPickUpLocation = pickUpAddress;
    notifyListeners();
  }

    void updatedropOffLocationAddress(Address dropOffAddress)
  {
    dropOfflocation = dropOffAddress;
    notifyListeners();
  }
}
