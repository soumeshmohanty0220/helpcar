// ignore_for_file: equal_keys_in_map, deprecated_member_use, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:helpcar/Allscreens/homescreen.dart';
import 'package:helpcar/Allscreens/login_screen.dart';
import 'package:helpcar/Allscreens/registrationscreen.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:helpcar/RequestScreens/requesterDestination.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => AppData(),
      child: MaterialApp(
          title: 'HelpCAR',
          theme: ThemeData(
            fontFamily: "Brand Bold",
            primarySwatch: Colors.orange,
          ),
          initialRoute: LoginScreen.idScreen,
          routes: {
            RegistrationScreen.idScreen: (context) => RegistrationScreen(),
            LoginScreen.idScreen: (context) => LoginScreen(),
            HomeScreen.idScreen: (context) => HomeScreen(), 
          },
          debugShowCheckedModeBanner: false,
        ),
    );
    }
  }

