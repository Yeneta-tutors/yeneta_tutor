
import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/studentCourses.dart';

class StudentHomePageDemo extends StatelessWidget {
  // Map to associate courses with their respective image paths
  final Map<String, String> courseImages = {
    "MATHEMATICS": 'images/maths_thumbnail.jpg',
    "PHYSICS": 'images/physics_thumbnail 5.png',
    "CHEMISTRY": 'images/chemistry_thumbnail.png',
    "BIOLOGY": 'images/biology_thumbnail.png',
    "HISTORY": 'images/history_thumbnail.png',
    "GEOGRAPHY": 'images/geography_thumbnail.png',
    "ICT": 'images/ict_thumbnail.png',
    "ECONOMICS": 'images/economics_thumbnail.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue-black container from the top to the Categories section
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0D1B2A), // Blue-black color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header section with profile image, welcome text, and bell icon
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('images/yeneta_logo.jpg'), // Placeholder image
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Welcome Alex', /// first name of the tutor fetched from the database
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          // Red icon when there's a new message
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Search bar section
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Find Courses',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Categories text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Courses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),

            // Displaying the course cards grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true, // Important to avoid GridView taking full screen
                physics: NeverScrollableScrollPhysics(), // Avoid scrolling inside GridView
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Maximum width per card
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 166 / 167, // Aspect ratio of the card (fixed size)
                ),
                itemCount: courseImages.keys.length, // Number of cards
                itemBuilder: (context, index) {
                  String course = courseImages.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoursesPage(course: course),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          courseImages[course]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
