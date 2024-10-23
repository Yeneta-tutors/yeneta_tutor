import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/studentHomePageDemo.dart';
import 'package:yeneta_tutor/features/auth/screens/studentProfile.dart';
import 'package:yeneta_tutor/features/auth/screens/subscribedCourses.dart';


class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0; // Track the selected index in the bottom nav bar

  // List of pages to navigate between
  final List<Widget> _pages = [
    StudentHomePageDemo(), // Home
    Subscribedcourses(),  
    studentProfile(), // Profile
    Center(child: Text('studnet Messages Page')), // Messages
    Center(child: Text('studnet Earnings Page')), // Earnings
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
      // appBar: AppBar(
      //   title: Text('Tutor App Home Page'),
      //   backgroundColor:
      //       const Color.fromRGBO(9, 15, 44, 1),
      //       foregroundColor: Colors.white, // Dark blue app bar
      // ),
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
            label: 'Payment',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.brown, // Icon color when selected
        unselectedItemColor: Colors.white, 
        backgroundColor: const Color.fromRGBO(9, 15, 44, 1), 
        selectedFontSize: 14, 
        unselectedFontSize: 12, 
        iconSize: 30, // Larger icon size
        onTap: _onItemTapped, 
      ),
    );
  }
}































