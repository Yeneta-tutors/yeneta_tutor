import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/settingspage.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorEditProfile.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorPasswordReset.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataAuthProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 19, 58),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile',
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings,
                color: const Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: userData.when(
        data: (user) => Stack(
          children: [
            // Curved blue-black background section
            Container(
              height: 140, // Adjusted height to cover half the avatar
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 9, 19, 58), // Blue-black color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            // Profile content
            Padding(
              padding: const EdgeInsets.only(
                  top: 70, left: 16, right: 16), // Adjusted top padding
              child: Column(
                children: [
                  // Profile photo section
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
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
                          style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 9, 19, 58), // Blue-black color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                          onPressed: () {
                            // Navigate to the edit profile page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(user: user),
                              ),
                            );
                          },
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "EDIT PROFILE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                  child: SizedBox(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromARGB(255, 9, 19, 58)), // Blue-black color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
              // Handle password reset
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()),
              );
            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "CHANGE PASSWORD",
                          style: TextStyle(
                            color: Color(0xFF1A237E), // Blue-black text color
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis, // Prevent text wrapping
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error loading profile'),
      ),
    );
  }
}
