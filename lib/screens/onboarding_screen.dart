import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/controllers/onboarding_controller.dart';
import 'package:yeneta_tutor/utils/colors.dart';
import 'package:yeneta_tutor/widgets/onboarding_indicator.dart';
import 'package:yeneta_tutor/features/auth/screens/student_signup.dart';
import 'package:yeneta_tutor/features/auth/screens/tutor_signup.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final List<String> onboardingHeaders = [
    "Welcome to የኔታ Tutor!",
    "Find your perfect tutor!",
    "Start your learning journey today!",
  ];

  final List<String> onboardingTexts = [
    "የኔታ Tutor is a platform that connects students with tutors. We offer a wide range of subjects and courses to help you achieve your academic goals.",
    "Our tutors are highly qualified and experienced. They are dedicated to helping you succeed in your studies.",
    "Sign up today and start learning from the best tutors in the country!",
  ];

  final List<String> onboardingImages = [
    'images/logo.jpg',
    'images/logo.jpg',
    'images/logo.jpg',
  ];

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final onboardingIndex = ref.watch(onboardingIndexProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                ref.read(onboardingIndexProvider.notifier).state = index;
              },
              itemCount: onboardingHeaders.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingImages[index], height: 200),
                    const SizedBox(height: 20),
                    Text(
                      onboardingHeaders[index],
                      style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onboardingTexts[index],
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              },
            ),
          ),
          OnboardingIndicator(onboardingIndex: onboardingIndex),
          if (onboardingIndex < onboardingHeaders.length - 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Next"),
              ),
            ),
          if (onboardingIndex == onboardingHeaders.length - 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('I am', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the buttons
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => StudentSignup()));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Student"),
                        ),
                      ),
                      const SizedBox(width: 20), // Add spacing between buttons
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => TutorSignup()));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Tutor"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
