// ignore_for_file: unrelated_type_equality_checks

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yeneta_tutor/features/admin/addAdmin.dart';
import 'package:yeneta_tutor/features/admin/admin_sidebar.dart';
import 'package:yeneta_tutor/features/admin/courseDetail.dart';
import 'package:yeneta_tutor/features/admin/dashboard.dart';
import 'package:yeneta_tutor/features/auth/screens/login_screen.dart';
import 'package:yeneta_tutor/features/student/studentHome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/tutor/tutorHomePage.dart';
import 'package:yeneta_tutor/firebase_options.dart';
import 'package:yeneta_tutor/screens/splashScreen.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load(fileName: ".env");
  // String chapaApiKey = dotenv.env['CHAPA_API_KEY'] ?? '';
  Chapa.configure(privateKey: 'CHASECK_TEST-zpSrRnBkLTE28RteRDogXHMCrN0xqZYu');
  runApp(const ProviderScope(child: MyApp()));
}



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
            return SplashScreen(); //
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
