abstract class AccountLogoutStates {}

class InitialAccountLogoutStates extends AccountLogoutStates {}

class LoadingAccountLogoutStates extends AccountLogoutStates {}

class SuccessAccountLogoutStates extends AccountLogoutStates {}

class FailureAccountLogoutStates extends AccountLogoutStates {
  final String errorMessage;

  FailureAccountLogoutStates(this.errorMessage);
}
