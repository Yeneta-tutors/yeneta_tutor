import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider<UserModel?>((ref) async {
  try {
    final authController = ref.watch(authControllerProvider);
    final user = authController.getCurrentUser();
    if (user != null) {
      return await authController.getUserData(user.uid);
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return null;
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.ref, required this.authRepository});

  User? getCurrentUser() {
    return authRepository.auth.currentUser;
  }

  Future<UserModel?> getUserData(String uid) async {
    return await authRepository.getUserData(uid);
  }

  void signUpWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String fatherName,
    required String grandFatherName,
    required String phoneNumber,
    required String gender,
    required UserRole role,
    File? profilePic,
  }) {
    authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      firstName: firstName,
      fatherName: fatherName,
      grandFatherName: grandFatherName,
      phoneNumber: phoneNumber,
      gender: gender,
      role: role,
      context: context,
      profilePic: profilePic,
      ref: ref,
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    authRepository.login(
      email: email,
      password: password,
      context: context,
    );
  }

  void resetPassword({
    required String email,
    required BuildContext context,
  }) {
    authRepository.resetPassword(
      email: email,
      context: context,
    );
  }

  Stream<UserModel> getUserStream(String uid) {
    return authRepository.getUserStream(uid);
  }

  void saveUser({
    required UserModel user,
    File? profilePic,
  }) {
    authRepository.saveUser(
      user: user,
      ref: ref,
      profilePic: profilePic,
    );
  }

  void updateUser({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) {
    authRepository.updateUser(
      uid: uid,
      updatedData: updatedData,
    );
  }

  void signOut() {
    authRepository.auth.signOut();
  }

  void updateUserProfile({
    required String uid,
    required Map<String, dynamic> profileData,
    File? profilePic,
  }) {
    authRepository.updateUser(
      uid: uid,
      updatedData: profileData,
    );

    if (profilePic != null) {
      // Handle profile picture update logic here
    }
  }
}
