import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/signup_controller.dart';
import 'package:yeneta_tutor/models/student_model.dart';

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
      appBar: AppBar(title: Text('Student Signup')),
      body: SafeArea(
        child: SingleChildScrollView( // Add scrolling to prevent overflow
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

                // Form fields inside PageView
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
                              controller: _ageController,
                              decoration: _inputDecoration('Age'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your age' : null,
                            ),
                          ],
                        ),
                        // Page 2
                        Column(
                          children: [
                            TextFormField(
                              controller: _sexController,
                              decoration: _inputDecoration('Sex'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: _inputDecoration('Phone Number'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _addressController,
                              decoration: _inputDecoration('Address'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _gradeController,
                              decoration: _inputDecoration('Grade'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _subjectsController,
                              decoration: _inputDecoration('Subjects of Interest'),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _languagesController,
                              decoration: _inputDecoration('Languages Spoken'),
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
                        onPressed: _signupStudent,
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
