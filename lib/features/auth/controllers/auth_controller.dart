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

final userDataAuthProvider = StreamProvider<UserModel?>((ref) async* {
  final authController = ref.watch(authControllerProvider);

  await for (var user in authController.authStateChanges()) {
    if (user != null) {
      yield await authController.getUserData(user.uid);
    } else {
      yield null; // No user is signed in
    }
  }
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.ref, required this.authRepository});

  User? getCurrentUser() {
    return authRepository.auth.currentUser;
  }

  // get current user  id
  String getCurrentUserId() {
    return authRepository.getCurrentUserId();
  }

  Stream<User?> authStateChanges() {
    return authRepository.auth.authStateChanges();
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
    required String grade,
    required educationalQualification,
    required graduationDepartment,
    required subject,
    required bio,
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
      grade: grade,
      educationalQualification: educationalQualification,
      graduationDepartment: graduationDepartment,
      subject: subject,
      bio: bio,
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

  void sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) {
    authRepository.resetPassword(
      email: email,
      context: context,
    );
  }

  void updatePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) {
    authRepository.updatePassword(
        oldPassword: oldPassword, newPassword: newPassword, context: context);
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
    required BuildContext context,
  }) {
    authRepository.updateUser(
      uid: uid,
      updatedData: updatedData,
      ref: ref,
      profilePic: null,
      context: context,
    );
  }

  void updateUserProfile({
    required String uid,
    required Map<String, dynamic> profileData,
    File? profilePic,
    required BuildContext context,
  }) {
    authRepository.updateUser(
      uid: uid,
      updatedData: profileData,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  void signOut() {
    authRepository.signOut();
  }

  void deleteUser() {
    authRepository.deleteAccount();
  }
}
