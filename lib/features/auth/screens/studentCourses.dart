import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/studentDetailsPage.dart';

class CoursesPage extends StatelessWidget {

    final String course;

  CoursesPage({required this.course});

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
          'Courses',
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
              child:TextField(
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
                          builder: (context) => CourseDetailsPage(course: course),
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
          // Course image with rounded corners
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
          // Grade text (bottom left corner)
          Positioned(
            bottom: 5,
            left: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7), // Black background with opacity
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Grade ${course['grade']}', // Dynamic grade text
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          // Chapter text (bottom right corner)
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7), // Black background with opacity
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Chapter ${course['chapter']}', // Dynamic chapter text
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
                      AssetImage('images/maths_thumbnail.jpg'), // Tutor profile image
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
  // String priceOrder = 'Cheaper to Expensive';
  // bool mostSold = false;

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Courses'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                dropdownColor: Colors.grey[200], // Customize dropdown background color
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
               iconSize: 20, 
               menuMaxHeight: 200,
            ),

            // Price Filter
            // Text('Price'),
            // DropdownButton<String>(
            //   value: priceOrder,
            //   items: ['Cheaper to Expensive', 'Expensive to Cheaper'].map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       priceOrder = value!;
            //     });
            //   },
            // ),

            // Most Sold Filter
            // CheckboxListTile(
            //   title: Text('Most Sold'),
            //   value: mostSold,
            //   onChanged: (value) {
            //     setState(() {
            //       mostSold = value!;
            //     });
            //   },
            // ),
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








// // Dummy CourseDetail Page
// class CourseDetail extends StatelessWidget {
//   final Map<String, dynamic> course;

//   CourseDetail({required this.course});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(course['title']),
//       ),
//       body: Center(
//         child: Text(
//           'Details for ${course['title']}',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
