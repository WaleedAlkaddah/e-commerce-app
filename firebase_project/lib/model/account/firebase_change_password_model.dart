import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseChangePasswordModel {
  final log = const Logger('FirebaseChangePasswordModel');

  Either<Failure, String> handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        log.error("Wrong old password!", includeStackTrace: false);
        return Left(Failure("The current password you entered is incorrect."));
      case 'user-mismatch':
      case 'user-not-found':
        log.error("User not found or mismatched!", includeStackTrace: false);
        return Left(Failure("User not found or doesn't have a password."));
      case 'requires-recent-login':
        log.error("Re-authentication required!", includeStackTrace: false);
        return Left(Failure("Please re-authenticate and try again."));
      default:
        log.error("Failed to update password: ${e.message}",
            includeStackTrace: false);
        return Left(Failure("Failed to update password: ${e.message}"));
    }
  }

  Future<Either<Failure, String>> updatePasswordModel({
    required String newPassword,
    required String oldPassword,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      return Left(Failure("No user is currently signed in."));
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      log.fine("Re-authentication successful!", includeStackTrace: false);

      await user.updatePassword(newPassword);
      log.fine("Password updated successfully!", includeStackTrace: false);

      return const Right("Password updated successfully!");
    } on FirebaseAuthException catch (e) {
      return handleError(e);
    } catch (e) {
      log.error("An unexpected error occurred: $e", includeStackTrace: false);
      return Left(Failure("An unexpected error occurred. Please try again."));
    }
  }
}
