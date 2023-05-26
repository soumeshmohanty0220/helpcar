// ignore_for_file: equal_keys_in_map, deprecated_member_use, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:provider/provider.dart';

import 'Allscreens/requesterScreens/requesterHomePage.dart';
import 'Allscreens/login_screen.dart';
import 'Allscreens/registrationscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin;

  checkiflogin() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          isLogin = false;
        });
      } else {
        print('User is signed in!');
        setState(() {
          isLogin = true;
        });
      }
    });
    if (auth.currentUser == null) {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    checkiflogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'HelpCAR',
        theme: ThemeData(
          fontFamily: "Brand Bold",
          primarySwatch: Colors.orange,
        ),
        initialRoute: isLogin? requesterHomePage.idScreen : LoginScreen.idScreen,
        // initialRoute: requesterHomePage.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          requesterHomePage.idScreen: (context) => requesterHomePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
