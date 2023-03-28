// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 4.0,
      color: Colors.black,
      thickness: 2.0,
    );
  }
}
