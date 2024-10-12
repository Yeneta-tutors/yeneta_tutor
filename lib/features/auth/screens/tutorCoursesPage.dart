
import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/courseDetails.dart';
import 'package:yeneta_tutor/features/auth/screens/courseUpload.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorHomePage.dart';

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('COURSES'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context); // Navigate back to the previous page
              Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TutorHomePage()),
          );
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // Keeps card size constant
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75, // Adjust the card height/width ratio
              ),
              itemCount: 6, // Adjust as needed for number of courses
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    
                    // Navigator.pushNamed(context, '/detailsPage'); // Go to details page
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsPage(), 
                    ),
                  );
                  },
                  child: CourseCard(), // Each card is a separate widget
                );
              },
            ),
          ),

          // Upload Course button at the bottom-right corner
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/uploadCourse'); 
                
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseUploadPage(), 
                    ),
                  );// Navigate to upload course page
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Course Card
class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4, // Adds shadow behind the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          Expanded(
            child: Image.asset(
              'images/yeneta_logo.jpg', // Placeholder thumbnail image
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Course details
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course: Maths',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Duration: 1hr'),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.green, size: 16),
                    Text('4.5 (200)', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
