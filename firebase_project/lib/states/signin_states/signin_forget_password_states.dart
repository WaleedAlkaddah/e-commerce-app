abstract class SignInForgetPasswordStates {}

class InitialSignInForgetPasswordStates extends SignInForgetPasswordStates {}

class LoadingSignInForgetPasswordStates extends SignInForgetPasswordStates {}

class SuccessSignInForgetPasswordStates extends SignInForgetPasswordStates {}

class FailureSignInForgetPasswordStates extends SignInForgetPasswordStates {
  final String errorMessage;

  FailureSignInForgetPasswordStates(this.errorMessage);
}
