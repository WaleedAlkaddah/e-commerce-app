abstract class CheckoutStates {}

class InitialCheckoutStates extends CheckoutStates {}

class LoadingCheckoutStates extends CheckoutStates {}

class SuccessCheckoutStates extends CheckoutStates {
  final String orderId;
  SuccessCheckoutStates(this.orderId);
}

class FailureCheckoutStates extends CheckoutStates {
  final String message;
  FailureCheckoutStates(this.message);
}
