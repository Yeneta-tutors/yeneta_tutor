import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorCoursesPage.dart';

class TutorHomePage extends StatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  int _selectedIndex = 0; // Track the selected index in the bottom nav bar

  // List of pages to navigate between
  final List<Widget> _pages = [
    Center(child: Text('Tutor Home Page')), // Home
    CoursesPage(), // Courses
    Center(child: Text('Profile Page')), // Profile
    Center(child: Text('Messages Page')), // Messages
    Center(child: Text('Earnings Page')), // Earnings
  ];

  // Method to handle when an icon is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor App Home Page'),
        backgroundColor:
            const Color.fromRGBO(9, 15, 44, 1),
            foregroundColor: Colors.white, // Dark blue app bar
      ),
      body: _pages[_selectedIndex], // Display the corresponding page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.brown, // Icon color when selected
        unselectedItemColor: Colors.white, // Icon color when not selected
        backgroundColor: Color.fromRGBO(9, 15, 44, 1), // Dark blue background
        selectedFontSize: 14, // Larger text when selected
        unselectedFontSize: 12, // Smaller text when not selected
        iconSize: 30, // Larger icon size
        onTap: _onItemTapped, // Handle tap on the nav bar
      ),
    );
  }
}































