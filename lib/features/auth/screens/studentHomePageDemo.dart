import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/screens/studentCourses.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';

class StudentHomePageDemo extends ConsumerStatefulWidget {
  @override
  ConsumerState<StudentHomePageDemo> createState() =>
      _StudentHomePageDemoState();
}

class _StudentHomePageDemoState extends ConsumerState<StudentHomePageDemo> {
  String searchQuery = '';

  final Map<String, String> courseImages = {
    "Maths": 'images/maths_thumbnail.jpg',
    "Physics": 'images/physics_thumbnail.png',
    "Chemistry": 'images/chemistry_thumbnail.png',
    "Biology": 'images/biology_thumbnail.png',
    "History": 'images/history_thumbnail.png',
    "Geography": 'images/geography_thumbnail.png',
    "ICT": 'images/ict_thumbnail.png',
    "Economics": 'images/economics_thumbnail.png',
  };

  @override
  Widget build(BuildContext context) {
    final CourseController = ref.read(courseControllerProvider);

    Future<List<String>> searchCoursesFuture(String query) async {
      List<Course> courses = await CourseController.searchCourses(query);
      return courses.map((course) => course.subject).toList();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue-black container from the top to the Categories section
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF0D1B2A), // Blue-black color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header section with profile image, welcome text, and bell icon
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              'images/yeneta_logo.jpg'), // Placeholder image
                          radius: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Welcome Alex', // first name of the tutor fetched from the database
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            // Red icon when there's a new message
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Search bar section
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Find Courses',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Categories text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Courses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // FutureBuilder to fetch subjects
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<String>>(
                  future: searchQuery.isNotEmpty
                    ? searchCoursesFuture(searchQuery):
                  CourseController.fetchUniqueSubjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No subjects found'));
                    }

                    final subjects = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap:
                          true, // Important to avoid GridView taking full screen
                      physics:
                          NeverScrollableScrollPhysics(), // Avoid scrolling inside GridView
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200, // Maximum width per card
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio:
                            166 / 167, // Aspect ratio of the card (fixed size)
                      ),
                      itemCount: subjects
                          .length, // Number of cards based on fetched subjects
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoursesPage(
                                  subject: subject,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.asset(
                                      courseImages[subject] ??
                                          'images/yeneta_logo.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
