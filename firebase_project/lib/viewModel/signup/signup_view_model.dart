import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/signup/firebase_signup_model.dart';
import '../../states/signup_states/signup_states.dart';
import '../../utility/signup_signin_utils.dart';

class SignupViewModel extends Cubit<SignupStates> {
  SignupViewModel() : super(InitialSignupState());
  final log = const Logger('SignupViewModel');

  void addUserViewModel() async {
    emit(LoadingSignupState());

    final model = FirebaseSignupModel();

    final checkModel = await model.addUserModel(
        firstName: SignupUtils.firstNameController.text,
        lastName: SignupUtils.lastNameController.text,
        email: SignupUtils.emailController.text,
        password: SignupUtils.passwordController.text);
    checkModel.fold((failure) {
      log.error("Sign up failed with error: ${failure.message}",
          includeStackTrace: false);
      emit(FailureSignupState(failure.message));
    }, (data) async {
      log.fine("User sign-up successful!");

      try {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        log.fine("Email verification sent successfully.");
        emit(SuccessSignupState());
      } catch (error) {
        log.error("Failed to send email verification: $error",
            includeStackTrace: false);
        emit(FailureSignupState(
            "Failed to send email verification. Please try again."));
        return;
      }
    });
  }
}
