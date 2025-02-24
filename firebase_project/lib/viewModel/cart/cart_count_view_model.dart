import 'package:firebase_project/states/cart_states/cart_count_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../utility/cart_utils.dart';

class CartCountViewModel extends Cubit<CartCountState> {
  final CartUtils cartUtils = CartUtils();
  final log = const Logger('CartCountViewModel');

  CartCountViewModel() : super(InitialCartCountState());

  Future<void> loadCartViewModel() async {
    try {
      emit(LoadingCartCountState());
      final checkData =
          await cartUtils.getCartData(boxName: "cart_box", key: "cart_data");
      if (checkData == true) {
        emit(SuccessCartCountState(cartUtils.cartData));
      }
    } catch (e) {
      emit(FailureCartCountState('Failed to load cart data'));
    }
  }

  Future<void> increaseQuantityViewModel(String productName) async {
    try {
      await cartUtils.increaseQuantity(productName);
      emit(SuccessCartCountState(cartUtils.cartData));
    } catch (e) {
      emit(FailureCartCountState('Failed to increase quantity'));
    }
  }

  Future<void> decreaseQuantityViewModel(String productName) async {
    try {
      await cartUtils.decreaseQuantity(productName);
      emit(SuccessCartCountState(cartUtils.cartData));
    } catch (e) {
      emit(FailureCartCountState('Failed to decrease quantity'));
    }
  }
}
