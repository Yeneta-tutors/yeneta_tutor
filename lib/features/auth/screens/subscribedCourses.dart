import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/studentDetailsPage.dart';
import 'package:yeneta_tutor/features/auth/screens/subscribedCoursesVideoPlayer.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class SubscribedCourses extends ConsumerWidget {
  SubscribedCourses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptonController = ref.watch(subscriptionControllerProvider);
    final studentId = ref.watch(authControllerProvider).getCurrentUserId();

    Future<List<Course>> fetchSubscribedCourses(String studentId) async {
      try {
        final courses =
            await subscriptonController.fetchSubscribedCourses(studentId);
        return courses;
      } catch (error) {
        throw Exception('Failed to fetch subscribed courses');
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Subscribed Courses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => FilterDialog(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: fetchSubscribedCourses(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if fetching fails
            return Center(child: Text('Failed to load courses'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message if no courses are found
            return Center(child: Text('No subscribed courses found'));
          }

          // Courses are successfully fetched
          final courses = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Filter my courses',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: courses.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final teacherFuture = ref
                          .read(authControllerProvider)
                          .getUserData(course.teacherId);

                      return FutureBuilder<UserModel?>(
                        future: teacherFuture,
                        builder: (context, teacherSnapshot) {
                          if (teacherSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                                "Loading"); // Show loading state for teacher data
                          } else if (teacherSnapshot.hasError) {
                            return Text('Error loading teacher data');
                          } else if (!teacherSnapshot.hasData) {
                            return Text('No teacher data available');
                          }

                          final teacher = teacherSnapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubscribedCoursesVideoPlayer(
                                          courseId: course.courseId),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: course.thumbnail != null &&
                                                  course.thumbnail!.isNotEmpty
                                              ? Image.asset(
                                                  course.thumbnail!,
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'images/yeneta_logo.jpg',
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          left: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Grade ${course.grade}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Chapter ${course.chapter}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            course.title, // Course title
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    teacher.profileImage!),
                                                radius: 12,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                teacher
                                                    .firstName, // Instructor name
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(Icons.star,
                                                  color: Colors.yellow[700],
                                                  size: 16),
                                              SizedBox(width: 3),
                                              Text(
                                                '${course.rating ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FutureBuilder<int>(
                                                future: ref
                                                    .read(
                                                        subscriptionControllerProvider)
                                                    .getTotalSubscribersForCourse(
                                                        course.courseId),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text('Loading...');
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text('Error');
                                                  } else if (snapshot.hasData) {
                                                    return Text(
                                                      ' ${snapshot.data} students',
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Colors.grey[700],
                                                      ),
                                                    );
                                                  } else {
                                                    return Text('No data');
                                                  }
                                                },
                                              ),
                                              Text(
                                                '${course.price} Birr',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
              ),
            ],
          );
        },
      ),
    );
  }
}

// Filter Dialog
class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int selectedGrade = 9;
  int selectedChapter = 1;
  String selectedSubject = 'Maths';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Courses'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subject'),
            DropdownButton<String>(
              value: selectedSubject,
              hint: const Text('Select Subject'),
              items: [
                'Maths',
                'English',
                'Physics',
                'Biology',
                'Chemistry',
                'Economics',
                'Information Technology'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  // selectedSubject = newValue; // Update the selected value
                });
              },
              isExpanded: false,
              dropdownColor: Colors.grey[200],
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              menuMaxHeight: 200,
            ),
            // Grade Filter
            Text('Grade'),
            DropdownButton<int>(
              value: selectedGrade,
              items: [9, 10, 11, 12].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Grade $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value!;
                });
              },
            ),

            // Chapter Filter
            Text('Chapter'),
            DropdownButton<int>(
              value: selectedChapter,
              items: List.generate(12, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Chapter $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedChapter = value!;
                });
              },
              isExpanded: false,
              dropdownColor: Colors.grey[200],
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              menuMaxHeight: 200,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Apply filter logic and close dialog
            Navigator.of(context).pop();
          },
          child: Text('Search'),
        ),
      ],
    );
  }
}

// Note: Make sure CourseDetailsPage is defined somewhere else in your code.
