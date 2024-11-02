import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/admin/courseDetail.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class UserProfile extends ConsumerWidget {
  String userId;
  UserProfile({super.key, required this.userId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataFuture = ref.read(authControllerProvider).getUserData(userId);
    final userStream = ref.watch(userDataAuthProvider);
    final courseController = ref.watch(courseControllerProvider);
    final subscriptionController = ref.watch(subscriptionControllerProvider);
    final userStatistics = ref.watch(userStatisticsProvider);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('User Management > Profile student'),
          backgroundColor: Colors.grey[850],
          actions: [
            userStream.when(
              data: (user) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Row(
                    children: [
                      Text('Hello, ${user!.firstName}',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : AssetImage('images/avatar_image.png')
                                as ImageProvider, // Admin image
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
        body: FutureBuilder(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Details Container
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(user!
                                          .profileImage ??
                                      'images/avator_image.png'), // User image here
                                ),
                                Positioned(
                                  bottom: -20,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Name: ${user.firstName} ${user.fatherName}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Gender: ${user.gender}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Email: ${user.email}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Phone: 0${user.phoneNumber}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Grade: ${user.grade ?? 'Not specified'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .watch(authControllerProvider)
                                    .blockUser(userId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // Button background color
                                minimumSize: Size(
                                    200, 50), // Set minimum width and height
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15), // Padding inside the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Small border radius for rectangular shape
                                ),
                              ),
                              child: Text(
                                'Block User',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors
                                        .white), // Larger font size for the button text
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Subscribed Courses Container
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Search bar and filter
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search here',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.filter_list),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // Fetch and display courses based on user role
                          Expanded(
                            child: FutureBuilder(
                              future: user.role == UserRole.student
                                  ? subscriptionController
                                      .fetchSubscribedCourses(userId)
                                  : courseController
                                      .fetchCoursesByTeacherId(userId),
                              builder: (context, courseSnapshot) {
                                if (courseSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (courseSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${courseSnapshot.error}'));
                                } else if (courseSnapshot.hasData) {
                                  final courses = courseSnapshot.data;
                                  return GridView.builder(
                                    padding: EdgeInsets.all(16),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: courses!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminCourseDetails(
                                                      courseId: courses[index]
                                                          .courseId), // Pass the courseId
                                            ),
                                          );
                                        },
                                        child:
                                            CourseCard(course: courses[index]),
                                      );
                                    },
                                  );
                                }
                                return Center(
                                    child: Text('No courses available'));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    // Bar Chart Container
                    Expanded(
                      flex: 2,
                      child: userStatistics.when(
                        data: (stats) {
                          int totalUsers =
                              stats.values.fold(0, (a, b) => a + b);

                          return Column(
                            children: [
                              Text(
                                'Users',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        color: Colors.blue,
                                        value: (stats[UserRole.student]! /
                                                totalUsers) *
                                            100, // Change to your dynamic value
                                        title: '${stats[UserRole.student]}',
                                        radius: 30,
                                      ),
                                      PieChartSectionData(
                                        color: Colors.red,
                                        value: (stats[UserRole.tutor]! /
                                                totalUsers) *
                                            100, // Change to your dynamic value
                                        title: '${stats[UserRole.tutor]}',
                                        radius: 30,
                                      ),
                                      PieChartSectionData(
                                        color: Colors.green,
                                        value: (stats[UserRole.admin]! /
                                                totalUsers) *
                                            100, // Change to your dynamic value
                                        title: '${stats[UserRole.admin]}',
                                        radius: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildIndicator(
                                    color: Colors.blue,
                                    text: 'Student',
                                    percentage:
                                        '${((stats[UserRole.student]! / totalUsers) * 100).toStringAsFixed(1)}%',
                                  ),
                                  _buildIndicator(
                                    color: Colors.red,
                                    text: 'Tutor',
                                    percentage:
                                        '${((stats[UserRole.tutor]! / totalUsers) * 100).toStringAsFixed(1)}%',
                                  ),
                                  _buildIndicator(
                                    color: Colors.green,
                                    text: 'Admin',
                                    percentage:
                                        '${((stats[UserRole.admin]! / totalUsers) * 100).toStringAsFixed(1)}%',
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (err, stack) => Text('Error: $err'),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text('No data available'));
          },
        ));
  }
}

Widget _buildIndicator(
    {required Color color, required String text, required String percentage}) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        color: color,
      ),
      SizedBox(width: 5),
      Text('$text ($percentage)'),
    ],
  );
}

class CourseCard extends ConsumerWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch teacher's data
    final teacherFuture =
        ref.read(authControllerProvider).getUserData(course.teacherId);

    return FutureBuilder(
      future: teacherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final teacher = snapshot.data!;

          return Container(
            width: 300, // Fixed width
            height: 350, // Fixed height
            margin: EdgeInsets.all(8), // Margin around the card
            decoration: BoxDecoration(
              color: Colors.green[100], // Background color of the card
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section for the course image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/yeneta_logo.jpg', // Replace with the course image
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Grade ${course.grade}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Chapter ${course.chapter}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Course Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Tutor Info, Rating, and Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      // Teacher Image
                      CircleAvatar(
                        backgroundImage: teacher.profileImage != null
                            ? NetworkImage(teacher.profileImage!)
                            : AssetImage('images/avatar_image.png')
                                as ImageProvider,
                        radius: 20,
                      ),
                      SizedBox(width: 8),
                      // Teacher Name and Rating
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teacher.firstName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('Rating ${course.rating}')
                          // Optional: Add rating or any other teacher-specific info here
                        ],
                      ),
                      Spacer(),
                      // Course Price
                      Text(
                        '${course.price} Birr',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: Text('No teacher data available'));
      },
    );
  }
}

class SubjectIndicator extends StatelessWidget {
  final Color color;
  final String subject;
  final int count;

  SubjectIndicator(
      {required this.color, required this.subject, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: color,
        ),
        SizedBox(height: 4),
        Text('$subject ($count)'),
      ],
    );
  }
}
