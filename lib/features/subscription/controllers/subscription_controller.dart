import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/common/PaymentFailedScreen.dart';
import 'package:yeneta_tutor/features/common/PaymentSuccessScreen.dart';
import 'package:yeneta_tutor/features/subscription/repository/subscription_repositoy.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/models/subscription_model.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

final subscriptionControllerProvider = Provider((ref) {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  final authController = ref.watch(authControllerProvider);
  return SubscriptionController(
    subscriptionRepository: subscriptionRepository,
    authController: authController,
    ref: ref,
  );
});

class SubscriptionController {
  final SubscriptionRepository subscriptionRepository;
  final AuthController authController;
  final ProviderRef ref;

  SubscriptionController({
    required this.subscriptionRepository,
    required this.authController,
    required this.ref,
  });

  Future<void> createSubscriptionAndPay({
    required String studentId,
    required String courseId,
    required String subscriptionType,
    required String amount,
    required DateTime startDate,
    required DateTime endDate,
    required BuildContext context,
  }) async {
    String subscriptionId = Uuid().v4();

    // Create a new subscription
    Subscription subscription = Subscription(
      subscriptionId: subscriptionId,
      studentId: studentId,
      courseId: courseId,
      subscriptionType: subscriptionType,
      paymentStatus: 'pending',
      chapaTransactionId: '',
      startDate: startDate,
      endDate: endDate,
      price: double.parse(amount),
      currency: 'ETB',
    );

    // Add the subscription to the repository
    await subscriptionRepository.addSubscription(subscription);

    // Initiate Chapa payment
    await _initiateChapaPayment(amount, subscriptionId, context);
  }

  Future<void> _initiateChapaPayment(
    String amount,
    String txRef,
    BuildContext context,
  ) async {
    try {
      await Chapa.getInstance.startPayment(
          context: context,
          amount: amount,
          currency: "ETB",
          txRef: txRef,
          email: "ephremhabtmu@gmail.com",
          onInAppPaymentSuccess: (successMsg) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentSuccessScreen(),
              ),
            );
            _handlePaymentSuccess(txRef);
          },
          onInAppPaymentError: (errorMsg) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                         PaymentFailedScreen(errorMessage: errorMsg, errorMsg: '',)));
          });
    } catch (e) {
      if (e is NetworkException) {
        showSnackBar(context,
            'Network error: Please check your connection and try again.');
      } else {
        showSnackBar(
            context, 'An unexpected error occurred. Please try again.');
      }
    }
  }

  Future<void> _handlePaymentSuccess(String txRef) async {
    await subscriptionRepository.updateSubscription(
      txRef,
      {
        'payment_status': 'completed',
        'chapa_transaction_id': txRef,
      },
    );
    print('Subscription updated successfully.');
  }

//  fetch all subscriptions
  Future<List<Subscription>> fetchSubscriptions() async {
    try {
      return await subscriptionRepository.getAllSubscriptions();
    } catch (e) {
      throw Exception('Failed to fetch subscriptions: $e');
    }
  }
  
  Future<List<Course>> fetchSubscribedCourses(String studentId) async {
    try {
      final courses =
          await subscriptionRepository.getSubscribedCourses(studentId);
      return courses;
    } catch (error) {
      throw Exception('Failed to fetch subscribed courses');
    }
  }

  Future<int> getTotalSubscribersForCourse(String courseId) async {
    try {
      final numOfStudents =
          await subscriptionRepository.getTotalSubscribersForCourse(courseId);

      return numOfStudents;
    } catch (e) {
      throw Exception("Error in calculating the total number");
    }
  }

// getSubscribedCoursesByTeacherId

Future<List<Map<String, dynamic>>> getSubscribedCoursesByTeacherId(String teacherId) async {
    try {
      final courses =
          await subscriptionRepository.getSubscribedCoursesByTeacherId(teacherId);
      return courses;
    } catch (error) {
      throw Exception('Failed to fetch subscribed courses');
    }
  }
}
