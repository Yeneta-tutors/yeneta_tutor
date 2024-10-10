// ignore_for_file: public_member_api_docs, sort_constructors_first
enum UserRole {
  student, // 1
  tutor, // 2
  admin, // 3
}

// models/user_model.dart
class UserModel {
  final String uid;
  final String firstName;
  final String fatherName;
  final String grandFatherName;
  final String gender;
  final String phoneNumber;
  final String email; // Store as hash
  final String? grade;
  final UserRole role;
  final List<String>? languageSpoken;
  final String? educationalQualification;
  final String? subject;
  final String? graduationDepartment;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.fatherName,
    required this.grandFatherName,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    this.grade,
    required this.role,
    this.languageSpoken,
    this.educationalQualification,
    this.subject,
    this.graduationDepartment,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'first_name': firstName,
      'father_name': fatherName,
      'grand_father_name': grandFatherName,
      'gender': gender,
      'phone_number': phoneNumber,
      'email': email,
      'grade': grade,
      'role': role.index,
      'language_spoken': languageSpoken,
      'educational_qualification': educationalQualification,
      'graduation_department': graduationDepartment,
      'subject': subject,
      'profile_image': profileImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['first_name'],
      fatherName: map['father_name'],
      grandFatherName: map['grand_father_name'],
      gender: map['gender'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      grade: map['grade'],
      role: UserRole.values[map['role']],
      languageSpoken: List<String>.from(map['language_spoken']),
      educationalQualification: map['educational_qualification'],
      graduationDepartment: map['graduation_department'],
      subject: map['subject'],
      profileImage: map['profile_image'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }
}
