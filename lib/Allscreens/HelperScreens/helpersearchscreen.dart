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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Path'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Destination:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: 'Enter destination',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter destination';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Out Time:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                hintText: 'Enter time',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter time';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
