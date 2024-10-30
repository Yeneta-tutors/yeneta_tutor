// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class AdminCourseDetails extends StatefulWidget {
  @override
  _AdminCourseDetailsState createState() => _AdminCourseDetailsState();
}

class _AdminCourseDetailsState extends State<AdminCourseDetails> {
  late VideoPlayerController _mainController;
  late VideoPlayerController _demoController;
  bool _mainControlsVisible = false;
  bool _demoControlsVisible = false;

  @override
  void initState() {
    super.initState();
    _mainController = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/yeneta-tutor.appspot.com/o/courses%2Fdemo_videos%2F2686c1a7-8164-47b4-834a-a01e6393bae3?alt=media&token=fbd38123-7c3c-48f6-9b78-695203cc428')
      ..initialize().then((_) {
        setState(() {});
      })
      ..addListener(() {
        setState(() {}); // Update slider and time indicators
      });
    _demoController = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/yeneta-tutor.appspot.com/o/courses%2Fdemo_videos%2F2686c1a7-8164-47b4-834a-a01e6393bae3?alt=media&token=fbd38123-7c3c-48f6-9b78-695203cc428')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  Widget _buildVideoPlayer(VideoPlayerController controller, bool isMain) {
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
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
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
                      _buildVideoPlayer(_demoController, false ),
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
                        'Title: Introduction to Physics',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Chapter: 1', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Subject: Physics', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Instructor: Esubalew', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Price: 120 Birr', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Subscribers: 7830 Std', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Rating: 4.2', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Grade: 11', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      Text('Published on: 11 May, 2023', style: TextStyle(fontSize: 22, color: Colors.black87)),
                      SizedBox(height: 16),
                      Text(
                        'DESCRIPTION',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'The Ethiopian Grade 11 Physics syllabus. This course covers the core topics of Physical '
                        'World and Measurement, providing students with a solid understanding of fundamental physics concepts.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Unpublish button action
                         AnimatedSnackBar.material(
                          'Course unpublished',              
                          type: AnimatedSnackBarType.info,  
                          mobileSnackBarPosition: MobileSnackBarPosition.top, 
                          desktopSnackBarPosition: DesktopSnackBarPosition.topCenter, 
                          duration: Duration(seconds: 3),  
                        ).show(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 9, 19, 58),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Unpublish', style: TextStyle(fontSize: 16, color: Colors.white)),
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
