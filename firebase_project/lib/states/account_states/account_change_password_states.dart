abstract class AccountChangePasswordStates {}

class InitialAccountChangePasswordStates extends AccountChangePasswordStates {}

class LoadingAccountChangePasswordStates extends AccountChangePasswordStates {}

class SuccessAccountChangePasswordStates extends AccountChangePasswordStates {}

class FailureAccountChangePasswordStates extends AccountChangePasswordStates {
  final String errorMessage;

  FailureAccountChangePasswordStates(this.errorMessage);
}
