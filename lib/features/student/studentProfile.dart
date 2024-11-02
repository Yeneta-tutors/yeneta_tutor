import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/common/settingspage.dart';
import 'package:yeneta_tutor/features/student/studentEditProfile.dart';
import 'package:yeneta_tutor/features/common/tutorPasswordReset.dart';

class studentProfile extends ConsumerWidget {
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
              // Handle settings button functionality
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: userData.when(
        data: (user) => Column(
          children: [
            // Curved blue-black background section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 9, 19, 58), // Blue-black color
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: user?.profileImage != null
                        ? AssetImage(user!.profileImage!)
                        : AssetImage(
                            'images/yeneta_logo.jpg',
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80), // Padding between image and name
            Text(
              user!.firstName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40), // Padding between name and buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Edit Profile button
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(
                              255, 9, 19, 58), // Blue-black color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Handle Edit Profile functionality
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentEditProfilePage(user: user)),
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
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Space between buttons
                  // Change Password button
                  Expanded(
                    child: SizedBox(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Color.fromARGB(
                                  255, 9, 19, 58)), // Blue-black color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Handle password reset
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                              color: Color(0xFF1A237E), // Blue-black text color
                              fontSize: 12,
                              overflow: TextOverflow
                                  .ellipsis, // Prevent text wrapping
                            ),
                          ),
                        ),
                      ),
                    ),
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
