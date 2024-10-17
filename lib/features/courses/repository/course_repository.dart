import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/common/repositories/common_firebase_storage_repository.dart';
import 'package:yeneta_tutor/utils/utils.dart';

final courseRepositoryProvider = Provider((ref) => CourseRepository(
      firestore: FirebaseFirestore.instance,
      storageRepository: ref.read(commonFirebaseStorageRepositoryProvider),
      authRepository: ref.read(authRepositoryProvider),
    ));

class CourseRepository {
  final FirebaseFirestore firestore;
  final CommonFirebaseStorageRepository storageRepository;
  final AuthRepository authRepository;
  final Uuid uuid = Uuid(); // Initialize Uuid here

  CourseRepository({
    required this.firestore,
    required this.storageRepository,
    required this.authRepository,
  });

  // Add a new course
  Future<void> addCourse(Course course, File? videoFile, File? demoVideoFile,
      File? thumbnailFile) async {
    try {
      String? videoUrl;
      String? demoVideoUrl;
      String? thumbnailUrl;

      // Generate a new course ID
      String newCourseId = uuid.v4();

      if (videoFile != null) {
        videoUrl = await storageRepository.storeFileToFirebase(
            'courses/videos/$newCourseId', videoFile);
      }
      if (demoVideoFile != null) {
        demoVideoUrl = await storageRepository.storeFileToFirebase(
            'courses/demo_videos/$newCourseId', demoVideoFile);
      }
      if (thumbnailFile != null) {
        thumbnailUrl = await storageRepository.storeFileToFirebase(
            'courses/thumbnails/$newCourseId', thumbnailFile);
      }

      final newCourse = Course(
        courseId: newCourseId, // Use the newly generated ID
        teacherId: authRepository.getCurrentUserId(),
        title: course.title,
        grade: course.grade,
        subject: course.subject,
        chapter: course.chapter,
        description: course.description,
        videoUrl: videoUrl ?? '',
        demoVideoUrl: demoVideoUrl ?? '',
        price: course.price,
        thumbnail: thumbnailUrl ?? '',
        createdAt: course.createdAt,
        updatedAt: course.updatedAt,
      );

      // Set the document in Firestore
      await firestore
          .collection('courses')
          .doc(newCourseId) // Use the new course ID
          .set(newCourse.toMap());
    } catch (e) {
      throw Exception('Failed to add course: $e');
    }
  }

  // Fetch all courses
  Future<List<Course>> fetchCourses() async {
    try {
      final querySnapshot = await firestore.collection('courses').get();
      return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // Fetch a single course by ID
  Future<Course?> fetchCourseById(String courseId) async {
    try {
      final doc = await firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        return Course.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // fetchCoursesForTutor
  Future<List<Course>> fetchCoursesForTutor() async {
    final teacherId = authRepository.getCurrentUserId();
    print(teacherId);

    try {
      final querySnapshot = await firestore
          .collection('courses')
          .where('teacher_id', isEqualTo: teacherId)
          .get();
      return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

// sear
  // Update a course
  Future<void> updateCourse(Course course) async {
    try {
      await firestore
          .collection('courses')
          .doc(course.courseId)
          .update(course.toMap());
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

// Filtered courses by grade  chapter and subject

  Future<List<Course>> fetchFilteredCourses(
      {required String grade,
      required String chapter,
      required String subject}) async {
    try {
      final querySnapshot = await firestore
          .collection('courses')
          .where('grade', isEqualTo: grade)
          .where('chapter', isEqualTo: chapter)
          .where('subject', isEqualTo: subject)
          .get();

       if (querySnapshot.docs.isEmpty) {
          print('No courses found for the selected filters');
      return [];
    }
      return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  //search courses by title and subject
  Future<List<Course>> searchCourses(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('courses')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: '${query}z')
          .get();
      return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
