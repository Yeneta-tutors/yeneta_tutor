import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/courses/screens/course_details.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

class TutorHomePageDemo extends ConsumerStatefulWidget {
  const TutorHomePageDemo({super.key});

  @override
  ConsumerState<TutorHomePageDemo> createState() => _TutorHomePageDemoState();
}

class _TutorHomePageDemoState extends ConsumerState<TutorHomePageDemo> {
  String searchQuery = '';
  String? selectedGrade;
  String? selectedSubject;
  String? selectedChapter;

  @override
  Widget build(BuildContext context) {
    final courseController = ref.watch(courseControllerProvider);
    final authcontroller = ref.read(authControllerProvider);

    final teacherId = authcontroller.getCurrentUserId();
    final teacherFuture = authcontroller.getUserData(teacherId);

    Future<List<Course>> coursesFuture() async {
      return await courseController.fetchCoursesByTeacherId();
    }

    Future<List<Course>> fetchFilteredCoursesFuture() async {
      try {
        if (selectedGrade != null &&
            selectedSubject != null &&
            selectedChapter != null) {
          final courses = await courseController.fetchFilteredCourses(
              selectedGrade!, selectedSubject!, selectedChapter!);
          if (courses.isEmpty) {
            if (mounted) {
              showSnackBar(
                  context, "No courses found for the selected filters.");
            }
            return [];
          }

          return courses;
        } else {
          print('One or more filters are null');
          return [];
        }
      } catch (e) {
        print('Error fetching filtered courses: $e');
        showSnackBar(context, "Error fetching courses.");
        return [];
      }
    }

    Future<List<Course>> searchCoursesFuture(String query) async {
      return await courseController.searchCourses(query);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and filter sections
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
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
                        backgroundImage: AssetImage('images/yeneta_logo.jpg'),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      FutureBuilder<UserModel?>(
                        future: teacherFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Error loading user data',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return const Text(
                              'User not found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            );
                          } else {
                            final teacher = snapshot.data!;
                            return Text(
                              'Welcome ${teacher.firstName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Handle notification icon press
                            },
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
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
                  const SizedBox(height: 20),

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
                      hintText: 'Filter my courses',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Categories text and filter icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => FilterDialog(
                              onApplyFilter: (grade, subject, chapter) {
                                setState(() {
                                  selectedGrade = grade;
                                  selectedSubject = subject;
                                  selectedChapter = chapter;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Most Subscribed Courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Course>>(
                future: searchQuery.isNotEmpty
                    ? searchCoursesFuture(searchQuery)
                    : (selectedGrade != null &&
                            selectedSubject != null &&
                            selectedChapter != null)
                        ? fetchFilteredCoursesFuture()
                        : coursesFuture(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No most subscribed courses found.'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final course = snapshot.data![index];
                      return CourseCard(
                        title: course.title,
                        subject: course.subject,
                        grade: course.grade,
                        chapter: course.chapter,
                        price: course.price.toString(),
                        thumbnail: course.thumbnail,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailsPage(
                                courseId: course.courseId,
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

            // My Courses Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'My Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: FutureBuilder<List<Course>>(
                future: searchQuery.isNotEmpty
                    ? searchCoursesFuture(searchQuery)
                    : (selectedGrade != null &&
                            selectedSubject != null &&
                            selectedChapter != null)
                        ? fetchFilteredCoursesFuture()
                        : coursesFuture(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No courses found.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final course = snapshot.data![index];
                      return MyCourseCard(
                        title: course.title,
                        subject: course.subject,
                        grade: course.grade,
                        chapter: course.chapter,
                        price: course.price.toString(),
                        thumbnail: course.thumbnail,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailsPage(
                                courseId: course.courseId,
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
          ],
        ),
      ),
    );
  }
}

class MyCourseCard extends StatelessWidget {
  final String title;
  final String subject;
  final String chapter;
  final String grade;
  final String price;
  final String? thumbnail;
  final VoidCallback onPressed;

  const MyCourseCard({
    super.key,
    required this.title,
    required this.chapter,
    required this.grade,
    required this.subject,
    required this.price,
    required this.thumbnail,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 85, 80, 80).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: thumbnail != null && thumbnail!.isNotEmpty
                  ? Image.network(
                      thumbnail!,
                      fit: BoxFit.cover,
                      height: 120,
                      width: 120, // Fix the size here
                    )
                  : Image.asset(
                      'images/yeneta_logo.jpg',
                      fit: BoxFit.cover,
                      height: 120, // Provide fixed height and width
                      width: 120, // instead of double.infinity
                    ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "Grade: $grade",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Chapter: $chapter',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$price Birr',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String subject;
  final String chapter;
  final String grade;
  final String price;
  final String? thumbnail;
  // final double rating;
  // final int studentCount;
  final VoidCallback onPressed;

  const CourseCard({
    super.key,
    required this.title,
    required this.subject,
    required this.chapter,
    required this.grade,
    required this.price,
    required this.thumbnail,
    // required this.studentCount,
    // required this.rating,
    required this.onPressed,
  });
//ANLCZZ    3525
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
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
                      width: 180,
                    )
                  : Image.asset(
                      'images/yeneta_logo.jpg',
                      fit: BoxFit.cover,
                      width: 180,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Grade $grade',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Chapter:$chapter'), SizedBox(width: 10),
                      Text('Price: $price birr'),
                      // Text('Grade $grade'),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Icon(Icons.star, color: Colors.green, size: 16),
                  //     Text(
                  //       '$rating ($studentCount stud.)',
                  //       style: TextStyle(color: Colors.green),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Updated FilterDialog with callback

class FilterDialog extends StatefulWidget {
  final Function(String? grade, String? subject, String? chapter) onApplyFilter;

  const FilterDialog({required this.onApplyFilter, Key? key}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedGrade;
  String? selectedSubject;
  String? selectedChapter;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Courses'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grade'),
            DropdownButton<String>(
              value: selectedGrade,
              hint: const Text('Select Grade'),
              items: ['9', '10', '11', '12'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGrade = newValue; // Update the selected value
                });
              },
            ),
            const Text('Subject'),
            DropdownButton<String>(
              value: selectedSubject,
              hint: const Text('Select Subject'),
              items: ['Math', 'English', 'Physics', 'Chemistry']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue; // Update the selected value
                });
              },
            ),
            const Text('Chapter'),
            DropdownButton<String>(
              value: selectedChapter,
              hint: const Text('Select Chapter'),
              items: ['1', '2', '3', '4'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedChapter = newValue; // Update the selected value
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Ensure null values are handled before applying the filter
            widget.onApplyFilter(
              selectedGrade, // No fallback needed; just pass the selected value
              selectedSubject,
              selectedChapter,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
