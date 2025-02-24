abstract class AccountNewEditCardsStates {}

class InitialAccountNewEditCardsStates extends AccountNewEditCardsStates {}

class LoadingAccountNewEditCardsStates extends AccountNewEditCardsStates {}

class SuccessAccountNewEditCardsStates extends AccountNewEditCardsStates {}

class FailureAccountNewEditCardsStates extends AccountNewEditCardsStates {
  final String errorMessage;

  FailureAccountNewEditCardsStates(this.errorMessage);
}
