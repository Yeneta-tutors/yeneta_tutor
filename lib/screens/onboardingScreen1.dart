import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboardingScreen2.dart';
import 'package:yeneta_tutor/screens/onboardingScreen3.dart';
import 'package:yeneta_tutor/screens/onboardingScreen4.dart';

class OnboardingScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Skip button at the top right

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   onPressed: () {
                  //     // Handle back action
                  //     //no back button nedded
                  //   },
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OnboardingScreen4(), 
                        ),
                      );
                    },
                    child: const Text('Skip'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Illustration
              Expanded(
                child: Center(
                  child: Image.asset(
                    'images/onboarding1.png', // Add your image here
                    height: 250,
                  ),
                ),
              ),

              // Title and description
              const Text(
                'Welcome to Yeneta Tutor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Join a vibrant learning community where knowledge is shared and skills are built.'
                ' Whether you are here to teach or to learn, you have come to the right place.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Next button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OnboardingScreen2(), 
                    ),
                  );
                },
                child: Text(
                  'NEXT',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
