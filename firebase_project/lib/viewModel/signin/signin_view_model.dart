import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/states/signin_states/signin_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/signin/firebase_signin_model.dart';
import '../../utility/signup_signin_utils.dart';

class SignInViewModel extends Cubit<SignInStates> {
  SignInViewModel() : super(InitialSignInStates());
  final log = const Logger('SignInViewModel');

  void searchUserViewModel() async {
    emit(LoadingSignInStates());

    final model = FirebaseSignInModel();
    final result = await model.searchUser(
      email: WelcomeViewUtils.emailController.text.trim(),
      password: WelcomeViewUtils.passwordController.text.trim(),
    );

    await result.fold(
      (failure) {
        log.error("Search User failed: ${failure.message}",
            includeStackTrace: false);
        emit(FailureSignInStates(failure.message));
      },
      (data) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null && user.emailVerified) {
          log.info("User found and verified!", includeStackTrace: false);
          emit(SuccessSignInStates());
        } else if (user != null) {
          log.info("User found but email not verified.",
              includeStackTrace: false);
          await sendEmailVerification(user);
        } else {
          log.error("User is null after sign-in!", includeStackTrace: false);
          emit(FailureSignInStates("Unexpected error: User is null."));
        }
      },
    );
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      log.info("Verification email sent.", includeStackTrace: false);
      emit(FailureSignInStates("Email not verified. Verification email sent!"));
    } catch (error) {
      log.error("Failed to send verification email: $error",
          includeStackTrace: false);
      emit(FailureSignInStates(
          "Failed to send verification email. Please try again."));
    }
  }
}
