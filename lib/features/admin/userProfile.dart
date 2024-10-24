import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('User Management > Profile student'),
        backgroundColor: Colors.grey[850],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Row(
              children: [
                Text('Hello, Esubalew', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('images/avator_image.png'), // Admin image
                ),
              ],
            ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Details Container
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/avator_image.png'), // User image here
                        ),
                        Positioned(
                          bottom: -20,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Name: Abebe Kebede',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Gender: Female',
                      style: TextStyle(fontSize: 16),
                    ),SizedBox(height: 5),
                    Text(
                      'Email: abc@gmail.com',
                      style: TextStyle(fontSize: 16),
                    ),SizedBox(height: 5),
                    Text(
                      'Phone: 0912545848',
                      style: TextStyle(fontSize: 16),
                    ),SizedBox(height: 5),
                    Text(
                      'Grade: 11',
                      style: TextStyle(fontSize: 16),
                    ),SizedBox(height: 5),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          // Block user functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Button background color
                          minimumSize: Size(200, 50), // Set minimum width and height
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Small border radius for rectangular shape
                          ),
                        ),
                        child: Text(
                          'Block User',
                          style: TextStyle(fontSize: 18,color: Colors.white), // Larger font size for the button text
                        ),
                      )

                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            // Subscribed Courses Container
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Search bar and filter
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.filter_list),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Scrollable courses
                  Expanded(
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        double cardAspectRatio = (constraints.maxWidth < 400) ? 0.7 : 1.0; // Adjust based on screen width
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 16, // Spacing between cards
            mainAxisSpacing: 16, // Spacing between rows
            childAspectRatio: cardAspectRatio, // Adjust card height based on width
          ),
          itemCount: 6, // Number of courses
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Redirect to course details
              },
              child: CourseCard(),
            );
          },
        );
      },
    ),
  ),
),

                ],
              ),
            ),
            SizedBox(width: 16),
            // Bar Chart Container
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Placeholder(), // Replace with actual chart widget
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SubjectIndicator(color: Colors.blue, subject: 'Math', count: 2),
                        SubjectIndicator(color: Colors.green, subject: 'Physics', count: 4),
                        SubjectIndicator(color: Colors.pink, subject: 'Biology', count: 2),
                        SubjectIndicator(color: Colors.orange, subject: 'Chemistry', count: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width
      height: 350, // Fixed height
      margin: EdgeInsets.all(8), // Margin around the card
      decoration: BoxDecoration(
        color: Colors.green[100], // Background color of the card
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section for the course image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'images/yeneta_logo.jpg', // Replace with the course image
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Grade 11',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Chapter 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Course Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Measurements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Tutor Info, Rating, and Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                // Tutor Image
                CircleAvatar(
                  backgroundImage: AssetImage('images/avator_image.png'), // Replace with the tutor image
                  radius: 20,
                ),
                SizedBox(width: 4),
                // Tutor Name and Rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.star,
                    //       color: Colors.yellow[700],
                    //       size: 18,
                    //     ),
                    //     SizedBox(width: 4),
                    //     Text(
                    //       '4.2',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Spacer(),
                // Course Price
                Text(
                  '28 Birr',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CourseCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.green[100],
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             children: [
//               // Course Thumbnail Image
//               Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height * 0.15, // Adjust image height based on screen size
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   image: DecorationImage(
//                     image: AssetImage('images/yeneta_logo.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               // Grade text at bottom-left corner of the image
//               Positioned(
//                 bottom: 8,
//                 left: 8,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   color: Colors.black.withOpacity(0.7),
//                   child: Text(
//                     'Grade 11',
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ),
//               // Chapter text at bottom-right corner of the image
//               Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   color: Colors.black.withOpacity(0.7),
//                   child: Text(
//                     'Chapter 2',
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           // Course title and details
//           FittedBox(
//             child: Text('Physics', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           FittedBox(
//             child: Text('Measurements', style: TextStyle(color: Colors.grey)),
//           ),
//           SizedBox(height: 4),
//           Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Row(
//       children: [
//         CircleAvatar(
//           radius: 12, 
//           backgroundImage: AssetImage('images/avator_image.png'), 
//         ),
//         SizedBox(width: 8), // Space between avatar and text
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('John', style: TextStyle(color: Colors.grey)), // Name
//                 SizedBox(width: 25),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.yellow, size: 16), // Star Icon
//                     SizedBox(width: 2),
//                     Text('4.5', style: TextStyle(color: Colors.grey)), // Rating number
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     ),
//     // Price aligned to the right
//     Text('28 Birr', style: TextStyle(color: Colors.blue)),
//   ],
// )

//         ],
//       ),
//     );
//   }
// }




class SubjectIndicator extends StatelessWidget {
  final Color color;
  final String subject;
  final int count;

  SubjectIndicator({required this.color, required this.subject, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: color,
        ),
        SizedBox(height: 4),
        Text('$subject ($count)'),
      ],
    );
  }
}
