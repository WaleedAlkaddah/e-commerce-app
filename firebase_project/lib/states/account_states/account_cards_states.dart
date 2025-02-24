import '../../model/account/firebase_account_model.dart';

abstract class AccountCardsStates {}

class InitialAccountCardsStates extends AccountCardsStates {}

class LoadingAccountCardsStates extends AccountCardsStates {}

class SuccessAccountCardsStates extends AccountCardsStates {
  final List<CreditCardsModel> creditCardsModel;
  SuccessAccountCardsStates(this.creditCardsModel);
}

class FailureAccountCardsStates extends AccountCardsStates {
  final String errorMessage;
  FailureAccountCardsStates(this.errorMessage);
}
