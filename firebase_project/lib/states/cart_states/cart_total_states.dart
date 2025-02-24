abstract class CartTotalStates {}

class InitialCartTotalStates extends CartTotalStates {}

class LoadingCartTotalStates extends CartTotalStates {}

class SuccessCartTotalStates extends CartTotalStates {
  final double totalPrice;

  SuccessCartTotalStates(this.totalPrice);
}

class FailureCartTotalStates extends CartTotalStates {
  final String message;
  FailureCartTotalStates(this.message);
}
