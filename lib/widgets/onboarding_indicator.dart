import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int onboardingIndex;

  OnboardingIndicator({required this.onboardingIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onboardingIndex == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
