import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeneta_tutor/features/admin/admin_sidebar.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

// class Sidebar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: const Color.fromRGBO(9, 19, 58, 1),
//             ),
//             child: Text(
//               'Yeneta Admin',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           SidebarItem(title: 'Dashboard', icon: Icons.dashboard),
//           SidebarItem(title: 'User Management', icon: Icons.people,),
//           SidebarItem(title: 'Content Management', icon: Icons.video_library),
//           SidebarItem(title: 'Financial Management', icon: Icons.attach_money),
//           SidebarItem(title: 'Reports', icon: Icons.bar_chart),
//           SidebarItem(title: 'Add Admin', icon: Icons.add),
//         ],
//       ),
//     );
//   }
// }

// // class SidebarItem extends StatelessWidget {
// //   final String title;
// //   final IconData icon;

// //   SidebarItem({required this.title, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: () {
        
//       },
//     );
//   }
// }

class StatisticsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatsBox(title: 'Total Students', count: '75', icon: FontAwesomeIcons.graduationCap),
        StatsBox(title: 'Total Tutors', count: '15', icon: FontAwesomeIcons.user),
        StatsBox(title: 'Total Courses', count: '15', icon: FontAwesomeIcons.book),
        StatsBox(title: 'Total Revenue', count: '128 Birr', icon: FontAwesomeIcons.dollarSign),
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

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget>
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
                      value: 63,
                      color: Colors.blue,
                      title: '63%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: Colors.green,
                      title: '25%',
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


class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            'New Users',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: [
                  makeGroupData(0, 5, 9),
                  makeGroupData(1, 7, 6),
                  makeGroupData(2, 5, 7),
                  makeGroupData(3, 6, 8),
                  makeGroupData(4, 2, 3),
                  makeGroupData(5, 4, 5),
                  makeGroupData(6, 9, 6),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true), // Remove left axis
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
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Mon');
                          case 1:
                            return const Text('Tue');
                          case 2:
                            return const Text('Wed');
                          case 3:
                            return const Text('Thu');
                          case 4:
                            return const Text('Fri');
                          case 5:
                            return const Text('Sat');
                          case 6:
                            return const Text('Sun');
                          default:
                            return const Text('');
                        }
                      },
                      reservedSize: 28, // Ensures enough space for the labels
                    ),
                  ),
                ),
                gridData: FlGridData(show: false), // Remove grid lines
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
