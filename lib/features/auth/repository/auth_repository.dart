import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/common/repositories/common_firebase_storage_repository.dart';
import 'package:yeneta_tutor/features/auth/screens/tutorHomePage.dart';
import 'package:yeneta_tutor/models/user_model.dart';
import 'package:yeneta_tutor/features/auth/screens/studentHome.dart';
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
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String fatherName,
    required String grandFatherName,
    required String phoneNumber,
    required String gender,
    required String grade,
    required String educationalQualification,
    required String graduationDepartment,
    required String subject,
    required String bio,
    required UserRole role,
    required BuildContext context,
    File? profilePic,
    required ProviderRef ref,
  }) async {
    try {
      String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
      QuerySnapshot phoneCheck = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: formattedPhoneNumber)
          .get();

      if (phoneCheck.docs.isNotEmpty) {
        showSnackBar(context, 'Phone number already in use.');
        return;
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot emailCheck =
            await firestore.collection('users').doc(user.uid).get();

        if (emailCheck.exists) {
          await user.delete();
          showSnackBar(context, 'Email already in use.');
          return;
        }

        String photoUrl =
            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

        if (profilePic != null) {
          // Upload profile picture to Firebase Storage and get the URL
          String imageRef = 'profilePics/${user.uid}';
          photoUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(imageRef, profilePic);
        }

        // Create UserModel and save to Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          firstName: firstName,
          fatherName: fatherName,
          grandFatherName: grandFatherName,
          phoneNumber: phoneNumber,
          gender: gender,
          grade: grade,
          educationalQualification: educationalQualification,
          graduationDepartment: graduationDepartment,
          subject: subject,
          role: role,
          profileImage: photoUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await firestore.collection('users').doc(user.uid).set(newUser.toMap());

        // Navigate to the appropriate home page based on user role
        if (role == UserRole.student) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomePage(),
            ),
          );
        } else if (role == UserRole.tutor) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TutorHomePage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Email already in use.');
      } else {
        showSnackBar(context, 'Error: ${e.message}');
      }
    } catch (e) {
      showSnackBar(context, 'Error during signup: $e');
    }
  }

  // Login with email and password
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            UserModel userModel =
                UserModel.fromMap(data as Map<String, dynamic>);

            // Navigate to the appropriate home page based on user role
            if (userModel.role == UserRole.student) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentHomePage(),
                ),
              );
            } else if (userModel.role == UserRole.tutor) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorHomePage(),
                ),
              );
            }
          } else {
            showSnackBar(context, "User document is null.");
          }
        } else {
          showSnackBar(context, "User not found in the database.");
        }
      }
    } catch (e) {
      print("Login error: $e");
      showSnackBar(context, "Invalid email or password.");
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Password reset email sent.");
    } catch (e) {
      showSnackBar(context, "Error in reset password: $e");
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
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
      print("Error fetching user data: $e");
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
  required File? profilePic,
  required ProviderRef ref,
  required BuildContext context,
}) async {
  try {
  
    if (profilePic != null) {

      String imageRef = 'profilePics/$uid';  

      String photoUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(imageRef, profilePic);


      updatedData['profile_image'] = photoUrl;
    }

    await firestore.collection('users').doc(uid).update(updatedData);

  } catch (e) {
    showSnackBar(context, 'Failed to update user profile: $e');
   
  }
}

  // Get current user ID
  String getCurrentUserId() {
    return auth.currentUser?.uid ?? '';
  }

  // Stream user data
  Stream<UserModel> getUserStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("User document does not exist.");
      }
    });
  }
  Future<void> signOut() async {

    try {
      await auth.signOut();
    } catch (e) {
      throw Exception('Could not sign out: $e');
    }
    
  }

  Future<void> deleteAccount() async {
       try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete(); 
      }
    } catch (e) {
      throw Exception('Could not delete user: $e');
    }
  }


}


