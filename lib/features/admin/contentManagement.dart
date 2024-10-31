import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/admin/admin_sidebar.dart';
import 'package:yeneta_tutor/features/admin/courseDetail.dart';
import 'package:yeneta_tutor/features/admin/dashboard_provider.dart';
import 'package:yeneta_tutor/features/admin/userProfile.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class ContentManagementPage extends ConsumerStatefulWidget {
  @override
  _ContentManagementPageState createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends ConsumerState<ContentManagementPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _searchController = TextEditingController();
  String selectedGrade = 'All';

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for 2 seconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Tween animation for the pie chart assembling
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation on page load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStream = ref.watch(userDataAuthProvider);
    final courseData = ref.watch(allCoursesProvider);
    final courseStatistics = ref.watch(courseCountByGradeProvider);

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 242, 247, 1),
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        title: Text(
          'Content Management',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          userStream.when(
            data: (user) => Row(
              children: [
                Text(
                  user != null ? 'Hello, ${user.firstName}' : 'Hello, User',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: user != null && user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : AssetImage('images/avatar_image.png') as ImageProvider,
                ),
              ],
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ],
        backgroundColor: Color.fromRGBO(9, 19, 58, 1),
        elevation: 0,
      ),
      drawer: Sidebar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Left section: Search bar, Filter, and Table
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Search bar and Filter in the same container as table
                            _buildSearchAndFilterBar(),
                            SizedBox(height: 10),
                            _buildUserTable(courseData), // User table
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Right section: Charts
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildDonutChart(courseStatistics), // Users chart
                            SizedBox(height: 20),
                            _buildGradeChart(), // Students chart with animation
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Search and Filter Bar
  Widget _buildSearchAndFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Courses',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Container(
              width: 250,
              height: 40,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Find course by name',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  contentPadding: EdgeInsets.all(1),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(width: 40),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedGrade = value;
                });
              },
              icon: Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                PopupMenuItem<String>(
                  value: '9', // 'Student'
                  child: Text('Grade 9'),
                ),
                PopupMenuItem<String>(
                  value: '10', // 'Tutor'
                  child: Text('Grade 10'),
                ),
                PopupMenuItem<String>(
                  value: '11', // 'Admin'
                  child: Text('Grade 11'),
                ),
                PopupMenuItem<String>(
                  value: '12', // 'Admin'
                  child: Text('Grade 12'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget for the User Table
  Widget _buildUserTable(AsyncValue<List<Course>> courseData) {
    return courseData.when(
      data: (courses) {
        final searchTerm = _searchController.text.toLowerCase();
        final filteredCourses = courses.where((course) {
          final matchesGrade =
              selectedGrade == 'All' || course.grade == selectedGrade;
          final matchesSearch = course.title.toLowerCase().contains(searchTerm);
          return matchesGrade && matchesSearch;
        }).toList();
        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('ID',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Title',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Subject',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Grade',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('price',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('View Details',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: filteredCourses.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final course = entry.value;
                return DataRow(cells: [
                  DataCell(Text("$index")),
                  DataCell(Text(course.title)),
                  DataCell(Text(course.subject)),
                  DataCell(Text(course.grade)),
                  DataCell(Text('${course.price}')),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminCourseDetails(courseId: course.courseId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 158, 250, 161),
                        minimumSize: Size(50, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 116, 111, 111),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text('View Details'),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Failed to load users: $error')),
    );
  }

  // Widget for Donut Chart
Widget _buildDonutChart(AsyncValue<Map<String, int>> courseStatistics) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: courseStatistics.when(
      data: (stats) {
        int totalCourses = stats.values.fold(0, (a, b) => a + b);

        return Column(
          children: [
            Text(
              'Courses by Grade',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: stats.entries.map((entry) {
                    String grade = entry.key;
                    int count = entry.value;
                    double percentage = (count / totalCourses) * 100;

                    return PieChartSectionData(
                      color: _getGradeColor(grade), // Define colors per grade
                      value: percentage,
                      title: '$grade: $count',
                      radius: 30,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats.entries.map((entry) {
                String grade = entry.key;
                int count = entry.value;
                double percentage = (count / totalCourses) * 100;

                return _buildIndicator(
                  color: _getGradeColor(grade),
                  text:  grade,
                  percentage: '${percentage.toStringAsFixed(1)}%',
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    ),
  );
}
Color _getGradeColor(String grade) {
  switch (grade) {
    case '9':
      return Colors.blue;
    case '10':
      return Colors.red;
    case '11':
      return Colors.green;
    case '12':
      return Colors.yellow;
    default:
      return Colors.grey; // Fallback color for other grades
  }
}


  // Widget for Grade Chart with animation
  Widget _buildGradeChart() {
    final gradeStudents = ref.watch(gradeStudentsProvider);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: gradeStudents.when(
            data: (gradeData) {
              int totalStudents = gradeData.values.fold(0, (a, b) => a + b);
              return Column(
                children: [
                  Text(
                    'Students by Grade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: gradeData.entries.map((entry) {
                          final grade = entry.key;
                          final count = entry.value;
                          final percentage = (count / totalStudents) * 100;

                          return PieChartSectionData(
                            color: Colors.primaries[
                                grade.hashCode % Colors.primaries.length],
                            value: percentage,
                            title: '$grade: $count',
                            radius: 40 * _animation.value,
                            titleStyle: TextStyle(
                              fontSize: 12 * _animation.value,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: gradeData.entries.map((entry) {
                      final grade = entry.key;
                      final percentage = ((entry.value / totalStudents) * 100)
                          .toStringAsFixed(1);
                      return _buildIndicator(
                        color: Colors.primaries[
                            grade.hashCode % Colors.primaries.length],
                        text: 'Grade $grade',
                        percentage: '$percentage%',
                      );
                    }).toList(),
                  ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('Error loading grade data')),
          ),
        );
      },
    );
  }

  // Helper widget to build chart indicators
  Widget _buildIndicator(
      {required Color color,
      required String text,
      required String percentage}) {
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
}
