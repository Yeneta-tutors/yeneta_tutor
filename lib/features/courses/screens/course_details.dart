import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class CourseDetailsPage extends StatefulWidget {
  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  // Sample video URL
  final String videoUrl = "https://youtu.be/uaKNdUeiiPU";
  
  // Course information
  final String title = "Introduction to Physics Chapter : 1";
  final String subject = "Physics";
  final String instructor = "Esubalew";
  final String grade = "Grade 11";
  final int duration = 35; // Duration in minutes
  final double price = 120.0; // Price in Birr
  final double rating = 4.2;
  final int studentsBought = 7830;
  final String description =
      "Unlock the foundational principles of physics with our comprehensive lecture on Chapter 1 of the Ethiopian Grade 11 Physics syllabus.";

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  // Delete confirmation dialog
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
              onPressed: () {
                // Perform delete operation
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Course deleted successfully!'),
                ));
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
                    onPressed: () => _confirmDelete(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("Delete"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to edit course page (to be implemented)
                    },
                    child: Text("Edit"),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // Course Information
              Text(
                "Title: $title",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Subject: $subject"),
              Text("Instructor: $instructor"),
              Text("Grade: $grade"),
              Text("Duration: $duration min"),
              Text("Price: $price birr"),
              Row(
                children: [
                  Text("Rating: $rating"),
                  const SizedBox(width: 8.0),
                  Text("($studentsBought Students)"),
                ],
              ),
              const Divider(),
              // Course Description
              const Text(
                "DESCRIPTION",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}

