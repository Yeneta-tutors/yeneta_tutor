// repository/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeneta_tutor/models/student_model.dart';
import 'package:yeneta_tutor/models/tutor_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signupStudent(
      Student student, String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('students').doc(userCredential.user?.uid).set({
      'name': student.name,
      'age': student.age,
      'sex': student.sex,
      'phoneNumber': student.phoneNumber,
      'address': student.address,
      'grade': student.grade,
      'subjectsOfInterest': student.subjectsOfInterest,
      'languagesSpoken': student.languagesSpoken,
    });
  }

  Future<void> signupTutor(Tutor tutor, String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('tutors').doc(userCredential.user?.uid).set({
      'name': tutor.name,
      'qualifications': tutor.qualifications,
      'experience': tutor.experience,
      'subjectsTaught': tutor.subjectsTaught,
      'hourlyRate': tutor.hourlyRate,
      'availability': tutor.availability,
    });
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error during login: $e');
      return null; // Return null in case of login failure
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
