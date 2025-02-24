abstract class AccountShippingAddressStates {}

class InitialAccountShippingAddressStates
    extends AccountShippingAddressStates {}

class LoadingAccountShippingAddressStates
    extends AccountShippingAddressStates {}

class SuccessAccountShippingAddressStates
    extends AccountShippingAddressStates {}

class FailureAccountShippingAddressStates extends AccountShippingAddressStates {
  final String errorMessage;

  FailureAccountShippingAddressStates(this.errorMessage);
}
