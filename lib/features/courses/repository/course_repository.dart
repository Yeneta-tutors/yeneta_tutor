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
        rating: course.rating ?? 0.0,
        numRating: course.numRating ?? 0,
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
      print('Error in fetchCourses: $e');
      throw Exception('Failed to fetch courses: $e');
    }
  }

  //Fetch unique subjects
  Future<List<String>> fetchUniqueSubjects() async {
    try {
      final courses = await fetchCourses();
      final subjectsSet = <String>{};

      for (final course in courses) {
        subjectsSet.add(course.subject);
      }

      return subjectsSet.toList();
    } catch (e) {
      throw Exception('Failed to fetch unique subjects: $e');
    }
  }

  // Fetch courses  by subject

  Future<List<Course>> fetchCourseBySubject(String subject) async{
    try {
          final querySnapshot = await firestore
          .collection('courses')
          .where('subject', isEqualTo: subject)
          .get();
          
          return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to Fetch courses for this subject');
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

  Future<List<Course>> fetchFilteredCourses({
    required String grade,
    required String chapter,
    required String subject,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('courses')
          .where('grade', isEqualTo: grade)
          .where('chapter', isEqualTo: chapter)
          .where('subject', isEqualTo: subject)
          .get();

      print('Found ${querySnapshot.docs.length} courses for filters: Grade=$grade, Chapter=$chapter, Subject=$subject');

      if (querySnapshot.docs.isEmpty) {
        print('No courses found for the selected filters');
        return [];
      }

      return querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  //search courses by title and subject
  Future<List<Course>> searchCourses(String query) async {
    try {
      final querySnapshot = await firestore.collection('courses').get();

      final queryLowerCase = query.toLowerCase();

      final filteredCourses = querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .where(
              (course) => course.title.toLowerCase().contains(queryLowerCase))
          .toList();

      if (filteredCourses.isEmpty) {
        print("No courses found for the selected filters");
      }

      return filteredCourses;
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

    // Update course rating
  Future<void> updateCourseRating(String courseId, double newRating) async {
    try {

      final course = await fetchCourseById(courseId);
      if (course == null) {
        throw Exception('Course not found');
      }
      double totalRating = (course.rating ?? 0.0) * (course.numRating ?? 0);
      totalRating += newRating;
      int updatedNumRating = (course.numRating ?? 0) + 1;
      double updatedRating = totalRating / updatedNumRating;

      course.rating = updatedRating;
      course.numRating = updatedNumRating;

      // Update the course in Firestore
      await updateCourse(course);

      print('Course rating updated successfully.');
    } catch (e) {
      throw Exception('Failed to update course rating: $e');
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
