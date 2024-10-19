import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'dart:io';

import 'package:yeneta_tutor/models/user_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel? user;
  EditProfilePage({this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
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

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _firstName = widget.user!.firstName;
      _middleName = widget.user!.fatherName;
      _lastName = widget.user!.grandFatherName;
      _email = widget.user!.email;
      _gender = widget.user!.gender;
      _phoneNumber = widget.user!.phoneNumber;
      _educationalQualification = widget.user!.educationalQualification ?? '';
      // _languageSpoken = (widget.user!.languageSpoken ?? '') as String?;
      _graduationDepartment = widget.user!.graduationDepartment;
      _bio = widget.user!.bio;
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Save profile updates
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedData = {
        'firstName': _firstName,
        'middleName': _middleName,
        'lastName': _lastName,
        'email': _email,
        'gender': _gender,
        'phoneNumber': _phoneNumber,
        'educationalQualification': _educationalQualification,
        'languageSpoken': _languageSpoken,
        'graduationDepartment': _graduationDepartment,
        'bio': _bio,
      };
      ref.read(authControllerProvider).updateUserProfile(
            uid: widget.user!.uid,
            profileData: updatedData,
            profilePic: _imageFile,
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
                              ? FileImage(
                                  _imageFile!) 
                              : (widget.user != null &&
                                      widget.user!.profileImage != null &&
                                      widget.user!.profileImage!.isNotEmpty)
                                  ? NetworkImage(widget.user!
                                      .profileImage!) 
                                  : NetworkImage(
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png") 
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
                            decoration:
                                InputDecoration(
                                  border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),labelText: "First Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter first name";
                              }
                              return null;
                            },
                            onSaved: (value) => _firstName = value,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _middleName,
                            decoration:
                                InputDecoration(
                                  border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    )
                                  ,labelText: "Middle Name"),
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter middle name";
                              }
                              return null;
                            },
                            onSaved: (value) => _middleName = value,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _lastName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    )
                              ,labelText: "Last Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter last name";
                              }
                              return null;
                            },
                            onSaved: (value) => _lastName = value,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _email,
                            decoration: InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),labelText: "Email"),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value,
                          ),SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    )
                              ,labelText: "Gender"),
                             validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select your gender";
                              }
                              return null;
                            },
                            items: ["Male", "Female"]
                                .map((gender) => DropdownMenuItem(
                                      child: Text(gender),
                                      value: gender,
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              _gender = value;
                            }),
                          ),SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _phoneNumber,
                            decoration:
                                InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),labelText: "Phone Number"),
                            keyboardType: TextInputType.phone,
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
                            onSaved: (value) => _phoneNumber = value,
                          ),SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: _educationalQualification,
                            decoration: InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
                                labelText: "Educational Qualification"),
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select your educational qualification";
                              }
                              return null;
                            },
                            items: ["BSc/BA", "MSc/MA", "PhD"]
                                .map((qual) => DropdownMenuItem(
                                      child: Text(qual),
                                      value: qual,
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              _educationalQualification = value;
                            }),
                          ),SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _languageSpoken,
                            decoration:
                                InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),labelText: "Language Spoken"),
                    validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter languages you speak";
                              }
                              return null;
                            },
                            onSaved: (value) => _languageSpoken = value,
                          ),SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _graduationDepartment,
                            decoration: InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),
                                labelText: "Graduation Department"),
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter graduation department";
                              }
                              return null;
                            },
                            onSaved: (value) => _graduationDepartment = value,
                          ),SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _bio,
                            decoration: InputDecoration(border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                    ),labelText: "Bio"),
                    validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a bio text";
                              }
                              return null;
                            },
                            maxLines: 4,
                            onSaved: (value) => _bio = value,
                          ),SizedBox(height: 16.0),
                          ElevatedButton(
                         onPressed: _saveProfile,
                         child: Text("Save Profile"),
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), 
                  textStyle: const TextStyle(fontSize: 18),
                               ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
