import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  
  String? _oldPassword;
  String? _newPassword;
  String? _confirmPassword;

  //  old password for validation simulation
  String storedOldPassword = "1234567"; 

  // Validate old password
  bool _validateOldPassword(String value) {
    return value == storedOldPassword; // Replace with actual password checking logic
  }

  // Function to check if passwords match
  String? _confirmPasswordValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Please confirm new password";
    }
    if (value != _newPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Replace old password with the new password in the database
      setState(() {
        storedOldPassword = _newPassword!;
      });

      // Show success popup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Yeneta Tutors"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Old Password
              TextFormField(
                obscureText: !_oldPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _oldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter old password";
                  }
                  if (!_validateOldPassword(value)) {
                    return "Old password is incorrect";
                  }
                  return null;
                },
                onSaved: (value) => _oldPassword = value,
              ),
              
              SizedBox(height: 16.0),

              // New Password
              TextFormField(
                obscureText: !_newPasswordVisible,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter new password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
                onSaved: (value) => _newPassword = value,
              ),
              
              SizedBox(height: 16.0),

              // Confirm New Password
              TextFormField(
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm new password";
                  }
                  if (value != _newPassword) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value,
              ),

              SizedBox(height: 32.0),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
