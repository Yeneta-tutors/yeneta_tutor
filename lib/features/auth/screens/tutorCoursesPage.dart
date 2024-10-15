import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/courses/screens/course_details.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorHomePage.dart';
import 'package:yeneta_tutor/features/courses/screens/course_upload.dart';
import 'package:yeneta_tutor/models/course_model.dart';

class CoursesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseController = ref.watch(courseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('COURSES'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorHomePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<Course>>(
        future: courseController.fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching courses'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message but keep the FAB
            return Stack(
              children: [
                Center(child: Text('No courses available')),
                Positioned(
                  bottom: 50,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseUploadPage(),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            );
          }

          final courses = snapshot.data!;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (BuildContext ctx, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailsPage(
                              courseId: course.courseId, // Pass the courseId
                            ),
                          ),
                        );
                      },
                      child: CourseCard(
                          courseId: course.courseId,
                          courseTitle: course.title,
                          thumbnail: course.thumbnail),
                    );
                  },
                ),
              ),
              // Floating action button remains here
              Positioned(
                bottom: 50,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseUploadPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String? thumbnail;

  const CourseCard({
    required this.courseId,
    required this.courseTitle,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4, // Adds shadow behind the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: thumbnail != null && thumbnail!.isNotEmpty
                ? Image.network(
                    thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Image.asset(
                    'images/yeneta_logo.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('Duration: 1hr'),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.green, size: 16),
                    Text('4.5 (200)', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
