import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';




class CourseUploadPage extends StatefulWidget {
  @override
  _CourseUploadPageState createState() => _CourseUploadPageState();
}

class _CourseUploadPageState extends State<CourseUploadPage> {
  final _formKey = GlobalKey<FormState>();
  String? _grade;
  String? _subject;
  String? _chapter;
  FilePickerResult? _demoVideo;
  FilePickerResult? _courseVideo;
  FilePickerResult? _thumbnailImage;

  // Controllers for text fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  // Grade, Subject, and Chapter dropdown options
  final List<String> _grades = ['9', '10', '11', '12'];
  final List<String> _subjects = [
    'English',
    'Maths',
    'Physics',
    'Biology',
    'Chemistry',
    'Economics',
    'ICT'
  ];
  final List<String> _chapters = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
  ];

  // Function to pick files (demo video, course video, and image)
  Future<FilePickerResult?> _pickFile(String type) async {
    FileType fileType;
    if (type == 'video') {
      fileType = FileType.video;
    } else {
      fileType = FileType.image;
    }
    return await FilePicker.platform.pickFiles(
      type: fileType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('course upload'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Course Title Input Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course title';
                  }
                  return null;
                },
              ),

              // Grade Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Grade'),
                value: _grade,
                items: _grades.map((grade) {
                  return DropdownMenuItem(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _grade = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a grade';
                  }
                  return null;
                },
              ),

              // Subject Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Subject'),
                value: _subject,
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _subject = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a subject';
                  }
                  return null;
                },
              ),

              // Chapter Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Chapter'),
                value: _chapter,
                items: _chapters.map((chapter) {
                  return DropdownMenuItem(
                    value: chapter,
                    child: Text(chapter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _chapter = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a chapter';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Select Demo Video Button
              ElevatedButton(
                onPressed: () async {
                  _demoVideo = await _pickFile('video');
                  if (_demoVideo != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Demo video selected')),
                    );
                  }
                },
                child: Text('select demo video'),
              ),

              // Select Course Video Button
              ElevatedButton(
                onPressed: () async {
                  _courseVideo = await _pickFile('video');
                  if (_courseVideo != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Course video selected')),
                    );
                  }
                },
                child: Text('select video'),
              ),

              // Select Image Button
              ElevatedButton(
                onPressed: () async {
                  _thumbnailImage = await _pickFile('image');
                  if (_thumbnailImage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Image selected')),
                    );
                  }
                },
                child: Text('select image'),
              ),

              SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Price Input Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Birr'),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All inputs are valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Course uploaded successfully')),
                    );
                    // Process the data or send it to the database
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
