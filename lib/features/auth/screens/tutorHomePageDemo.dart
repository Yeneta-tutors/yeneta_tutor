import 'package:flutter/material.dart';

class TutorHomePageDemo extends StatelessWidget {
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
                        backgroundImage: AssetImage('images/yeneta_logo.jpg'), // Placeholder image
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Welcome Alex',/// first name of the tutor fetched from the database 
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
                            onPressed: () {
                              // Handle notification icon press
                    //           Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const messages(),
                    //   ),
                    // );
                            },
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
                      hintText: 'Filter my courses',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Categories text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_alt),
                        color: Colors.white,
                        onPressed: () {
                          // Open filter dialog
                          showDialog(
                            context: context,
                            builder: (_) => FilterDialog(),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            // Filter icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Most Subscribed Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle 'View All' press
                    },
                    child: Text('View all'),
                  ),
                ],
              ),
            ),

            // Most Subscribed Courses section with cards
            SizedBox(
              height: 200, // Height for the horizontally scrollable course cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CourseCard(
                    title: 'ALJEBRA 1',
                    rating: 4.5,
                    subject: 'MATHS',
                    price: '126',
                    grade: '11',
                    chapter: '1',
                    studentCount: 135,
                    onPressed: () {                    //onpress action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            title: 'ALJEBRA 1',
                            subject: 'mATHS',
                            price: '126',
                            grade: '11',
                            chapter: '1',
                            studentCount: '135',
                            rating: 4.5,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Repeat CourseCard instances as needed...
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // My Courses section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'My Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // List of tutor's courses
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                MyCourseCard(
                  title: 'Introduction to Physics',
                  chapter: '1',
                  grade: ' 10',
                  price: '126',
                  rating: 4,
                  studentCount: 7830,
                  subject: 'maths',
                    onPressed: () {                    //onpress action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            title: 'ALJEBRA 1',
                            subject: 'mATHS',
                            price: '126',
                            grade: '11',
                            chapter: '1',
                            studentCount: '135',
                            rating: 4.5,
                          ),
                        ),
                      );
                    },
                ),
                // Repeat MyCourseCard instances as needed...
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String subject;
  final String chapter;
  final String grade;
  final String price;
  final double rating;
  final int studentCount;
  final VoidCallback onPressed;

  const CourseCard({
    Key? key,
    required this.title,
    required this.subject,
    required this.chapter,
    required this.grade,
    required this.price,
    required this.studentCount,
    required this.rating,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4, // Adds shadow behind the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                'images/yeneta_logo.jpg',
                fit: BoxFit.cover,
                width: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment. spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),SizedBox(width: 15),
                      Text('Grade $grade',style: TextStyle(color: Colors.red),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Chapter:$chapter'),SizedBox(width: 10),
                      Text('Price: $price birr'),
                      // Text('Grade $grade'),
                    ],
                  ),
                  
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Icon(Icons.star, color: Colors.green, size: 16),
                  //     Text(
                  //       '$rating ($studentCount stud.)',
                  //       style: TextStyle(color: Colors.green),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//course details page made for test purpose you can delete it epha
class CourseDetailPage extends StatelessWidget {
  final String title;
  final String subject;
  final String chapter;
  final String grade;
  final String price;
  final double rating;
  final String studentCount;

  const CourseDetailPage({
    Key? key,
    required this.title,
    required this.subject,
    required this.chapter,
    required this.grade,
    required this.price,
    required this.rating,
    required this.studentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject: $subject'),
            Text('Chapter: $chapter'),
            Text('Grade: $grade'),
            Text('Price: $price birr'),
            Row(
              children: [
                Icon(Icons.star, color: Colors.green),
                Text('$rating'),
                SizedBox(width: 10),
                Text('$studentCount students enrolled'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//course detail page end
class MyCourseCard extends StatelessWidget {
  final String title;
  final String subject;
  final String chapter;
  final String grade;
  final String price;
  final double rating;
  final int studentCount;
   final VoidCallback onPressed;

  const MyCourseCard({
    Key? key,
    required this.title,
    required this.chapter,
    required this.grade,
    required this.subject,
    required this.price,
    required this.rating,
    required this.studentCount,
    required this.onPressed,
  }) : super(key: key);

  @override 
 Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 85, 80, 80).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'images/yeneta_logo.jpg',
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12), // Spacing between image and text
          // Text Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject Label
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Grade:$grade",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //  Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // chapter
                  Text(
                   'Chapter: $chapter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Price Text
                  Text(
                    '$price Birr',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
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





















