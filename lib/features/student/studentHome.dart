import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/student/paymentsPage.dart';
import 'package:yeneta_tutor/features/student/studentHomePageDemo.dart';
import 'package:yeneta_tutor/features/student/studentProfile.dart';
import 'package:yeneta_tutor/features/student/subscribedCourses.dart';
import 'package:yeneta_tutor/features/common/chat_screen.dart';


class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  int _selectedIndex = 0; 
 
 final List<Widget>  _pages = [
      StudentHomePageDemo(),
      SubscribedCourses(),  
      studentProfile(), 
      ChatScreen(), // Messages
      PaymentHistoryPage(), // Earnings
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































