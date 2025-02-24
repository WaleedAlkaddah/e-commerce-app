import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseForgetPasswordModel {
  final log = const Logger('FirebaseForgetPasswordModel');

  Future<Either<Failure, String>> forgetPasswordResetModel(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      log.info("Password reset email sent successfully to $email");
      return Right(
          "A password reset email has been sent to $email. Please check your inbox.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log.error("No user found for email: $email");
        return Left(Failure("No account found for this email."));
      } else if (e.code == 'invalid-email') {
        log.error("Invalid email: $email");
        return Left(
            Failure("Invalid email address. Please check and try again."));
      } else {
        log.error("FirebaseAuthException: ${e.code}, Message: ${e.message}");
        return Left(Failure("Something went wrong. Please try again later."));
      }
    } catch (e) {
      log.error("Unexpected error occurred: $e");
      return Left(Failure("Unexpected error. Please try again."));
    }
  }
}
