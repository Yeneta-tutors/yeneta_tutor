import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboardingScreen1.dart';
import 'package:yeneta_tutor/screens/onboardingScreen3.dart';
import 'package:yeneta_tutor/screens/onboardingScreen4.dart';

class OnboardingScreen2 extends StatelessWidget {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Handle back action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen1(), 
                    ),
                  );
                    },
                  ),
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
                    'images/onboarding2.png', // Add your image here
                    height: 250,
                  ),
                ),
              ),
              
              // Title and description
              const Text(
                'Teach and Learn, Anytime, Anywhere',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Access or offer high-quality courses at your own pace. Whether '
                'you are creating courses or diving into new subjects, flexibility is at your fingertips.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Next button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen or complete onboarding
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen3(), 
                    ),
                  );
                },
                child: Text('NEXT'),
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), 
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


