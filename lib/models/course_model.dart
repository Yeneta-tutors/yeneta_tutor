class Course {
  String courseId;
  String teacherId;
  String title;
  String grade;
  String subject;
  String chapter;
  String description;
  String videoUrl;
  String demoVideoUrl;
  double price;
  String? thumbnail;
  double? rating;
  int? numRating;
  bool isPublished;
  DateTime createdAt;
  DateTime updatedAt;

  Course({
    required this.courseId,
    required this.teacherId,
    required this.title,
    required this.grade,
    required this.subject,
    required this.chapter,
    required this.description,
    required this.videoUrl,
    required this.demoVideoUrl,
    required this.price,
    required this.thumbnail,
    required this.rating,
    required this.numRating,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a Course instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'teacher_id': teacherId,
      'title': title,
      'grade': grade,
      'subject': subject,
      'chapter': chapter,
      'demo_video_url': demoVideoUrl,
      'description': description,
      'video_url': videoUrl,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
      'num_rating':numRating,
      'is_published': isPublished,
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
      grade: map['grade'],
      subject: map['subject'] ?? '',
      chapter: map['chapter'],
      demoVideoUrl: map['demo_video_url'],
      description: map['description'],
      videoUrl: map['video_url'],
      price: map['price'].toDouble(),
      thumbnail: map['thumbnail'],
      rating: map['rating']?.toDouble(), 
      numRating: map['num_rating'] != null ? map['num_rating'] as int : null, 
      isPublished: map['is_published'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  get uuid => null;
}
