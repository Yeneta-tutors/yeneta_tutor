import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeneta_tutor/features/admin/admin_sidebar.dart';
import 'package:yeneta_tutor/features/admin/dashboard_provider.dart';

class AdminDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 242, 247, 1),
      appBar: AppBar(
         iconTheme: IconThemeData(
         color: const Color.fromARGB(255, 255, 255, 255)),
        elevation: 0,
        backgroundColor:Color.fromRGBO(9, 19, 58, 1),
        title: SearchBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Hello, Esubalew', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('images/avator_image.png'), // Admin image
                ),
              ],
            ),
          )
        ],
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            StatisticsGrid(),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: PieChartWidget(),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: BarChartWidget(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticsGrid extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  final totalStudents = ref.watch(totalStudentsProvider);
   final totalTutors = ref.watch(totalTutorsProvider);
   final totalCourses = ref.watch(totalCoursesProvider);
   final totalRevenue = ref.watch(totalIncomeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatsBox(
          title: 'Total Students',
          count: totalStudents.when(
              data: (data) => '$data',
              loading: () => '...',
              error: (err, stack) => 'Error'),
          icon: FontAwesomeIcons.graduationCap,
        ),
        StatsBox(
          title: 'Total Tutors',
          count: totalTutors.when(
              data: (data) => '$data',
              loading: () => '...',
              error: (err, stack) => 'Error'),
          icon: FontAwesomeIcons.user,
        ),
        StatsBox(
          title: 'Total Courses',
          count: totalCourses.when(
              data: (data) => '$data',
              loading: () => '...',
              error: (err, stack) => 'Error'),
          icon: FontAwesomeIcons.book,
        ),
        StatsBox(
          title: 'Total Revenue',
          count: totalRevenue.when(
              data: (data) => '\$${data.toStringAsFixed(2)}',
              loading: () => '...',
              error: (err, stack) => 'Error'),
          icon: FontAwesomeIcons.dollarSign,
        ),
      ],
    );
  }
}

class StatsBox extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  StatsBox({required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 36, color:Color.fromRGBO(9, 19, 58, 1)),
          SizedBox(height: 10),
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class PieChartWidget extends ConsumerStatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends ConsumerState<PieChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _angle = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {
        _angle = _animationController.value * 360; // Rotation angle
      });
    });

    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = ref.watch(totalStudentsProvider);
    final totalTutors = ref.watch(totalTutorsProvider);

    return totalStudents.when(
      data: (students) {
        return totalTutors.when(
          data: (tutors) {
            final totalUsers = students + tutors;
            final studentPercentage = totalUsers > 0 ? (students / totalUsers) * 100 : 0;
            final tutorPercentage = totalUsers > 0 ? (tutors / totalUsers) * 100 : 0;

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6, // Control the width here
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Users',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          startDegreeOffset: _angle, // Add animation effect here
                          sections: [
                            PieChartSectionData(
                              value: studentPercentage.toDouble(),
                              color: Colors.blue,
                              title: '${studentPercentage.toStringAsFixed(1)}%',
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            PieChartSectionData(
                              value: tutorPercentage.toDouble(),
                              color: Colors.green,
                              title: '${tutorPercentage.toStringAsFixed(1)}%',
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                          pieTouchData: PieTouchData(
                            touchCallback: (touchEvent, response) {
                              if (touchEvent.isInterestedForInteractions &&
                                  response != null &&
                                  response.touchedSection != null) {
                                // Add more interactions if needed
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Indicator(color: Colors.blue, text: 'Students'),
                        SizedBox(width: 20),
                        Indicator(color: Colors.green, text: 'Tutors'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (err, stack) => Text('Error loading tutors'),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error loading students'),
    );
  }
}


// Custom Indicator widget
class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}


class PieIndicator extends StatelessWidget {
  final Color color;
  final String text;

  PieIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class BarChartWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyStudentsAsync = ref.watch(weeklyStudentsProvider);
    final weeklyTutorsAsync = ref.watch(weeklyTutorsProvider);

    return weeklyStudentsAsync.when(
      data: (weeklyStudents) => weeklyTutorsAsync.when(
        data: (weeklyTutors) {
          // Determine maxY based on the larger of the two values to set the y-axis scale
          final maxY = (weeklyStudents > weeklyTutors ? weeklyStudents : weeklyTutors).toDouble();
          var interval = (maxY / 5).ceilToDouble();
          if (interval == 0) {
            interval = 1.0;
          }
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'New Users (Weekly)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY + interval, // Adjusting maxY for padding on top
                      barGroups: [
                        makeGroupData(0, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(1, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(2, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(3, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(4, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(5, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                        makeGroupData(6, weeklyStudents.toDouble(), weeklyTutors.toDouble()),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: interval, // Fixed interval for consistent labels
                            getTitlesWidget: (double value, TitleMeta meta) {
                              // Only display whole numbers
                              return Text(value % 1 == 0 ? value.toInt().toString() : '');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(days[value.toInt()]);
                            },
                            reservedSize: 28,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(color: Colors.blue, text: 'Students'),
                    const SizedBox(width: 20),
                    Indicator(color: Colors.green, text: 'Tutors'),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading tutor data')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading student data')),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: Colors.green),
        BarChartRodData(toY: y2, color: Colors.blue),
      ],
    );
  }
}

// Custom Indicator widget
class CustomeIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const CustomeIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
