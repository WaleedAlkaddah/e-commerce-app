import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseSignupModel {
  final log = const Logger('FirebaseSignupModel');

  Future<Either<Failure, String>> addUserModel({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user?.uid ?? '';

      if (userId.isNotEmpty) {
        bool isAdded = await addUserModelFireStore(
          firstName: firstName,
          lastName: lastName,
          email: email,
          userId: userId,
        );

        if (isAdded) {
          log.fine('User created successfully with ID: $userId',
              includeStackTrace: false);
          return Right(userId);
        } else {
          log.error('Failed to add user data to Firestore.',
              includeStackTrace: false);
          return Left(Failure("Failed to store user data in Firestore."));
        }
      } else {
        log.error('Failed to retrieve user ID after account creation.',
            includeStackTrace: false);
        return Left(
            Failure("Failed to retrieve user ID after account creation."));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = "An account already exists with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'weak-password') {
        errorMessage =
            "The password is too weak. It should be at least 6 characters long.";
      } else {
        errorMessage = "An unknown Firebase error occurred: ${e.message}";
      }

      log.error(errorMessage, includeStackTrace: false);
      return Left(Failure(errorMessage));
    } catch (error) {
      log.error("An unexpected error occurred: $error",
          includeStackTrace: false);
      return Left(Failure("An unexpected error occurred. Please try again."));
    }
  }

  Future<bool> addUserModelFireStore({
    required String firstName,
    required String lastName,
    required String email,
    String? image,
    required String userId,
  }) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await docRef.set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'image': image,
        'uid': userId,
      });

      log.fine('User added successfully with ID: $userId',
          includeStackTrace: false);
      return true;
    } on FirebaseException catch (e) {
      log.error('Failed to add user data to Firestore: $e',
          includeStackTrace: false);
      return false;
    }
  }
}
