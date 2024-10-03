 // controllers/signup_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import 'package:yeneta_tutor/models/student_model.dart';
import 'package:yeneta_tutor/models/tutor_model.dart';

final signupControllerProvider = Provider((ref) => SignupController());

class SignupController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signupStudent(Student student, String email, String password) async {
    await _authRepository.signupStudent(student, email, password);
  }

  Future<void> signupTutor(Tutor tutor, String email, String password) async {
    await _authRepository.signupTutor(tutor, email, password);
  }
}
