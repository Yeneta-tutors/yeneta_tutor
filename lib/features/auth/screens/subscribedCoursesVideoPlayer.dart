// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorProfileView.dart';

class SubscribedCoursesVideoPlayer extends StatefulWidget {
  final Map<String, dynamic> course;

  SubscribedCoursesVideoPlayer({required this.course});

  @override
  _SubscribedCoursesVideoPlayer createState() => _SubscribedCoursesVideoPlayer();
}

class _SubscribedCoursesVideoPlayer extends State<SubscribedCoursesVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isFullScreen = false;
  bool _controlsVisible = false;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/yeneta-tutor.appspot.com/o/courses%2Fdemo_videos%2F2686c1a7-8164-47b4-834a-a01e6393bae3?alt=media&token=fbd38123-7c3c-48f6-9b78-695203cc428',
    )..initialize().then((_) {
        setState(() {});
      });

    _controller!.addListener(() {
      if (_controlsVisible) {
        _resetControlsTimer();
      }
      setState(() {});
    });
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
                // Here you can handle the submitted rating value
                print("Submitted rating: $_rating");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  height: _isFullScreen ? MediaQuery.of(context).size.height * 0.75 : 200,
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
                                value: _controller!.value.position.inSeconds.toDouble(),
                                min: 0,
                                max: _controller!.value.duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  _controller!.seekTo(Duration(seconds: value.toInt()));
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    backgroundImage: NetworkImage(
                      'images/avator_image.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Esubalew K.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TutorProfileForStudents(course:course),
                          //   ),
                          // );
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
                          builder: (context) => chatWithTeacher(),
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
                'Unlock the foundational principles of physics with our '
                'comprehensive lecture on Chapter 1 of the Ethiopian Grade 11 '
                'Physics syllabus. This course covers the core topics of Physical '
                'World and Measurement, providing students with a solid understanding '
                'of fundamental physics concepts.',
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
                      Text('Subject: Physics'),
                      Text('Grade: 11'),
                    ],
                  ),
                  Column(
                    children: [
                      RatingBarIndicator(
                        rating: 4.2,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Text('7830 Students'),
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
