import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/courseDetails.dart';
import 'package:yeneta_tutor/features/auth/screens/courseUpload.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorCoursesPage.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorHomePage.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorProfile.dart';
import 'package:yeneta_tutor/screens/splashScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/firebase_options.dart';
import 'package:yeneta_tutor/features/auth/screens/forgot_password.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yeneta Tutor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TutorHomePage(),
    );
  }
}
