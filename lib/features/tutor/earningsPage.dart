import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';

class EarningsPage extends ConsumerWidget {
  final String teacherId;

  EarningsPage({required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate =
        DateFormat('EEEE, dd MMMM yyyy - h:mm a').format(DateTime.now());
    final earnFuture = ref
        .watch(subscriptionControllerProvider)
        .getSubscribedCoursesByTeacherId(teacherId)
        .then((courses) => courses.map((course) {
      final courseData = course['course'] is Course
          ? (course['course'] as Course).toMap()
          : course['course'] as Map<String, dynamic>;
      return {
        'course': courseData,
        'total_earnings': course['total_earnings'] ?? 0.0,
      };
    }).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: earnFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No earnings found.'));
          }

          // Calculate total earnings from the fetched data
          final totalEarnings = snapshot.data!.fold<double>(
            0,
            (sum, entry) => sum + (entry['total_earnings'] as double? ?? 0),
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(17, 25, 66, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Earnings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${totalEarnings.toStringAsFixed(2)} Birr',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentDate,
                        style: TextStyle(
                          color: const Color.fromARGB(179, 255, 255, 255),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final earningData = snapshot.data![index];
                    final course =
                        earningData['course'] as Map<String, dynamic>? ?? {};
                    return EarningWidget(
                    grade: (course['grade'] is String)
                          ? int.tryParse(course['grade']) ?? 0
                          : course['grade'] as int? ?? 0,
                      subject: course['subject'] ?? 'Unknown Subject',
                     chapter: (course['chapter'] is String)
                          ? int.tryParse(course['chapter']) ?? 0
                          : course['chapter'] as int? ?? 0,
                      price: (course['price'] ?? 0).toDouble(),
                      totalSales: (earningData['total_earnings'] ?? 0).toDouble(),
                    );
                  },
                ),
              ),
            ],
          );
        },
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

class EarningWidget extends StatelessWidget {
  final int? grade;
  final String? subject;
  final int? chapter;
  final double? price;
  final double? totalSales;

  EarningWidget({
    this.grade,
    this.subject,
    this.chapter,
    this.price,
    this.totalSales,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade: ${grade ?? 'N/A'}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Subject: ${subject ?? 'N/A'}'),
            Text('Chapter: ${chapter ?? 'N/A'}'),
            Text('Price: ${price ?? 0} Birr'),
            Text('Total Sales: ${totalSales ?? 0}'),
          ],
        ),
      ),
    );
  }
}
