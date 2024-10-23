import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/studentHomePageDemo.dart';
import 'package:yeneta_tutor/features/auth/screens/studentProfile.dart';
import 'package:yeneta_tutor/features/auth/screens/subscribedCourses.dart';
import 'package:yeneta_tutor/features/chat/screens/chat_screen.dart';


class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    StudentHomePageDemo(),
    SubscribedCourses(),  
    studentProfile(), 
    ChatScreen(tutorId: '',), 
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
        unselectedItemColor: Colors.white, // Icon color when not selected
        backgroundColor: const Color.fromRGBO(9, 15, 44, 1), // Dark blue background
        selectedFontSize: 14, // Larger text when selected
        unselectedFontSize: 12, // Smaller text when not selected
        iconSize: 30, // Larger icon size
        onTap: _onItemTapped, // Handle tap on the nav bar
      ),
    );
  }
}































