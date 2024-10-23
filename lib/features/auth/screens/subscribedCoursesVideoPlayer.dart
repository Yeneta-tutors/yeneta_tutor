// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorProfileView.dart';
import 'package:yeneta_tutor/features/chat/screens/chat_screen.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/features/subscription/controllers/subscription_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';

class SubscribedCoursesVideoPlayer extends ConsumerStatefulWidget {
  final String courseId;
  SubscribedCoursesVideoPlayer({required this.courseId});

  @override
  _SubscribedCoursesVideoPlayer createState() =>
      _SubscribedCoursesVideoPlayer();
}

class _SubscribedCoursesVideoPlayer
    extends ConsumerState<SubscribedCoursesVideoPlayer> {
  VideoPlayerController? _controller;
  Course? _course;
  String? _teacherName;
  String? _profilePic;
  bool _isFullScreen = false;
  bool _controlsVisible = false;
  Timer? _controlsTimer;

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

      _course = course!;

      if (_course != null) {
        _controller = VideoPlayerController.network(_course!.videoUrl)
          ..initialize().then((_) {
            setState(() {});
          });

        _controller!.addListener(() {
          if (_controlsVisible) {
            _resetControlsTimer();
          }
          setState(() {});
        });
      }

      await _loadTeacherdata(_course!.teacherId);
    } catch (e) {
      // Handle the error appropriately
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
          _profilePic = teacher.profileImage;
        });
      }
    } catch (e) {
      throw Exception('Failed to load teacher details');
    }
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _onVideoTapped() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    _resetControlsTimer();
  }

  void _showRatingDialog() {
    double _rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate this Course"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                _updateCourseRating(_rating);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCourseRating(double rating) async {
    try {
      await ref
          .read(courseControllerProvider)
          .updateRating(widget.courseId, rating);
      print('Rating updated successfully');
    } catch (e) {
      throw Exception('Error in update reating');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Course Video Player'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Video player section
              GestureDetector(
                onTap: _onVideoTapped,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: _isFullScreen
                      ? MediaQuery.of(context).size.height * 0.75
                      : 200,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _controller != null && _controller!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            )
                          : Center(child: CircularProgressIndicator()),
                      if (_controlsVisible)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Slider(
                                value: _controller!.value.position.inSeconds
                                    .toDouble(),
                                min: 0,
                                max: _controller!.value.duration.inSeconds
                                    .toDouble(),
                                onChanged: (value) {
                                  _controller!
                                      .seekTo(Duration(seconds: value.toInt()));
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_controller!.value.position.inMinutes}:${(_controller!.value.position.inSeconds % 60).toString().padLeft(2, '0')}",
                                  ),
                                  Text(
                                    "-${(_controller!.value.duration - _controller!.value.position).inMinutes}:${((_controller!.value.duration - _controller!.value.position).inSeconds % 60).toString().padLeft(2, '0')}",
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
              SizedBox(height: 10),
              // Play/Pause button for the video
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.fast_rewind),
                    onPressed: () {
                      _controller!.seekTo(
                        _controller!.value.position - Duration(seconds: 5),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _controller != null && _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                        _controlsVisible = true;
                        _resetControlsTimer();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_forward),
                    onPressed: () {
                      _controller!.seekTo(
                        _controller!.value.position + Duration(seconds: 5),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fullscreen),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Tutor profile section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(_profilePic != null
                        ? '$_profilePic'
                        : 'images/yeneta_logo.jpg'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _teacherName ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TutorProfileForStudents(_course!.teacherId),
                            ),
                          );
                        },
                        child: Text(
                          'View Profile',
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(tutorId: _course!.teacherId,),
                        ),
                      );
                    },
                    child: Text('Ask a Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Course description
              Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _course?.description ?? '',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              // Course details: Subject, Grade, Rating, Students
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_course?.subject ?? 'subject'),
                      Text('Grade: ${_course?.grade ?? 'grade'} '),
                    ],
                  ),
                  Column(
                    children: [
                      RatingBarIndicator(
                        rating: _course?.rating ?? 0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      FutureBuilder<int>(
                        future: ref
                            .read(subscriptionControllerProvider)
                            .getTotalSubscribersForCourse(_course!.courseId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text('Error');
                          } else if (snapshot.hasData) {
                            return Text(
                              ' ${snapshot.data} students',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.grey[700],
                              ),
                            );
                          } else {
                            return Text('No data');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Rate this course button
              ElevatedButton(
                onPressed: _showRatingDialog,
                child: Text("Rate This Course"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 19, 58),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class chatWithTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with Teacher')),
      body: Center(child: Text('Chat section Here')),
    );
  }
}
