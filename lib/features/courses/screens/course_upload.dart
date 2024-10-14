import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/courses/controller/course_controller.dart';
import 'package:yeneta_tutor/models/course_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CourseUploadPage extends ConsumerStatefulWidget {
  final Course? course;
  CourseUploadPage({this.course});

  @override
  _CourseUploadPageState createState() => _CourseUploadPageState();
}

class _CourseUploadPageState extends ConsumerState<CourseUploadPage> {
  final _formKey = GlobalKey<FormState>();
  String? _grade;
  String? _subject;
  String? _chapter;
  File? _demoVideoFile;
  File? _courseVideoFile;
  File? _thumbnailFile;

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      // Populate form with existing course data
      _titleController.text = widget.course!.title;
      _descriptionController.text = widget.course!.description;
      _priceController.text = widget.course!.price.toString();
      _grade = widget.course!.grade;
      _subject = widget.course!.subject;
      _chapter = widget.course!.chapter;
      // For file fields (videos and image), you'll need to fetch or load the file separately if necessary
    }
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Function to pick files (demo video, course video, and image)
  Future<File?> _pickFile(String type) async {
    FileType fileType = type == 'video' ? FileType.video : FileType.image;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Access CourseController using Riverpod
    final courseController = ref.watch(courseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Upload Course' : 'Edit Course'),
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
                isExpanded: false,
                dropdownColor: Colors.grey[200], // Customize dropdown background color
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
               iconSize: 20, 
               menuMaxHeight: 200,
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
                isExpanded: false,
                dropdownColor: Colors.grey[200], // Customize dropdown background color
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
               iconSize: 20, 
               menuMaxHeight: 200,
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
                isExpanded: false,
                dropdownColor: Colors.grey[200], // Customize dropdown background color
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
               iconSize: 20, 
               menuMaxHeight: 200,
              ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  _demoVideoFile = await _pickFile('video');
                  if (_demoVideoFile != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Demo video selected')),
                    );
                  }
                },
                child: Text('Select Demo Video'),
              ),

              // Select Course Video Button
              ElevatedButton(
                onPressed: () async {
                  _courseVideoFile = await _pickFile('video');
                  if (_courseVideoFile != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Course video selected')),
                    );
                  }
                },
                child: Text('Select Course Video'),
              ),

              // Select Thumbnail Image Button
              ElevatedButton(
                onPressed: () async {
                  await _requestStoragePermission();
                  _thumbnailFile = await _pickFile('image');
                  if (_thumbnailFile != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thumbnail image selected')),
                    );
                  }
                },
                child: const Text('Select Image'),
              ),

              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price Input Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Birr'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create or update the Course object
                    Course course = Course(
                      courseId: widget.course?.courseId ??'', 
                      teacherId: '', 
                      title: _titleController.text,
                      grade: _grade!,
                      subject: _subject!,
                      chapter: _chapter!,
                      description: _descriptionController.text,
                      videoUrl: '', 
                      demoVideoUrl: '',
                      price: double.tryParse(_priceController.text) ?? 0.0,
                      thumbnail: '', 
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    if (widget.course == null) {
                      // Adding a new course
                     courseController.addCourse(
                        course: course,
                        videoFile: _courseVideoFile,
                        demoVideoFile: _demoVideoFile,
                        thumbnailFile: _thumbnailFile,
                        context: context,
                      );
                    } else {
                      // Updating an existing course
                      await courseController.updateCourse(
                        course,
                        grade: course.grade, 
                        subject: course.subject, 
                        chapter: course.chapter,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Course updated successfully')),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Course uploaded successfully')),
                    );

                    // Navigate back after successful upload/update
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
