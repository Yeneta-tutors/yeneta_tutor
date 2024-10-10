import 'package:flutter/material.dart';
import 'package:yeneta_tutor/screens/onboardingScreen3.dart';
import 'package:yeneta_tutor/features/auth/screens/studentSignUp1.dart';

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
        MaterialPageRoute(builder: (context) => TutorSignUpPage()),
      );
    } else {
      // Show a message to select a role
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
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
                'Join the Tutoring Community',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Become part of a vibrant community of passionate tutors, share knowledge, '
                'and collaborate with like-minded educators.',
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
                      foregroundColor: Colors.white,
                      backgroundColor: selectedRole == 'Student'
                          ? Colors.blue
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
                  minimumSize: Size(double.infinity, 50), // Full-width button
                  textStyle: TextStyle(fontSize: 18),
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

// Placeholder pages for student and tutor sign-ups
class StudentSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Sign Up'),
      ),
      body: Center(
        child: Text('Student Sign Up Page'),
      ),
    );
  }
}

class TutorSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Sign Up'),
      ),
      body: Center(
        child: Text('Tutor Sign Up Page'),
      ),
    );
  }
}
