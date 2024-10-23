import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _oldPassword;
  String? _newPassword;
  String? _confirmPassword;

  // Controllers for managing input text
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _confirmPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "Please confirm new password";
    }
    if (value != _newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authController = ref.read(authControllerProvider);
      authController.updatePassword(
        email: authController
            .getCurrentUser()!
            .email!, 
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        context: context,
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
        title: Text("Password Reset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Old Password
              TextFormField(
                controller: _oldPasswordController,
                obscureText: !_oldPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
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
                  return null;
                },
                onSaved: (value) => _oldPassword = value,
              ),

              SizedBox(height: 16.0),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_newPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
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
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
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
                validator: _confirmPasswordValidator,
                onSaved: (value) => _confirmPassword = value,
              ),

              SizedBox(height: 32.0),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), 
                  textStyle: const TextStyle(fontSize: 18), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
