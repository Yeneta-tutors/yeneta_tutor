import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:yeneta_tutor/common/repositories/common_firebase_storage_repository.dart';

final courseRepositoryProvider = Provider((ref) => CourseRepository(
      firestore: FirebaseFirestore.instance,
      storageRepository: ref.read(commonFirebaseStorageRepositoryProvider),
    ));

class CourseRepository {
  final FirebaseFirestore firestore;
  final CommonFirebaseStorageRepository storageRepository;

  CourseRepository({
    required this.firestore,
    required this.storageRepository,
  });

  // Add a new course
  Future<void> addCourse(Course course, File? videoFile, File? demoVideoFile,
      File? thumbnailFile) async {
    try {
      String? videoUrl;
      String? demoVideoUrl;
      String? thumbnailUrl;

      if (videoFile != null) {
        videoUrl = await storageRepository.storeFileToFirebase(
            'courses/videos/${course.courseId}', videoFile);
      }
      if (demoVideoFile != null) {
        demoVideoUrl = await storageRepository.storeFileToFirebase(
            'courses/demo_videos/${course.courseId}', demoVideoFile);
      }
      if (thumbnailFile != null) {
        thumbnailUrl = await storageRepository.storeFileToFirebase(
            'courses/thumbnails/${course.courseId}', thumbnailFile);
      }

      final newCourse = Course(
        courseId: course.courseId,
        teacherId: course.teacherId,
        title: course.title,
        grade: course.grade,
        subject: course.subject,
        chapter: course.chapter,
        description: course.description,
        videoUrl: videoUrl ?? course.videoUrl,
        demoVideoUrl: demoVideoUrl ?? course.demoVideoUrl,
        price: course.price,
        thumbnail: thumbnailUrl ?? course.thumbnail,
        createdAt: course.createdAt,
        updatedAt: course.updatedAt,
      );

      await firestore
          .collection('courses')
          .doc(course.courseId)
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

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
