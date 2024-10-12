import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Student!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Here are your current activities:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('View Your Courses'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('View Your Tutors'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('Check Grades'),
            ),
          ],
        ),
      ),
    );
  }
}
