import 'package:flutter/material.dart';

class TutorProfileForStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 19, 58),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Curved blue-black background section
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 19, 58), // Blue-black color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'images/avatar_image.png', // Replace with actual image
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50), // Padding between image and name
          Text(
            "Esubalew",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
           
          ),
           ),
           SizedBox(height: 20),
          Text("A teacher with 5 years of experiance")
        ],
      ),
    );
  }
}
