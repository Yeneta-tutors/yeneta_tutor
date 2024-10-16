import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/repository/course_repository.dart';
import 'package:yeneta_tutor/models/course_model.dart';

// Provider for CourseController
final courseControllerProvider = Provider((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  final authController = ref.watch(authControllerProvider);
  return CourseController(
    courseRepository: courseRepository,
    authController: authController,
    ref: ref,
  );
});

class CourseController {
  final CourseRepository courseRepository;
  final AuthController authController;
  final ProviderRef ref;

  CourseController({
    required this.courseRepository,
    required this.authController,
    required this.ref,
  });

  // Add a course with video, demoVideo, and thumbnail, using the teacher's ID
  void addCourse({
    required Course course,
    File? videoFile,
    File? demoVideoFile,
    File? thumbnailFile,
    required BuildContext context,
  }) async {
    try {
      final teacher = authController.getCurrentUser();
      if (teacher == null) {
        throw Exception('User not authenticated');
      }

      final newCourse = Course(
        courseId: course.courseId,
        teacherId: teacher.uid, 
        title: course.title,
        grade: course.grade,
        subject: course.subject,
        chapter: course.chapter,
        description: course.description,
        videoUrl: course.videoUrl,
        demoVideoUrl: course.demoVideoUrl,
        price: course.price,
        thumbnail: course.thumbnail,
        createdAt: course.createdAt,
        updatedAt: course.updatedAt,
      );

      await courseRepository.addCourse(
        newCourse,
        videoFile,
        demoVideoFile,
        thumbnailFile,
      );

      // Handle success (e.g., show success message)
    } catch (e) {
      // Handle failure (e.g., show error message)
      print('Failed to add course: $e');
    }
  }

  // Fetch all courses
  Future<List<Course>> fetchCourses() async {
    try {
      return await courseRepository.fetchCourses();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // Fetch a single course by ID
  Future<Course?> fetchCourseById(String courseId) async {
    try {
      return await courseRepository.fetchCourseById(courseId);
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // Update a course
  Future<void> updateCourse(Course course, {required String grade, required String subject, required String chapter}) async {
    try {
      await courseRepository.updateCourse(course);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  // Fetch courses by teacher ID
  Future<List<Course>> fetchCoursesByTeacherId() async {
    try {
      return await courseRepository.fetchCoursesForTutor();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // filtered courses
  Future<List<Course>> fetchFilteredCourses(String grade, String subject, String chapter) async {
    try {
      return await courseRepository.fetchFilteredCourses(
        grade: grade,
        subject: subject,
        chapter: chapter,
      );
    } catch (e) {
      print('Error in fetchFilteredCourses: $e');
      throw Exception('Failed to fetch courses: $e');
    }
  }

  //search courses by title and subject
  Future<List<Course>> searchCourses(String query) async {
    try {
      return await courseRepository.searchCourses(query);
    } catch (e) {
      throw Exception('Failed to search courses: $e');
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await courseRepository.deleteCourse(courseId);
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
