import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/studentDetailsPage.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class CoursesPage extends ConsumerStatefulWidget {
  final String subject;

  const CoursesPage({super.key, required this.subject});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    final courseControler = ref.watch(courseControllerProvider);

    Future<List<Course>> fetchCourseBySubject() async {
      try {
        return await courseControler.fetchCourseBySubject(widget.subject);
      } catch (e) {
        throw Exception('Error getting course by  subject');
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
          'Courses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              // Open filter dialog
              showDialog(
                context: context,
                builder: (_) => FilterDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
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

          // Course cards grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<Course>>(
                future: fetchCourseBySubject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No subjects found'));
                  }

                  final courses = snapshot.data!;
                  return GridView.builder(
                    itemCount: courses.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
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
                            return Text("Loading"); // Show loading state for teacher data
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
                                  builder: (context) => CourseDetailsPage(
                                    courseId: course.courseId,
                                  ),
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
                                        // Course image with rounded corners
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
                                        // Grade text (bottom left corner)
                                        Positioned(
                                          bottom: 5,
                                          left: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                  0.7), // Black background with opacity
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Grade ${course.grade}', // Dynamic grade text
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        // Chapter text (bottom right corner)
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                  0.7), // Black background with opacity
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Chapter ${course.chapter}', // Dynamic chapter text
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
                                            course.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'images/maths_thumbnail.jpg'), // Tutor profile image
                                                radius: 12,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                teacher.firstName,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(Icons.star,
                                                  color: Colors.yellow[700],
                                                  size: 16),
                                              SizedBox(width: 3),
                                              Text(
                                                course.rating.toString() ??
                                                    '0.0',
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              Text(
                                                'Num of Std',
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                '${course.price} Birr',
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                  );
                },
              ),
            ),
          ),
        ],
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
  // String priceOrder = 'Cheaper to Expensive';
  // bool mostSold = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Courses'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              dropdownColor:
                  Colors.grey[200], // Customize dropdown background color
              icon:
                  Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
              iconSize: 20,
              menuMaxHeight: 200,
            ),

            // Price Filter
            // Text('Price'),
            // DropdownButton<String>(
            //   value: priceOrder,
            //   items: ['Cheaper to Expensive', 'Expensive to Cheaper'].map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       priceOrder = value!;
            //     });
            //   },
            // ),

            // Most Sold Filter
            // CheckboxListTile(
            //   title: Text('Most Sold'),
            //   value: mostSold,
            //   onChanged: (value) {
            //     setState(() {
            //       mostSold = value!;
            //     });
            //   },
            // ),
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








// // Dummy CourseDetail Page
// class CourseDetail extends StatelessWidget {
//   final Map<String, dynamic> course;

//   CourseDetail({required this.course});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(course['title']),
//       ),
//       body: Center(
//         child: Text(
//           'Details for ${course['title']}',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
