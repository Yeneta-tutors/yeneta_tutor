import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/subscription_model.dart';

final subscriptionRepositoryProvider = Provider((ref) => SubscriptionRepository(
      firestore: FirebaseFirestore.instance,
      authRepository: ref.read(authRepositoryProvider),
    ));

class SubscriptionRepository {
  final FirebaseFirestore firestore;
  final AuthRepository authRepository;

  SubscriptionRepository({
    required this.firestore,
    required this.authRepository,
  });

  // Add a new subscription
  Future<void> addSubscription(Subscription subscription) async {
    try {
      await firestore
          .collection('subscriptions')
          .doc(subscription.subscriptionId)
          .set(subscription.toMap());
    } catch (e) {
      print('Error adding subscription: $e');
    }
  }

  // Update subscription status (e.g., payment status)
  Future<void> updateSubscription(
      String subscriptionId, Map<String, dynamic> updates) async {
    try {
      await firestore
          .collection('subscriptions')
          .doc(subscriptionId)
          .update(updates);
    } catch (e) {
      print('Error updating subscription: $e');
    }
  }

  // Fetch a subscription by ID
  Future<Subscription?> getSubscription(String subscriptionId) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('subscriptions').doc(subscriptionId).get();
      if (snapshot.exists) {
        return Subscription.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching subscription: $e');
    }
    return null;
  }

  Future<List<Subscription>> getCompletedSubscriptionsByStudentId(
      String studentId) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('subscriptions')
          .where('student_id', isEqualTo: studentId)
          .where('payment_status', isEqualTo: 'completed')
          .get();

      return snapshot.docs
          .map(
              (doc) => Subscription.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching completed subscriptions: $e');
      return [];
    }
  }

  Future<List<Course>> getCoursesByIds(List<String> courseIds) async {
    try {
      final List<Course> courses = [];

      for (String courseId in courseIds) {
        final DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();

        if (doc.exists) {
          courses.add(Course.fromMap(doc.data() as Map<String, dynamic>));
        }
      }
      print(courses);
      return courses;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<List<Course>> getSubscribedCourses(String studentId) async {
    try {
      List<Subscription> subscriptions =
          await getCompletedSubscriptionsByStudentId(studentId);

      List<String> courseIds =
          subscriptions.map((sub) => sub.courseId).toList();
     
      return await getCoursesByIds(courseIds);
    } catch (e) {
      print('Error fetching subscribed courses: $e');
      return [];
    }
  }

  Future<int> getTotalSubscribersForCourse(String courseId) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('subscriptions')
        .where('course_id', isEqualTo: courseId)
        .get();
    int totalSubscribers = snapshot.docs.length;

    return totalSubscribers;
  } catch (e) {
    print('Error fetching total subscribers: $e');
    return 0; 
  }
}

}
