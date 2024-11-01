import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/tutor/earningsPage.dart';
import 'package:yeneta_tutor/features/tutor/tutorCoursesPage.dart';
import 'package:yeneta_tutor/features/tutor/tutorHomePageDemo.dart';
import 'package:yeneta_tutor/features/tutor/tutorProfile.dart';
import 'package:yeneta_tutor/features/common/chat_screen.dart';

class TutorHomePage extends ConsumerStatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends ConsumerState<TutorHomePage> {
  int _selectedIndex = 0;


 final List<Widget>  _pages = [
      TutorHomePageDemo(), // Home
      CoursesPage(), // Courses
      ProfilePage(), // Profile
      ChatScreen(), // Messages
      EarningsPage(teacherId: '',), // Earnings
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
            label: 'Earnings',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.white,
        backgroundColor:
            const Color.fromRGBO(9, 15, 44, 1), // Dark blue background
        selectedFontSize: 14, // Larger text when selected
        unselectedFontSize: 12, // Smaller text when not selected
        iconSize: 30, // Larger icon size
        onTap: _onItemTapped, // Handle tap on the nav bar
      ),
    );
  }
}
