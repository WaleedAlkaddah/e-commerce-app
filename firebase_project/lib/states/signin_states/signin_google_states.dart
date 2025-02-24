abstract class SignInGoogleStates {}

class InitialSignInGoogleStates extends SignInGoogleStates {}

class LoadingSignInGoogleStates extends SignInGoogleStates {}

class SuccessSignInGoogleStates extends SignInGoogleStates {}

class FailureSignInGoogleStates extends SignInGoogleStates {
  final String errorMessage;

  FailureSignInGoogleStates(this.errorMessage);
}
