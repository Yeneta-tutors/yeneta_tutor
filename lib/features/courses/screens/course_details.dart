import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/courses/screens/course_upload.dart';
import 'package:yeneta_tutor/models/course_model.dart';


class CourseDetailsPage extends ConsumerStatefulWidget {
  final String courseId;

  CourseDetailsPage({required this.courseId});

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends ConsumerState<CourseDetailsPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  Course? _course;
  String? _teacherName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
  }

  Future<void> _loadCourseDetails() async {
    try {
      final course = await ref
          .read(courseControllerProvider)
          .fetchCourseById(widget.courseId);
      if (course != null) {
        setState(() {
          _course = course;
          _videoPlayerController =
           VideoPlayerController.networkUrl(Uri.parse(course.demoVideoUrl));
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: true,
          );
        });
      }
      await _loadTeacherName(course!.teacherId);
    } catch (e) {
      // Handle failure to fetch course
      print('Failed to load course details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTeacherName(String teacherId) async {
    try {
      final teacher =
          await ref.read(authControllerProvider).getUserData(teacherId);

      if (teacher != null) {
        setState(() {
          _teacherName = teacher.firstName;
        });
      }
    } catch (e) {
      print('Failed to load teacher details: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Text("Do you really want to delete this course?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                try {
                  await ref
                      .read(courseControllerProvider)
                      .deleteCourse(_course!.courseId);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Course deleted successfully!'),
                  ));
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Failed to delete course: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_course == null) {
      return Center(child: Text("Course not found"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Course Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Video Player Section
              Container(
                height: 200.0,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
              SizedBox(height: 16.0),
              // Delete and Edit Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => CourseUploadPage(course: _course),  
                        ),
                      );
                    },
                    child: Text("Edit"),
                  ),
                  ElevatedButton(
                    onPressed: () => _confirmDelete(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("Delete"),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // Course Information
              Text(
                "Title: ${_course!.title}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Subject: ${_course!.subject}"),
              Text("Instructor: $_teacherName"),
              Text("Grade: ${_course!.grade}"),
              // Text("Duration: ${_course!.duration} min"),
              Text("Price: ${_course!.price} birr"),
              Row(
                children: [
                  // Text("Rating: ${_course!.rating}"),
                  // const SizedBox(width: 8.0),
                  // Text("(${_course!.studentsBought} Students)"),
                ],
              ),
              const Divider(),
              // Course Description
              const Text(
                "DESCRIPTION",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(_course!.description),
            ],
          ),
        ),
      ),
    );
  }
}
