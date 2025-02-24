import 'package:firebase_project/model/account/firebase_account_model.dart';

abstract class AccountAddressStates {}

class InitialAccountAddressStates extends AccountAddressStates {}

class LoadingAccountAddressStates extends AccountAddressStates {}

class SuccessAccountAddressStates extends AccountAddressStates {
  final AddressModel addressModel;
  SuccessAccountAddressStates(this.addressModel);
}

class FailureAccountAddressStates extends AccountAddressStates {
  final String errorMessage;

  FailureAccountAddressStates(this.errorMessage);
}
