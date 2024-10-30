import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';

class PaymentHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionController = ref.watch(subscriptionControllerProvider);
    final authController = ref.watch(authControllerProvider);

    // Get the logged-in student ID from authController
    final studentId = authController.getCurrentUserId();

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: FutureBuilder<List<Course>>(
        future: subscriptionController.fetchSubscribedCourses(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching payment history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payments found'));
          }

          final courses = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return PaymentCard(course: courses[index]);
            },
          );
        },
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Course course;

  PaymentCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextRow(label: 'Grade', value: course.grade.toString()),
            Divider(thickness: 1),
            TextRow(label: 'Subject', value: course.subject),
            Divider(thickness: 1),
            TextRow(label: 'Chapter', value: course.chapter.toString()),
            Divider(thickness: 1),
            TextRow(label: 'Price', value: '${course.price} Birr'),
          ],
        ),
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  TextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
