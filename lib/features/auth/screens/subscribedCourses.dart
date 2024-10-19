import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/studentDetailsPage.dart';
import 'package:yeneta_tutor/features/auth/screens/subscribedCoursesVideoPlayer.dart';

class Subscribedcourses extends StatelessWidget {
  // Dummy data for course cards
  final List<Map<String, dynamic>> courses = [
    {
      "videourl": "https://www.youtube.com/watch?v=QGqfLpXVJn0",
      "demoVideoUrl": "https://www.youtube.com/watch?v=QGqfLpXVJn0",
      "title": "Measurements",
      "instructor": "John",
      "rating": 4.2,
      "students": 7830,
      "price": 28,
      "image": 'images/maths_thumbnail.jpg',
      "grade": "8",
      "chapter": "1",
    },
    // Add more course entries here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Subscribed Courses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              // Open filter dialog
              showDialog(
                context: context,
                builder: (_) => FilterDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Filter my courses',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Course cards grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscribedCoursesVideoPlayer(course: course),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Image.asset(
                                  course['image'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Grade ${course['grade']}',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Chapter ${course['chapter']}',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  course['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/avator_image.png'),
                                      radius: 12,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      course['instructor'],
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                    SizedBox(width: 3),
                                    Text(
                                      course['rating'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${course['students']} Std',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Text(
                                      '${course['price']} Birr',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Filter Dialog
class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int selectedGrade = 9;
  int selectedChapter = 1;
  String selectedSubject = 'Maths';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Courses'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Text('Subject'),
            DropdownButton<String>(
              value: selectedSubject,
              hint: const Text('Select Subject'),
              items: ['Maths',
                    'English',
                    'Physics',
                    'Biology',
                    'Chemistry',
                    'Economics',
                    'Information Technology']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  // selectedSubject = newValue; // Update the selected value
                });
              },
              isExpanded: false,
              dropdownColor: Colors.grey[200],
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              menuMaxHeight: 200,
            ),
            // Grade Filter
            Text('Grade'),
            DropdownButton<int>(
              value: selectedGrade,
              items: [9, 10, 11, 12].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Grade $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value!;
                });
              },
            ),

            // Chapter Filter
            Text('Chapter'),
            DropdownButton<int>(
              value: selectedChapter,
              items: List.generate(12, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Chapter $value'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedChapter = value!;
                });
              },
              isExpanded: false,
              dropdownColor: Colors.grey[200],
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 20,
              menuMaxHeight: 200,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Apply filter logic and close dialog
            Navigator.of(context).pop();
          },
          child: Text('Search'),
        ),
      ],
    );
  }
}

// Note: Make sure CourseDetailsPage is defined somewhere else in your code.
