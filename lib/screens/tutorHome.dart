import 'package:flutter/material.dart';

class TutorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Tutor!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Here are your tasks:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('View Assigned Courses'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('View Your Students'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: Text('Manage Grades'),
            ),
          ],
        ),
      ),
    );
  }
}
