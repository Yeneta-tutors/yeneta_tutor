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

  //get subscription by student id  
Future<List<Subscription>> getSubscriptionsByStudentId(String studentId) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('subscriptions')
        .where('studentId', isEqualTo: studentId) // Filter by studentId
        .get();

    return snapshot.docs.map((doc) => Subscription.fromMap(doc.data() as Map<String, dynamic>)).toList();
  } catch (e) {
    print('Error fetching subscriptions: $e');
    return []; // Return an empty list on error
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

    return courses; 
  } catch (e) {
    print('Error fetching courses: $e');
    return []; 
  }
}



}
