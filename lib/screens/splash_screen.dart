import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboarding_screen.dart';
import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    await Future.delayed(
        const Duration(seconds: 5)); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(
          'images/logo.jpg',
          width: 100,
          height: 100,
        ), // Splash screen logo
      ),
    );
  }
}
