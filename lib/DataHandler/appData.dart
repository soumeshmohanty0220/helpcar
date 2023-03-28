// ignore_for_file: avoid_init_to_null, file_names

import 'package:flutter/material.dart';
import '../Models/address.dart';

class AppData extends ChangeNotifier
{
  Address? userPickUpLocation = null; // Initialize with default value of null
  void updatePicupLocationAddress(Address pickUpAddress)
  {
    userPickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
