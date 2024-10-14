import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/features/auth/screens/privacyPolicy.dart';
import 'package:yeneta_tutor/features/auth/screens/termsAndConditions.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
          },
        ),
        title: Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Info Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('INFO', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigator.pushNamed(context, '/privacy_policy');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Terms & Conditions'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigator.pushNamed(context, '/terms_conditions');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Termsandconditions(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Account Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text('Log Out'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigator.pushNamed(context, '/login');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          // Delete Account Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                _showDeleteConfirmation(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform account deletion logic here
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/onboarding_screen4', // Navigate to onboarding screen 4
                  (Route<dynamic> route) => false, // Clear all previous routes
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SettingsPage(),
//     routes: {
//       '/privacy_policy': (context) => PrivacyPolicyPage(),
//       '/terms_conditions': (context) => TermsConditionsPage(),
//       '/login': (context) => LoginPage(),
//       '/onboarding_screen4': (context) => OnboardingScreen4(),
//     },
//   ));
// }

// Placeholder Pages for routing
// class PrivacyPolicyPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Privacy Policy')),
//       body: Center(child: Text('Privacy Policy Page')),
//     );
//   }
// }

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: Center(child: Text('Terms & Conditions Page')),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Login Page')),
    );
  }
}

class OnboardingScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Onboarding')),
      body: Center(child: Text('Onboarding Screen 4')),
    );
  }
}
