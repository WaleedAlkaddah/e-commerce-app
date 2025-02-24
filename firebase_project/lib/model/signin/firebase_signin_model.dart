import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseSignInModel {
  final log = const Logger('FirebaseSignInModel');

  Future<Either<Failure, String>> searchUser({
    required String email,
    required String password,
  }) async {
    try {
      log.info("Email: $email, Password: $password", includeStackTrace: false);

      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log.fine("User signed in successfully: ${userCredential.user?.uid}",
          includeStackTrace: false);
      return Right(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log.error('No user found for that email.', includeStackTrace: false);
        return Left(Failure("No user found for that email."));
      } else if (e.code == 'wrong-password') {
        log.error('Wrong password provided for that user.',
            includeStackTrace: false);
        return Left(Failure("Wrong password provided."));
      } else if (e.code == 'invalid-email') {
        log.error('The email address is not valid.', includeStackTrace: false);
        return Left(Failure("Invalid email address."));
      } else if (e.code == 'user-disabled') {
        log.error('This user account has been disabled.',
            includeStackTrace: false);
        return Left(Failure("This account has been disabled."));
      } else if (e.code == 'too-many-requests') {
        log.error('Too many unsuccessful login attempts. Try again later.',
            includeStackTrace: false);
        return Left(
            Failure("Too many login attempts. Please try again later."));
      } else {
        log.error(
            'An unknown Firebase error occurred: ${e.message} : and e,code: ${e.code}',
            includeStackTrace: false);
        return Left(Failure("Unknown error occurred: ${e.message}"));
      }
    } catch (error) {
      log.error("Failed to search for user: $error", includeStackTrace: false);
      return Left(Failure("An unexpected error occurred. Please try again."));
    }
  }
}
