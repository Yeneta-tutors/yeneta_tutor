import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';

class TutorSignUpPage2 extends ConsumerStatefulWidget {
  final String givenName;
  final String fathersName;
  final String grandFathersName;
  final String selectedGender;

  // Constructor with the parameters
  TutorSignUpPage2({
    required this.givenName,
    required this.fathersName,
    required this.grandFathersName,
    required this.selectedGender,
  });

  @override
  _TutorSignUpPageTwoState createState() => _TutorSignUpPageTwoState();
}

class _TutorSignUpPageTwoState extends ConsumerState<TutorSignUpPage2> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _graduationDepartmentController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // Variables to store user input
  String? _selectedEducationalQualification;
  String? _selectedSubject;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Regular expression for alphabetic validation
  final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');

// Function to validate and submit the form
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider).signUpWithEmailAndPassword(
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            firstName: widget.givenName,
            fatherName: widget.fathersName,
            grandFatherName: widget.grandFathersName,
            phoneNumber: _phoneNumberController.text.trim(),
            grade: "",
            gender: widget.selectedGender,
            educationalQualification: _selectedEducationalQualification,
            graduationDepartment: _graduationDepartmentController.text.trim(),
            subject: _selectedSubject,
            bio:"",
            role: UserRole.tutor,
            profilePic: null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Yeneta Tutors"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'images/signup.png', // Replace with your image
                  height: 150,
                ),
                const SizedBox(height: 20),
                //
                // Phone Number
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Phone Number',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('+251', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }
                              // Check if the input is a number
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return "Please enter a valid phone number (digits only)";
                              }
                              return null;
                  },
                ),
                const SizedBox(height: 16),
                //email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Educational Qualification',
                    prefixIcon: Icon(Icons.school),
                  ),
                  items: ['BSc/BA', 'MSc/MA', 'PhD']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEducationalQualification = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your educational qualification';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                //graduation department
                TextFormField(
                  controller: _graduationDepartmentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Department',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your graduation department';
                    } else if (!_alphabetRegex.hasMatch(value)) {
                      return 'Only letters are allowed';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Subject',
                    prefixIcon: Icon(Icons.book),
                  ),
                  items: [
                    'Maths',
                    'English',
                    'Physics',
                    'Biology',
                    'Chemistry',
                    'Economics',
                    'Information Technology'
                  ]
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a subject';
                    }
                    return null;
                  },
                  isExpanded: false,
                dropdownColor: Colors.grey[200], // Customize dropdown background color
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
               iconSize: 20, 
               menuMaxHeight: 200,
                ),

                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                 minimumSize: Size(150, 50), // Button background color
                                foregroundColor: Color.fromRGBO(9, 19, 58, 1), // Text color (blue-black)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Slightly curved edges
                                  side: BorderSide(color: Color.fromRGBO(9, 19, 58, 1), width: 2), // Border color and width
                                ),
                              ),
                      child: const Text("Back"),
                    ),
                    ElevatedButton(
                      onPressed: _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(9, 19, 58, 1), // Blue-black background color
                            foregroundColor: Colors.white, // White text color
                            minimumSize: Size(150, 50), // Ensures consistent size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Slightly curved edges
                            ),
                          ),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

