abstract class AccountEditProfileStates {}

class InitialAccountEditProfileStates extends AccountEditProfileStates {}

class LoadingAccountEditProfileStates extends AccountEditProfileStates {}

class SuccessAccountEditProfileStates extends AccountEditProfileStates {}

class FailureAccountEditProfileStates extends AccountEditProfileStates {
  final String errorMessage;

  FailureAccountEditProfileStates(this.errorMessage);
}
