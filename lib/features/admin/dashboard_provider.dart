
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/user_model.dart';


final totalStudentsProvider = FutureProvider<int>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  final students = users.where((user) => user.role == UserRole.student).length;
  return students;
  
});


// count students for each grade
final gradeStudentsProvider = FutureProvider<Map<String, int>>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  final students = users.where((user) => user.role == UserRole.student).toList();
  final gradeStudents = <String, int>{};
  for (var student in students) {
    if (student.grade != null) {
      if (gradeStudents.containsKey(student.grade)) {
        gradeStudents[student.grade!] = gradeStudents[student.grade!]! + 1;
      } else {
        gradeStudents[student.grade!] = 1;
      }
    }
  }
  return gradeStudents;
});



final totalTutorsProvider = FutureProvider<int>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  final tutors = users.where((user) => user.role == UserRole.tutor).length;
  return tutors;
});

final totalCoursesProvider = FutureProvider<int>((ref) async {
  final courses = await ref.watch(courseControllerProvider).fetchCourses();
  final totalCourses = courses.length;
  return totalCourses;
});

// tottal income from all subscriptions when payment is successful
final totalIncomeProvider = FutureProvider<double>((ref) async {
  final subscriptions = await ref.watch(subscriptionControllerProvider).fetchSubscriptions();
  double totalIncome = 0.0;
  for (var subscription in subscriptions) {
    if (subscription.paymentStatus == 'completed') {
      totalIncome += subscription.price;
    }
  }
  return totalIncome;
});

// weekly students count
final weeklyStudentsProvider = FutureProvider<int>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  final students = users.where((user) => user.role == UserRole.student).toList();
  int weeklyStudents = 0;
  for (var student in students) {
    if (student.createdAt.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
      weeklyStudents++;
    }
  }
  return weeklyStudents;
});

// weekly tutors count
final weeklyTutorsProvider = FutureProvider<int>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  final tutors = users.where((user) => user.role == UserRole.tutor).toList();
  int weeklyTutors = 0;
  for (var tutor in tutors) {
    if (tutor.createdAt.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
      weeklyTutors++;
    }
  }
  return weeklyTutors;
});


