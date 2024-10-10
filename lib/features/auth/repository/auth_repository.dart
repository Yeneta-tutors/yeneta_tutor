import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  // Sign up with email and password
  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String fatherName,
    required String grandFatherName,
    required String phoneNumber,
    required String gender,
    required UserRole role,
    required BuildContext context,
    File? profilePic,
    required ProviderRef ref,
  }) async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create a user profile document in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          firstName: firstName,
          fatherName: fatherName,
          grandFatherName: grandFatherName,
          phoneNumber: phoneNumber,
          gender: gender,
          role: role,
          profileImage: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await firestore.collection('users').doc(user.uid).set(newUser.toMap());

        // Upload profile picture if provided
        if (profilePic != null) {
          // Use Firebase Storage to upload the profile picture
          // Implement profile picture upload here
        }
      }
    } catch (e) {
      showSnackBar(context, "Error in signup");
    }
  }

  // Login with email and password
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {}
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      showSnackBar(context, "Error in reset password");
    }
  }

  // Fetch user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // Save user data to Firestore
  Future<void> saveUser({
    required UserModel user,
    required ProviderRef ref,
    File? profilePic,
  }) async {
    await firestore.collection('users').doc(user.uid).set(user.toMap());

    if (profilePic != null) {
      // Handle profile picture upload if required
    }
  }

  // Update user data
  Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await firestore.collection('users').doc(uid).update(updatedData);
  }

  // Stream user data
  Stream<UserModel> getUserStream(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>));
  }
}
