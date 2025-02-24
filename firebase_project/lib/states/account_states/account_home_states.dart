import 'package:firebase_project/model/account/firebase_account_model.dart';

abstract class AccountHomeStates {}

class InitialAccountHomeStates extends AccountHomeStates {}

class LoadingAccountHomeStates extends AccountHomeStates {}

class SuccessAccountHomeStates extends AccountHomeStates {
  final FirebaseAccountHomeModel firebaseAccountModel;
  SuccessAccountHomeStates(this.firebaseAccountModel);
}

class FailureAccountHomeStates extends AccountHomeStates {
  final String errorMessage;
  FailureAccountHomeStates(this.errorMessage);
}
