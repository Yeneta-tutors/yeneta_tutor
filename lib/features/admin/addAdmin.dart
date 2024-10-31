import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/admin/dashboard_provider.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

class AddAdminPage extends ConsumerStatefulWidget {
  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends ConsumerState<AddAdminPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _givenNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _grandFatherNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp _alphabetRegex = RegExp(r'^[a-zA-Z]+$');
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  // Function to validate and submit the form
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider).signUpWithEmailAndPassword(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _givenNameController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        grandFatherName: _grandFatherNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        gender: _selectedGender!,
        educationalQualification: '',
        graduationDepartment: '',
        subject: '',
        bio: '',
        grade: '',
        role: UserRole.admin,
        profilePic: null,
      );

      // Show success snackbar
       showSnackBar(context, 'Admin added successfully');

      // Clear form fields
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _givenNameController.clear();
      _fatherNameController.clear();
      _grandFatherNameController.clear();
      _phoneNumberController.clear();
      setState(() {
        _selectedGender = null;
      });
   
    }
  }

  @override
  Widget build(BuildContext context) {
    final adimnCount = ref.watch(totalAdminsProvider);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('New Admin', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left container with the form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(_givenNameController, 'Given Name', Icons.person),
                      const SizedBox(height: 16),
                      _buildTextField(_fatherNameController, 'Father\'s Name', Icons.person),
                      const SizedBox(height: 16),
                      _buildTextField(_grandFatherNameController, 'Grand Father\'s Name', Icons.person),
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
                        validator: (value) => value == null ? 'Please select a gender' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_phoneNumberController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, 'Email', Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildPasswordField(_passwordController, 'Password'),
                      const SizedBox(height: 16),
                      _buildPasswordField(_confirmPasswordController, 'Confirm Password', isConfirm: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(9, 19, 58, 1),
                            foregroundColor: Colors.white,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Right container with admin count
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: adimnCount.when(
                    data: (admins) {
                    return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          value: _animation.value,
                          strokeWidth: 12,
                          color: Colors.green,
                        ),
                      ),

                      Text(
                        (_animation.value * admins).toInt().toString(),
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Positioned(
                        bottom: 70,
                        child: Text(
                          'Total Admins',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  );
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        } else if (!_alphabetRegex.hasMatch(value) && keyboardType == TextInputType.text) {
          return 'Only letters are allowed';
        }
        return null;
      },
    );
  }

  // Helper method to build password fields
  Widget _buildPasswordField(TextEditingController controller, String labelText, {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            (isConfirm ? _isConfirmPasswordVisible : _isPasswordVisible)
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              if (isConfirm) {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        } else if (!isConfirm && value.length < 6) {
          return '$labelText must be at least 6 characters';
        } else if (isConfirm && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}