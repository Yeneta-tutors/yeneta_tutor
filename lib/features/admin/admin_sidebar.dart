import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/admin/addAdmin.dart';
import 'package:yeneta_tutor/features/admin/dashboard.dart';
import 'package:yeneta_tutor/features/admin/userManagement.dart';
import 'package:yeneta_tutor/features/admin/contentManagement.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';

class Sidebar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(9, 19, 58, 1),
            ),
            child: Text(
              'Yeneta Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SidebarItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()));
              }),
          SidebarItem(
              title: 'User Management',
              icon: Icons.people,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserManagement()));
              }),
          SidebarItem(
              title: 'Content Management',
              icon: Icons.video_library,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContentManagementPage()));
              }),
          // SidebarItem(title: 'Financial Management', icon: Icons.attach_money, onTap: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => FinancialManagementPage()));
          // }),
          // SidebarItem(title: 'Reports', icon: Icons.bar_chart, onTap: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage()));
          // }),
          SidebarItem(
              title: 'Add Admin',
              icon: Icons.add,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAdminPage()));
              }),

          SidebarItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              ref.read(authControllerProvider).signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  SidebarItem({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
