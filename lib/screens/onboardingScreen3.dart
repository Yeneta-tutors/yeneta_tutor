import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboardingScreen2.dart';
import 'package:yeneta_tutor/screens/onboardingScreen4.dart';


class OnboardingScreen3 extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Handle back action
                       Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen2(), 
                    ),
                  );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle skip action
                       Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  OnboardingScreen4(), 
                    ),
                  );
                    },
                    child: Text('Skip'),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Illustration
              Expanded(
                child: Center(
                  child: Image.asset(
                    'images/onboarding3.png', // Add your image here
                    height: 250,
                  ),
                ),
              ),
              
              // Title and description
              const Text(
                'Engage and Interact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Connect with learners or tutors. As a student, ask questions directly; '
                'as a tutor, guide your students to success with real-time interactions',
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
                      builder: (context) =>  OnboardingScreen4(), // The next screen in the sequence
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), // Full-width button
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('NEXT'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// // Create a placeholder for the third screen in the onboarding
// class OnboardingScreenThree extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('This is the third onboarding screen'),
//       ),
//     );
//   }
// }
