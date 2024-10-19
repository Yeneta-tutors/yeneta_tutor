import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';

class TutorProfileForStudents extends ConsumerWidget {
  String teacherId;
  TutorProfileForStudents(this.teacherId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherDataFuture =
        ref.read(authControllerProvider).getUserData(teacherId);
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
      ),
      body: FutureBuilder(
        future: teacherDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teacher = snapshot.data;
            return Column(
              children: [
                // Curved blue-black background section
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 9, 19, 58), // Blue-black color
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
                        backgroundImage: teacher!.profileImage != null
                            ? AssetImage(teacher.profileImage!)
                            : AssetImage(
                                'images/yeneta_logo.jpg', // Replace with actual image
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50), // Padding between image and name
                Text(
                  teacher!.firstName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text("A teacher with 5 years of experiance")
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
