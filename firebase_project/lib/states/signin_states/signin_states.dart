abstract class SignInStates {}

class InitialSignInStates extends SignInStates {}

class LoadingSignInStates extends SignInStates {}

class SuccessSignInStates extends SignInStates {}

class FailureSignInStates extends SignInStates {
  final String errorMessage;

  FailureSignInStates(this.errorMessage);
}
