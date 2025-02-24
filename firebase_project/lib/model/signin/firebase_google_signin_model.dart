import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_log/quick_log.dart';
import '../signup/firebase_signup_model.dart';

class FirebaseGoogleSignInModel {
  final log = const Logger('FirebaseGoogleSignInModel');
  final FirebaseSignupModel firebaseSignupModel = FirebaseSignupModel();

  Future<Either<Failure, String>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log.warning('Google sign-in was aborted by the user.',
            includeStackTrace: false);
        return Left(Failure('Google sign-in was aborted by the user.'));
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        log.error(
            'Google authentication failed: Missing token. ${googleAuth.accessToken} : ${googleAuth.idToken}');
        return Left(Failure('Google authentication failed.'));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String userId = user.uid;
        final List<String> nameParts = (user.displayName ?? '').split(' ');
        final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final String lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        final String email = user.email ?? '';
        final String image = user.photoURL ?? '';

        final bool result = await firebaseSignupModel.addUserModelFireStore(
          firstName: firstName,
          lastName: lastName,
          email: email,
          image: image,
          userId: userId,
        );

        if (!result) {
          log.error('Failed to add user to FireStore after Google Sign-In.');
          return Left(Failure('Failed to add user to FireStore.'));
        }

        log.fine('User signed in with Google successfully, userId: $userId');
        return Right(userId);
      }

      log.error('User is null after Google Sign-In!');
      return Left(Failure('User is null after Google Sign-In.'));
    } on FirebaseAuthException catch (e) {
      log.error('FirebaseAuthException: ${e.code} - ${e.message}');
      return Left(Failure('FirebaseAuthException: ${e.message}'));
    } on Exception catch (e) {
      log.error('An error occurred during Google Sign-In: $e');
      return Left(Failure('An error occurred during Google Sign-In $e'));
    }
  }
}
