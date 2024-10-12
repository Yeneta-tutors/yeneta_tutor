import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/screens/splashScreen.dart';
import 'package:yeneta_tutor/screens/studentHome.dart';
import 'package:yeneta_tutor/screens/tutorHome.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userDataAuthProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeneta Tutor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userAsyncValue.when(
       data: (user) {
          if (user == null) {
            return SplashScreen();
          } else {
            if (user.role == 0) {
              return StudentHomePage();  
            } else if (user.role == 1) {
              return TutorHomePage(); 
            } else {
              return LoginScreen(); 
            }
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}


  


