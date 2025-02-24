import 'package:firebase_project/states/signin_states/signin_forget_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/signin/firebase_forget_password_model.dart';
import '../../utility/signup_signin_utils.dart';

class ForgetPasswordViewModel extends Cubit<SignInForgetPasswordStates> {
  ForgetPasswordViewModel() : super(InitialSignInForgetPasswordStates());
  final log = const Logger('ForgetPasswordViewModel');

  void forgetPasswordResetViewModel() async {
    emit(LoadingSignInForgetPasswordStates());
    final model = FirebaseForgetPasswordModel();
    final checkModel = await model.forgetPasswordResetModel(
        WelcomeViewUtils.emailForgetPasswordController.text);
    checkModel.fold((failure) {
      log.error("Error is : ${failure.message}", includeStackTrace: false);
      emit(FailureSignInForgetPasswordStates(failure.message));
    }, (data) {
      log.fine("Password Reset Email Sent", includeStackTrace: false);
      emit(SuccessSignInForgetPasswordStates());
    });
  }
}
