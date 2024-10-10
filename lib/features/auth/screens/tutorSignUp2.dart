import 'package:flutter/material.dart';


class TutorSignUpPage2 extends StatefulWidget {
  @override
  _TutorSignUpPageTwoState createState() => _TutorSignUpPageTwoState();
}

class _TutorSignUpPageTwoState extends State<TutorSignUpPage2> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _graduationDepartmentController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
      final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // Variables to store user input
  String? _selectedEducationalQualification;
  String? _selectedSubject;
   bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Regular expression for alphabetic validation
  final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');

  // Function to validate and proceed to next page
  void _validateAndProceed() {
    if (_formKey.currentState!.validate() &&
        _selectedEducationalQualification != null &&
        _selectedSubject != null) {
      // Proceed to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorSignUpPage2(),
        ),
      );
    } else {
      if (_selectedEducationalQualification == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your educational qualification')),
        );
      } else if (_selectedSubject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a subject')),
        );
      }
    }
  }

// Function to validate and submit the form
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Proceed with form submission or sending data to the database
      // Example: sending to Firebase or your backend
      print('Form submitted successfully');
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                //email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
               
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.person),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                ),

                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                      child: const Text("Back"),
                    ),
                   ElevatedButton(
                      onPressed: _validateAndSubmit,
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to login page
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