import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/features/auth/screens/studentSignUp2.dart';



class StudentSignUpPage1 extends StatefulWidget {
  @override
  _StudentSignUpPageOneState createState() => _StudentSignUpPageOneState();
}

class _StudentSignUpPageOneState extends State<StudentSignUpPage1> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _givenNameController = TextEditingController();
  final TextEditingController _fathersNameController = TextEditingController();
  final TextEditingController _grandFathersNameController =
      TextEditingController();

  // Variables to store user input
  String? _selectedGender;

//
  // Regular expression for alphabetic validation
  final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');

  // Function to validate and proceed to next page
  void _validateAndProceed() {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
    String givenName = _givenNameController.text.trim();
    String fathersName = _fathersNameController.text.trim();
    String grandFathersName = _grandFathersNameController.text.trim();
    
      // Proceed to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StudentSignUpPage2(
                  givenName: givenName,
                  fathersName: fathersName,
                  grandFathersName: grandFathersName,
                  selectedGender: _selectedGender!,
                )), 
      );
    } else {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
      }
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
                  'images/signup.png', 
                  height: 150,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _givenNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Given Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your given name';
                    } else if (!_alphabetRegex.hasMatch(value)) {
                      return 'Only letters are allowed';
                    }
        
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fathersNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Father\'s Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s name';
                    } else if (!_alphabetRegex.hasMatch(value)) {
                      return 'Only letters are allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _grandFathersNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Grand Father\'s Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your grand father\'s name';
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
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Gender',
                  ),
                  items: ['Male', 'Female']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a gender';
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
                          onPressed: _validateAndProceed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(9, 19, 58, 1), // Blue-black background color
                            foregroundColor: Colors.white, // White text color
                            minimumSize: Size(150, 50), // Ensures consistent size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Slightly curved edges
                            ),
                          ),
                          child: const Text("NEXT"),
                        )

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

// class NextSignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Next Sign Up Page")),
//       body: const Center(
//         child: Text("This is the next page of the signup form."),
//       ),
//     );
//   }
// }
