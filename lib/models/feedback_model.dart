class Feedback {
  String feedbackId;
  String studentId;
  String courseId;
  int rating; // Rating out of 5
  String? comments; // Nullable
  DateTime createdAt;

  Feedback({
    required this.feedbackId,
    required this.studentId,
    required this.courseId,
    required this.rating,
    this.comments,
    required this.createdAt,
  });

  // Convert a Feedback instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'feedback_id': feedbackId,
      'student_id': studentId,
      'course_id': courseId,
      'rating': rating,
      'comments': comments,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert a Map to a Feedback instance
  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      feedbackId: map['feedback_id'],
      studentId: map['student_id'],
      courseId: map['course_id'],
      rating: map['rating'],
      comments: map['comments'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
