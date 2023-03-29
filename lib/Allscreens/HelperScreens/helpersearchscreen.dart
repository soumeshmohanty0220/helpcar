// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CurrentPathPage extends StatefulWidget {
  const CurrentPathPage({Key? key}) : super(key: key);

  @override
  _CurrentPathPageState createState() => _CurrentPathPageState();
}

class _CurrentPathPageState extends State<CurrentPathPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _timeController = TextEditingController();

  late String _currentUserMobile;

  @override
  void initState() {
    super.initState();

    // get current user's mobile number from Firebase Authentication
    FirebaseAuth.instance.authStateChanges().listen((User? users) {
      if (users != null) {
        _currentUserMobile = users.phoneNumber!;
      }
    });
  }

  Future<void> _saveCurrentPath() async {
    if (_formKey.currentState!.validate()) {
      final location = _locationController.text;
      final destination = _destinationController.text;
      final time = _timeController.text;

      // save current path information to Firebase Realtime Database
      final database = FirebaseDatabase.instance.reference();
      await database.child('current_paths').child(_currentUserMobile).set({
        'location': location,
        'destination': destination,
        'time': time,
      });

      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current path saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Path'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationController,
                decoration:
                    const InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCurrentPath,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
