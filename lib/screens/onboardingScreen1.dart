import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboardingScreen2.dart';
import 'package:yeneta_tutor/screens/onboardingScreen3.dart';

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
                              OnboardingScreen3(), // The next screen in the sequence
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
                'Online Learning',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Monitor your progress, receive feedback from students, and '
                'continuously improve your tutoring skills to achieve exceptional results.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Next button
              ElevatedButton(
                onPressed: () {
                  // Handle next action
                  // Navigate to the next screen or complete onboarding
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OnboardingScreen2(), // The next screen in the sequence
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
