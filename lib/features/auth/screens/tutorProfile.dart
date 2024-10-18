import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/settingspage.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorEditProfile.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorPasswordReset.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: userData.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile photo section
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.profileImage != null
                    ? NetworkImage(user!.profileImage!)
                    : NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with your image url
              ),
              const SizedBox(height: 16),

              Text(
                "${user?.firstName ?? 'Unknown'} ${user?.fatherName ?? ''} ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Description section
              Text(
                user?.bio != null && user!.bio!.isNotEmpty
                    ? user.bio!
                    : 'Passionate educator with 5 years of experience tutoring high school and college students in STEM subjects.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Row for Edit Profile and Change Password Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the edit profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(user: user),
                          ),
                        );
                      },
                      child: Text('EDIT PROFILE'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the change password page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(),
                          ),
                        );
                      },
                      child: Text('CHANGE PASSWORD'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error loading profile'),
      ),
    );
  }
}

// Dummy Settings Page
