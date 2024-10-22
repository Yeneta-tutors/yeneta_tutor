class Subscription {
  String subscriptionId;
  String studentId;
  String courseId;
  String subscriptionType; 
  String paymentStatus; 
  String chapaTransactionId; 
  DateTime startDate;
  DateTime endDate;
  double price; 
  String currency; 

  Subscription({
    required this.subscriptionId,
    required this.studentId,
    required this.courseId,
    required this.subscriptionType,
    required this.paymentStatus,
    required this.chapaTransactionId,
    required this.startDate,
    required this.endDate,
    required this.price, 
    required this.currency, 
  });

  Map<String, dynamic> toMap() {
    return {
      'subscription_id': subscriptionId,
      'student_id': studentId,
      'course_id': courseId,
      'subscription_type': subscriptionType,
      'payment_status': paymentStatus,
      'chapa_transaction_id': chapaTransactionId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'price': price, 
      'currency': currency, 
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      subscriptionId: map['subscription_id'],
      studentId: map['student_id'],
      courseId: map['course_id'],
      subscriptionType: map['subscription_type'],
      paymentStatus: map['payment_status'],
      chapaTransactionId: map['chapa_transaction_id'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      price: map['price'], 
      currency: map['currency'],
    );
  }
}
