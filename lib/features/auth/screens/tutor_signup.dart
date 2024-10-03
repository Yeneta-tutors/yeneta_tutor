// screens/tutor_signup.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/signup_controller.dart';
import 'package:yeneta_tutor/models/tutor_model.dart';

class TutorSignup extends ConsumerStatefulWidget {
  @override
  _TutorSignupState createState() => _TutorSignupState();
}

class _TutorSignupState extends ConsumerState<TutorSignup> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qualificationsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _subjectsTaughtController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

   int _currentPage = 0;

  void _signupTutor() {
    if (_formKey.currentState!.validate()) {
      Tutor tutor = Tutor(
        name: _nameController.text,
        qualifications: _qualificationsController.text,
        experience: _experienceController.text,
        subjectsTaught: _subjectsTaughtController.text.split(","),
        hourlyRate: _hourlyRateController.text,
        availability: _availabilityController.text,
      );

      ref.read(signupControllerProvider).signupTutor(
        tutor,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }
    InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutor Signup')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              children: [
                                // Log or instructions on top
                Image.asset('images/logo.jpg', height: 200),
                Text(
                  _currentPage == 0
                      ? "Step 1: Fill in your basic information"
                      : "Step 2: Provide additional details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7, // Adjust the height to fit within screen
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(), // Disable swipe gestures
                      children: [
                        // Page 1
                        Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: _inputDecoration('Email'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your email' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: _inputDecoration('Password'),
                              obscureText: true,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your password' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: _inputDecoration('Name'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your name' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _qualificationsController,
                              decoration: _inputDecoration('Qualifications'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your Qulifications' : null,
                            ),
                          ],
                        ),
                        // Page 2
                        Column(
                          children: [
                            TextFormField(
                              controller: _experienceController,
                              decoration: _inputDecoration('Experience'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _subjectsTaughtController,
                              decoration: _inputDecoration('Subjects Taught'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _hourlyRateController,
                              decoration: _inputDecoration('Hourly Rate'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _availabilityController,
                              decoration: _inputDecoration('Availability'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Navigation Buttons below the form
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0) // Show 'Previous' only if not on the first page
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: Text('Previous'),
                      ),
                    if (_currentPage < 1) // Show 'Next' if not on the last page
                      ElevatedButton(
                        onPressed: _nextPage,
                        child: Text('Next'),
                      ),
                    if (_currentPage == 1) // Show 'Sign Up' on the last page
                      ElevatedButton(
                        onPressed: _signupTutor,
                        child: Text('Sign Up'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}








 
