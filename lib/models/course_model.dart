
class Course {
  String courseId;
  String teacherId;
  String title;
  String description;
  String videoUrl;
  double price; // Decimal
  DateTime createdAt;
  DateTime updatedAt;

  Course({
    required this.courseId,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a Course instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'teacher_id': teacherId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert a Map to a Course instance
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseId: map['course_id'],
      teacherId: map['teacher_id'],
      title: map['title'],
      description: map['description'],
      videoUrl: map['video_url'],
      price: map['price'].toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
