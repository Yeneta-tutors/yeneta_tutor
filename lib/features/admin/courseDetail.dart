// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';

class AdminCourseDetails extends ConsumerStatefulWidget {
  final String courseId;

  AdminCourseDetails({required this.courseId});

  @override
  _AdminCourseDetailsState createState() => _AdminCourseDetailsState();
}

class _AdminCourseDetailsState extends ConsumerState<AdminCourseDetails> {
  Course? _course;
  String? _teacherName;
  VideoPlayerController? _mainController; // Nullable
  VideoPlayerController? _demoController; // Nullable
  bool _mainControlsVisible = false;
  bool _demoControlsVisible = false;

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

      _course = course;

      if (_course != null) {
        // Initialize controllers only if the video URLs are not null or empty
        if (_course!.videoUrl.isNotEmpty) {
          _mainController = VideoPlayerController.network(_course!.videoUrl)
            ..initialize().then((_) {
              setState(() {});
            });
        }

        if (_course!.demoVideoUrl.isNotEmpty) {
          _demoController = VideoPlayerController.network(_course!.demoVideoUrl)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      }
      await _loadTeacherdata(_course!.teacherId);
    } catch (e) {
      print('Failed to load course details: $e');
    }
  }
  
  Future<void> _loadTeacherdata(String teacherId) async {
    try {
      final teacher =
          await ref.read(authControllerProvider).getUserData(teacherId);

      if (teacher != null) {
        setState(() {
          _teacherName = teacher.firstName;
        });
      }
    } catch (e) {
      throw Exception('Failed to load teacher details');
    }
  }

  @override
  void dispose() {
    _mainController?.dispose();
    _demoController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  Widget _buildVideoPlayer(VideoPlayerController? controller, bool isMain) {
    if (controller == null || !controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator()); // Show loading indicator
    }
    return MouseRegion(
      onEnter: (_) => setState(() {
        if (isMain) {
          _mainControlsVisible = true;
        } else {
          _demoControlsVisible = true;
        }
      }),
      onExit: (_) => setState(() {
        if (isMain) {
          _mainControlsVisible = false;
        } else {
          _demoControlsVisible = false;
        }
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
        Container(
          constraints: BoxConstraints(maxHeight: 200), 
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
          if ((isMain && _mainControlsVisible) || (!isMain && _demoControlsVisible))
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10, color: Colors.white, size: 30),
                          onPressed: () => controller.seekTo(controller.value.position - Duration(seconds: 10)),
                        ),
                        IconButton(
                          icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                          onPressed: () {
                            setState(() {
                              controller.value.isPlaying ? controller.pause() : controller.play();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10, color: Colors.white, size: 30),
                          onPressed: () => controller.seekTo(controller.value.position + Duration(seconds: 10)),
                        ),
                      ],
                    ),
                    // Video progress indicator and time
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(controller.value.position),
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: controller.value.position.inSeconds.toDouble(),
                                  min: 0,
                                  max: controller.value.duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      controller.seekTo(Duration(seconds: value.toInt()));
                                    });
                                  },
                                ),
                              ),
                              Text(
                                _formatDuration(controller.value.duration - controller.value.position),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Main Course', style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 8),
                      _buildVideoPlayer(_mainController, true),
                      SizedBox(height: 16),
                      Text('Demo Video', style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 8),
                      _buildVideoPlayer(_demoController, false),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Course Details Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ${_course?.title ?? ''}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Chapter: ${_course?.chapter ?? ''}', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Subject: ${_course?.subject ?? ''}', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Instructor: ${_teacherName ?? ''}', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Price: ${_course?.price ?? ''} Birr', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Subscribers: 7830 Std', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Rating: ${_course?.rating ?? 0.0}', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Grade: ${_course?.grade ?? ''}', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Published on: 11 May, 2023', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      SizedBox(height: 16),
                      Text(
                        'DESCRIPTION',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _course?.description ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Unpublish button action
                          AnimatedSnackBar.material(
                            'Course unpublished',              
                            type: AnimatedSnackBarType.info, 
                          ).show(context);
                        },
                        child: Text('Unpublish Course'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
