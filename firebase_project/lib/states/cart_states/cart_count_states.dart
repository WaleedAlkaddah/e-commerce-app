abstract class CartCountState {}

class InitialCartCountState extends CartCountState {}

class LoadingCartCountState extends CartCountState {}

class SuccessCartCountState extends CartCountState {
  final List<dynamic> cartItems;

  SuccessCartCountState(this.cartItems);
}

class FailureCartCountState extends CartCountState {
  final String message;
  FailureCartCountState(this.message);
}
