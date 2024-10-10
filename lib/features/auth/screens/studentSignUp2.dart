import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';

class StudentSignUpPage2 extends ConsumerStatefulWidget {
    final String givenName;
  final String fathersName;
  final String grandFathersName;
  final String selectedGender;

  const StudentSignUpPage2({
    required this.givenName,
    required this.fathersName,
    required this.grandFathersName,
    required this.selectedGender,
  });

  @override
  _StudentSignUpPageTwoState createState() => _StudentSignUpPageTwoState();
}

class _StudentSignUpPageTwoState extends ConsumerState<StudentSignUpPage2> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGrade;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Variables from the first pageofile picture if implemented

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve data passed from the first sign-up page, if necessary
  }

  // Function to validate and submit the form
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-up using the AuthController
    ref.read(authControllerProvider).signUpWithEmailAndPassword(
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            firstName: widget.givenName,
            fatherName: widget.fathersName,
            grandFatherName: widget.grandFathersName,
            phoneNumber: _phoneNumberController.text.trim(),
            gender: widget.selectedGender,
            grade: _selectedGrade!,
            role: UserRole.student, // Assuming a fixed role for student
            profilePic: null, // Add profile picture if implemented
        );
    
        // This ensures that you navigate only if the sign-up is successful.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
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

                // Phone Number
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('+251', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
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

                // Grade Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                    prefixIcon: Icon(Icons.school),
                  ),
                  items: ['9', '10', '11', '12']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGrade = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your grade';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
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

                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
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

                // Submit Button
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform any action you want here
          },
          child: const Text("Go to Profile"),
        ),
      ),
    );
  }
}