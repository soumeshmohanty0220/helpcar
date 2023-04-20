// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  //Define id screen
  static const String idScreen = "register";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final url = Uri.parse('http://34.122.84.107:8080/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Registration successful
        print('Registration successful!');
        Navigator.of(context).pushReplacementNamed(LoginScreen.idScreen,
            arguments: 'Registration Successful!');
      } else {
        // Registration failed
        print('Registration failed!');
      }
    } catch (error) {
      // Handle error
      print('Error occurred while registering user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, LoginScreen.idScreen);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 206, 238, 235),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Container(
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image(
                      image: AssetImage('images/helpcar.png'),
                      width: 350,
                      height: 350,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Email ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF43A047),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../AllWidgets/progressdialog.dart';
// import '../main.dart';
// import 'requesterScreens/requesterHomePage.dart';
// import 'login_screen.dart';

// class RegistrationScreen extends StatelessWidget {
//   RegistrationScreen({Key? key}) : super(key: key);

//   static const String idScreen = "register";

//   TextEditingController nameTextEditingController = TextEditingController();
//   TextEditingController phoneTextEditingController = TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushNamed(context, LoginScreen.idScreen);
//           },
//         ),
//       ),
//       // ignore: prefer_const_constructors
//       backgroundColor: Color.fromARGB(255, 206, 238, 235),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20.0,
//               ),
//               Container(
//                 height: 200.0,
//                 child: Image(
//                   image: AssetImage('images/helpcar.png'),
//                   width: 350.0,
//                   height: 350.0,
//                   alignment: Alignment.bottomCenter,
//                 ),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Text(
//                 "Ride to Wellness !",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 28.0,
//                     fontFamily: "Brand Bold",
//                     color: Colors.black87),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 2.0,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: TextField(
//                         controller: nameTextEditingController,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           hintText: "Enter your name",
//                           hintStyle: TextStyle(color: Colors.black87),
//                           border: InputBorder.none,
//                           icon: Icon(Icons.phone_android),
//                         ),
//                         style: TextStyle(fontSize: 16.0, color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: TextField(
//                         controller: phoneTextEditingController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           hintText: "Mobile Number",
//                           hintStyle: TextStyle(color: Colors.black87),
//                           border: InputBorder.none,
//                           icon: Icon(Icons.phone_android),
//                         ),
//                         style: TextStyle(fontSize: 16.0, color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: TextField(
//                         controller: emailTextEditingController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           hintText: "Email",
//                           hintStyle: TextStyle(color: Colors.black87),
//                           border: InputBorder.none,
//                           icon: Icon(Icons.phone_android),
//                         ),
//                         style: TextStyle(fontSize: 16.0, color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: TextField(
//                         controller: passwordTextEditingController,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           hintText: "Password",
//                           hintStyle: TextStyle(color: Colors.black87),
//                           border: InputBorder.none,
//                           icon: Icon(Icons.security),
//                         ),
//                         style: TextStyle(fontSize: 16.0, color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         ),
//                         minimumSize: Size(double.infinity, 50.0),
//                       ),
//                       onPressed: () {
//                         if (nameTextEditingController.text.length < 3) {
//                           displayToastMessage(
//                               "Name must be atleast 4 characters", context);
//                         } else if (!emailTextEditingController.text
//                             .contains("@")) {
//                           displayToastMessage(
//                               "Email address is not valid", context);
//                         } else if (passwordTextEditingController.text.length <
//                             6) {
//                           displayToastMessage(
//                               "Password must be atleast 6 characters", context);
//                         } else {
//                           registerNewUser(context);
//                         }
//                       },
//                       child: Text(
//                         "Register",
//                         style: TextStyle(
//                             fontSize: 20.0,
//                             fontFamily: "Brand Bold",
//                             color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color.fromARGB(255, 252, 255, 68),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         ),
//                         minimumSize: Size(double.infinity, 50.0),
//                       ),
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, LoginScreen.idScreen, (route) => false);
//                       },
//                       child: Text(
//                         "Have an account ? Login Here !",
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   void registerNewUser(BuildContext context) async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return ProgressDialog(message: "Registering, Please wait...");
//         });

//     final User? firebaseUser = (await _firebaseAuth
//             .createUserWithEmailAndPassword(
//                 email: emailTextEditingController.text,
//                 // ignore: body_might_complete_normally_catch_error
//                 password: passwordTextEditingController.text)
//             .catchError((errMsg) {
//       Navigator.pop(context);
//       displayToastMessage("Error:$errMsg", context);
//     }))
//         .user;

//     if (firebaseUser != null) //user created
//     {
//       Map userDataMap = {
//         "name": nameTextEditingController.text.trim(),
//         "email": emailTextEditingController.text.trim(),
//         "phone": phoneTextEditingController.text.trim(),
//       };
//       userRef.child(firebaseUser.uid).set(userDataMap);
//       displayToastMessage(
//           "Congratulations, your account has been created", context);
//       Navigator.pushNamedAndRemoveUntil(
//           context, LoginScreen.idScreen, (route) => false);
//     } else {
//       Navigator.pop(context);
//       displayToastMessage("New user account has not been created", context);
//     }
//   }

//   displayToastMessage(String message, BuildContext context) {
//     Fluttertoast.showToast(msg: message);
//   }
// }
