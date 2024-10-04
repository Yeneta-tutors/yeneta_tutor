import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/signup_controller.dart';
import 'package:yeneta_tutor/models/student_model.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/utils/colors.dart';

class StudentSignup extends ConsumerStatefulWidget {
  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends ConsumerState<StudentSignup> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();

  int _currentPage = 0; // Track the current page index

  void _signupStudent() {
    if (_formKey.currentState!.validate()) {
      Student student = Student(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        sex: _sexController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        grade: _gradeController.text,
        subjectsOfInterest: _subjectsController.text.split(","),
        languagesSpoken: _languagesController.text.split(","),
      );

      ref.read(signupControllerProvider).signupStudent(
            student,
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Signup')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Log or instructions on top
              Image.asset('images/logo.jpg', height: 150),
              Text(
                _currentPage == 0
                    ? "Step 1: Fill in your basic information"
                    : "Step 2: Provide additional details",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Form fields inside PageView
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable swipe gestures
                    children: [
                      // Page 1
                      ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration('Email', Icons.email),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your email' : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                _inputDecoration('Password', Icons.lock),
                            obscureText: true,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your password' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: _inputDecoration('Name', Icons.person),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _ageController,
                            decoration:
                                _inputDecoration('Age', Icons.calendar_today),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your age' : null,
                          ),
                        ],
                      ),
                      // Page 2
                      ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: _sexController,
                            decoration: _inputDecoration('Sex', Icons.person),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration:
                                _inputDecoration('Phone Number', Icons.phone),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration:
                                _inputDecoration('Address', Icons.location_on),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _gradeController,
                            decoration: _inputDecoration('Grade', Icons.school),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _subjectsController,
                            decoration: _inputDecoration(
                                'Subjects of Interest', Icons.book),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _languagesController,
                            decoration: _inputDecoration(
                                'Languages Spoken', Icons.language),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox( height: 16,),
              // Navigation Buttons at the bottom
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_currentPage >
                          0) // Show 'Previous' only if not on the first page
                        TextButton(
                          onPressed: _previousPage,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Previous'),
                        ),
                      const SizedBox(width: 16),
                      if (_currentPage <
                          1) // Show 'Next' if not on the last page
                        TextButton(
                          onPressed: _nextPage,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Next"),
                        ),
                         const SizedBox(width: 16),
                      if (_currentPage == 1) // Show 'Sign Up' on the last page
                        TextButton(
                          onPressed: _signupStudent,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Log in",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
