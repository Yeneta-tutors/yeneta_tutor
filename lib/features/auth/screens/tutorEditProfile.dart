import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _email;
  String? _gender;
  String? _phoneNumber;
  String? _educationalQualification;
  String? _languageSpoken;
  String? _graduationDepartment;
  String? _bio;

  // Dummy data fetch simulation
  void fetchData() {
    // Simulate fetched data from the database
    setState(() {
      _firstName = "John";
      _middleName = "Doe";
      _lastName = "Smith";
      _email = "john@example.com";
      _gender = "Male";
      _phoneNumber = "1234567890";
      _educationalQualification = "BSc/BA";
      _languageSpoken = "English";
      _graduationDepartment = "Computer Science";
      _bio = "Passionate educator with 5 years of experience...";
    });
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        title: Text("Edit Profile"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    Text("BASIC INFO"),
                    SizedBox(height: 16.0),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : AssetImage("images/yeneta_logo.jpg") // Placeholder for fetched image
                                  as ImageProvider,
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _pickImage,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _firstName,
                            decoration: InputDecoration(labelText: "First Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter first name";
                              }
                              return null;
                            },
                            onSaved: (value) => _firstName = value,
                          ),
                          TextFormField(
                            initialValue: _middleName,
                            decoration: InputDecoration(labelText: "Middle Name"),
                            onSaved: (value) => _middleName = value,
                          ),
                          TextFormField(
                            initialValue: _lastName,
                            decoration: InputDecoration(labelText: "Last Name"),
                            onSaved: (value) => _lastName = value,
                          ),
                          TextFormField(
                            initialValue: _email,
                            decoration: InputDecoration(labelText: "Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value,
                          ),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(labelText: "Gender"),
                            items: ["Male", "Female"]
                                .map((gender) => DropdownMenuItem(
                                      child: Text(gender),
                                      value: gender,
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              _gender = value;
                            }),
                          ),
                          TextFormField(
                            initialValue: _phoneNumber,
                            decoration: InputDecoration(labelText: "Phone Number"),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }
                              return null;
                            },
                            onSaved: (value) => _phoneNumber = value,
                          ),
                          DropdownButtonFormField<String>(
                            value: _educationalQualification,
                            decoration: InputDecoration(labelText: "Educational Qualification"),
                            items: ["BSc/BA", "MSc/MA", "PhD"]
                                .map((qual) => DropdownMenuItem(
                                      child: Text(qual),
                                      value: qual,
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              _educationalQualification = value;
                            }),
                          ),
                          TextFormField(
                            initialValue: _languageSpoken,
                            decoration: InputDecoration(labelText: "Language Spoken"),
                            onSaved: (value) => _languageSpoken = value,
                          ),
                          TextFormField(
                            initialValue: _graduationDepartment,
                            decoration: InputDecoration(labelText: "Graduation Department"),
                            onSaved: (value) => _graduationDepartment = value,
                          ),
                          TextFormField(
                            initialValue: _bio,
                            decoration: InputDecoration(labelText: "Bio"),
                            maxLines: 4,
                            onSaved: (value) => _bio = value,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save data to the database here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully')),
                  );
                }
              },
              child: Text("Save Profile"),
            ),
          ),
        ],
      ),
    );
  }
}
