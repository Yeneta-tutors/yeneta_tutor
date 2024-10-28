import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/admin/userProfile.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/models/user_model.dart';

class UserManagement extends ConsumerStatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends ConsumerState<UserManagement>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _searchController = TextEditingController();
  String selectedRole = 'All';

  static const roleDisplayNames = {
    UserRole.student: 'Student',
    UserRole.tutor: 'Tutor',
    UserRole.admin: 'Admin',
  };

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
    final userData = ref.watch(allUsersProvider);
    final userStatistics = ref.watch(userStatisticsProvider);

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 242, 247, 1),
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        title: Text('User Management'),
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
                            _buildUserTable(userData), // User table
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
                          _buildDonutChart(userStatistics), // Users chart
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
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Find users',
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
                  selectedRole = value;
                });
              },
              icon: Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                PopupMenuItem<String>(
                  value: roleDisplayNames[UserRole.student]!, // 'Student'
                  child: Text(roleDisplayNames[UserRole.student]!),
                ),
                PopupMenuItem<String>(
                  value: roleDisplayNames[UserRole.tutor]!, // 'Tutor'
                  child: Text(roleDisplayNames[UserRole.tutor]!),
                ),
                PopupMenuItem<String>(
                  value: roleDisplayNames[UserRole.admin]!, // 'Admin'
                  child: Text(roleDisplayNames[UserRole.admin]!),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget for the User Table
  Widget _buildUserTable(AsyncValue<List<UserModel>> userData) {
    return userData.when(
      data: (users) {
        final searchTerm = _searchController.text.toLowerCase();
        final filteredUsers = users.where((user) {
          final matchesRole = selectedRole == 'All' ||
              (roleDisplayNames[user.role]?.toLowerCase() ==
                  selectedRole.toLowerCase());
          final matchesSearch = '${user.firstName} ${user.fatherName}'
              .toLowerCase()
              .contains(searchTerm);
          return matchesRole && matchesSearch;
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
                    label: Text('Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Gender',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Role',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Profile',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: filteredUsers.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final user = entry.value;
                return DataRow(cells: [
                  DataCell(Text("$index")),
                  DataCell(Text('${user.firstName} ${user.fatherName}')),
                  DataCell(Text(user.gender)),
                  DataCell(Text("0${user.phoneNumber}")),
                  DataCell(Text(roleDisplayNames[user.role] ?? 'Unknown')),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserProfile(userId: user.uid)));
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
                      child: Text('View Profile'),
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
  Widget _buildDonutChart(AsyncValue<Map<UserRole, int>> userStatistics) {
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
      child: userStatistics.when(
        data: (stats) {
          int totalUsers = stats.values.fold(0, (a, b) => a + b);

          return Column(
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
                        value: (stats[UserRole.student]! / totalUsers) *
                            100, // Change to your dynamic value
                        title: '${stats[UserRole.student]}',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: (stats[UserRole.tutor]! / totalUsers) *
                            100, // Change to your dynamic value
                        title: '${stats[UserRole.tutor]}',
                        radius: 30,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: (stats[UserRole.admin]! / totalUsers) *
                            100, // Change to your dynamic value
                        title: '${stats[UserRole.admin]}',
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
                  _buildIndicator(
                    color: Colors.blue,
                    text: 'Students',
                    percentage:
                        '${((stats[UserRole.student]! / totalUsers) * 100).toStringAsFixed(1)}%',
                  ),
                  _buildIndicator(
                    color: Colors.red,
                    text: 'Tutors',
                    percentage:
                        '${((stats[UserRole.tutor]! / totalUsers) * 100).toStringAsFixed(1)}%',
                  ),
                  _buildIndicator(
                    color: Colors.green,
                    text: 'Admins',
                    percentage:
                        '${((stats[UserRole.admin]! / totalUsers) * 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
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
                        value: 30 *
                            _animation.value, // Multiply by animation value
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
                  _buildIndicator(
                      color: Colors.blueAccent,
                      text: 'Grade 9',
                      percentage: '30%'),
                  SizedBox(height: 10),
                  _buildIndicator(
                      color: Colors.orangeAccent,
                      text: 'Grade 10',
                      percentage: '25%'),
                  SizedBox(height: 10),
                  _buildIndicator(
                      color: Colors.greenAccent,
                      text: 'Grade 11',
                      percentage: '45%'),
                  SizedBox(height: 10),
                  _buildIndicator(
                      color: Color.fromARGB(255, 136, 255, 0),
                      text: 'Grade 12',
                      percentage: '45%'),
                ],
              ),
            ],
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
