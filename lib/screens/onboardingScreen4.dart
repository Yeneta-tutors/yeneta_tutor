import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorSignUp1.dart';
import 'package:yeneta_tutor/screens/onboardingScreen3.dart';
import 'package:yeneta_tutor/features/auth/screens/studentSignUp1.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

class OnboardingScreen4 extends StatefulWidget {
  @override
  _OnboardingScreenThreeState createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreen4> {
  String selectedRole = '';

  void navigateToSignUp() {
    if (selectedRole == 'Student') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentSignUpPage1()),
      );
    } else if (selectedRole == 'Tutor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TutortSignUpPage1()),
      );
    } else {
      // Show a message to select a role
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please select a role')),
      // );

      showSnackBar(context, 'Please select a role to proceed');
    }
  }

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
                          builder: (context) =>
                              OnboardingScreen3(), // The next screen in the sequence
                        ),
                      );
                    },
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     // Handle skip action or finish onboarding
                  //   },
                  //   child: const Text('Skip'),
                  // ),
                ],
              ),

              const SizedBox(height: 20),

              // Illustration
              Expanded(
                child: Center(
                  child: Image.asset(
                    'images/onboarding4.png', // Add your image here
                    height: 250,
                  ),
                ),
              ),

              // Title and description
              const Text(
                'Get Started with Confidence',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign up as a tutor to share your expertise, or as a student to'
                'expand your knowledge. Select your path and begin your journey!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Role selection: Student or Tutor
              const Text(
                'I am a',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Student button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRole = 'Student';
                      });
                    },
                    child: Text('Student'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: selectedRole == 'Student'
                          ? const Color.fromARGB(255, 99, 104, 108)
                          : const Color.fromRGBO(9, 19, 58, 1),
                      minimumSize: Size(120, 50),
                    ),
                  ),
                  SizedBox(width: 20),

                  // Tutor button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRole = 'Tutor';
                      });
                    },
                    child: Text('Tutor'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromRGBO(9, 19, 58, 1),
                      side: BorderSide(color: Color.fromRGBO(9, 19, 58, 1)),
                      backgroundColor: selectedRole == 'Tutor'
                          ? const Color.fromARGB(255, 99, 104, 108)
                          : const Color.fromARGB(255, 255, 255, 255),
                      minimumSize: Size(120, 50),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Next button
              ElevatedButton(
                onPressed: navigateToSignUp,
                child: Text('NEXT'),
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), 
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}




