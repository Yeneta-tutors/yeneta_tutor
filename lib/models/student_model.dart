// models/student_model.dart
class Student {
  final String name;
  final int age;
  final String sex;
  final String phoneNumber;
  final String address;
  final String grade;
  final List<String> subjectsOfInterest;
  final List<String> languagesSpoken;

  Student({
    required this.name,
    required this.age,
    required this.sex,
    required this.phoneNumber,
    required this.address,
    required this.grade,
    required this.subjectsOfInterest,
    required this.languagesSpoken,
  });
}

