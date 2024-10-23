import 'package:flutter/material.dart';
import 'dart:async';
import 'package:yeneta_tutor/screens/onboardingScreen1.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Set a timer for 2 seconds and then navigate to the next page
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), 
      body: Center(
        child: Image.asset(
          'images/yeneta_logo.jpg', 
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
