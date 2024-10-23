import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 242, 247, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(
         color: const Color.fromARGB(255, 255, 255, 255)),
        title: Text('User Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Hello, Esubalew', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('images/avator_image.png'),
                ),
              ],
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                            _buildUserTable(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Right section: Charts
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDonutChart(), // Users chart
                          SizedBox(height: 20),
                          _buildGradeChart(), // Students chart with animation
                        ],
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
          'All Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Container(
              width: 250,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Find users',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  contentPadding: EdgeInsets.all(1),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 40),
            PopupMenuButton<String>(
              onSelected: (value) {
                print('Selected filter: $value');
              },
              icon: Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                PopupMenuItem<String>(
                  value: 'Students',
                  child: Text('Students'),
                ),
                PopupMenuItem<String>(
                  value: 'Tutors',
                  child: Text('Tutors'),
                ),
                PopupMenuItem<String>(
                  value: 'Admins',
                  child: Text('Admins'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget for the User Table
  Widget _buildUserTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(
            15,
            (index) => DataRow(cells: [
              DataCell(Text('$index')),
              DataCell(Text('John Doe')),
              DataCell(Text('Male')),
              DataCell(Text('(123) 456-7890')),
              DataCell(Text('Student')),
              DataCell(
                ElevatedButton(
                  onPressed: () {
                    // Navigate to profile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 158, 250, 161),
                    minimumSize: Size(50, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide(
                          color: const Color.fromARGB(255, 116, 111, 111),
                          width: 1),
                    ),
                  ),
                  child: Text('View Profile'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // Widget for Donut Chart
  Widget _buildDonutChart() {
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
      child: Column(
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
                    value: 40, // Change to your dynamic value
                    title: '66',
                    radius: 30,
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 30, // Change to your dynamic value
                    title: '14',
                    radius: 30,
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: 30, // Change to your dynamic value
                    title: '12',
                    radius: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndicator(color: Colors.blue, text: 'Students', percentage: '18'),
              _buildIndicator(color: Colors.red, text: 'Tutors', percentage: '15'),
              _buildIndicator(color: Colors.green, text: 'Admins', percentage: '12'),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for Grade Chart with animation
  Widget _buildGradeChart() {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pie chart section
              SizedBox(
                width: 200, // Adjust width as needed
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: 30 * _animation.value, // Multiply by animation value
                        title: '${(30 * _animation.value).toStringAsFixed(1)}%',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        color: Colors.orangeAccent,
                        value: 25 * _animation.value,
                        title: '${(25 * _animation.value).toStringAsFixed(1)}%',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        color: Colors.greenAccent,
                        value: 45 * _animation.value,
                        title: '${(45 * _animation.value).toStringAsFixed(1)}%',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        color: const Color.fromARGB(255, 136, 255, 0),
                        value: 45 * _animation.value,
                        title: '${(45 * _animation.value).toStringAsFixed(1)}%',
                        radius: 30,
                      ),
                    ],
                  ),
                ),
              ),
              // Legend section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIndicator(color: Colors.blueAccent, text: 'Grade 9', percentage: '30%'),
                  SizedBox(height: 10),
                  _buildIndicator(color: Colors.orangeAccent, text: 'Grade 10', percentage: '25%'),
                  SizedBox(height: 10),
                  _buildIndicator(color: Colors.greenAccent, text: 'Grade 11', percentage: '45%'),
                  SizedBox(height: 10),
                  _buildIndicator(color: Color.fromARGB(255, 136, 255, 0), text: 'Grade 12', percentage: '45%'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to build chart indicators
  Widget _buildIndicator({required Color color, required String text, required String percentage}) {
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
