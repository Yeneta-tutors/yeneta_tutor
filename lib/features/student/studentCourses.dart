// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/student/studentDetailsPage.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class CoursesPage extends ConsumerStatefulWidget {
  final String subject;

  const CoursesPage({super.key, required this.subject});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  late Future<List<Course>> _coursesFuture;
  List<Course> _filteredCourses = [];
  String _searchQuery = '';
  int? _selectedGrade;
  int? _selectedChapter;
  bool _isFirstBuild = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      _coursesFuture = fetchCourseBySubject();
      _isFirstBuild = false;
    }
  }

  Future<List<Course>> fetchCourseBySubject() async {
    try {
      final courses = await ref
          .watch(courseControllerProvider)
          .fetchCourseBySubject(widget.subject);
      setState(() {
        _filteredCourses = _applyFiltersAndSearch(courses);
      });
      return courses;
    } catch (e) {
      print(e);
      throw Exception('Error getting courses by subject $e');
    }
  }

  List<Course> _applyFiltersAndSearch(List<Course> courses) {
    _filteredCourses = courses.where((course) {
      final matchesGrade =
          _selectedGrade == null || course.grade == _selectedGrade;
      final matchesChapter =
          _selectedChapter == null || course.chapter == _selectedChapter;
      final matchesSearch = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesGrade && matchesChapter && matchesSearch;
    }).toList();
    return _filteredCourses;
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => FilterDialog(
        selectedGrade: _selectedGrade,
        selectedChapter: _selectedChapter,
        onApplyFilters: (grade, chapter) {
          setState(() {
            _selectedGrade = grade;
            _selectedChapter = chapter;
          });
          _applyFiltersAndSearch(_filteredCourses);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Courses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            color: Colors.black,
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Column(
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
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                    _applyFiltersAndSearch(_filteredCourses);
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
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_filteredCourses.isEmpty) {
                    return Center(child: Text('No courses found'));
                  }

                  return GridView.builder(
                    itemCount: _filteredCourses.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      final teacherFuture = ref
                          .read(authControllerProvider)
                          .getUserData(course.teacherId);

                      return FutureBuilder<UserModel?>(
                        future: teacherFuture,
                        builder: (context, teacherSnapshot) {
                          if (teacherSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (teacherSnapshot.hasError ||
                              !teacherSnapshot.hasData) {
                            return SizedBox.shrink();
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
                                                    'images/maths_thumbnail.jpg'),
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
                                                '${course.rating}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
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

class FilterDialog extends StatefulWidget {
  final int? selectedGrade;
  final int? selectedChapter;
  final Function(int?, int?) onApplyFilters;

  FilterDialog(
      {this.selectedGrade, this.selectedChapter, required this.onApplyFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int? selectedGrade;
  int? selectedChapter;

  @override
  void initState() {
    super.initState();
    selectedGrade = widget.selectedGrade;
    selectedChapter = widget.selectedChapter;
  }

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
              items: [null, 9, 10, 11, 12].map((int? value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value == null ? 'All Grades' : 'Grade $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value;
                });
              },
            ),
            // Chapter Filter
            Text('Chapter'),
            DropdownButton<int>(
              value: selectedChapter,
              items: [null, ...List.generate(12, (index) => index + 1)]
                  .map((int? value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child:
                      Text(value == null ? 'All Chapters' : 'Chapter $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedChapter = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onApplyFilters(selectedGrade, selectedChapter);
            Navigator.of(context).pop();
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}
