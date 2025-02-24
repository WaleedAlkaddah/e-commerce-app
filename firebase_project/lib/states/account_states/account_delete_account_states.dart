abstract class AccountDeleteAccountStates {}

class InitialAccountDeleteAccountStates extends AccountDeleteAccountStates {}

class LoadingAccountDeleteAccountStates extends AccountDeleteAccountStates {}

class SuccessAccountDeleteAccountStates extends AccountDeleteAccountStates {}

class FailureAccountDeleteAccountStates extends AccountDeleteAccountStates {
  final String errorMessage;

  FailureAccountDeleteAccountStates(this.errorMessage);
}
