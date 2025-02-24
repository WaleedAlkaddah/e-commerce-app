import 'package:firebase_project/states/cart_states/cart_total_states.dart';
import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class CartTotalViewModel extends Cubit<CartTotalStates> {
  final CartUtils cartUtils = CartUtils();
  final log = const Logger('CartTotalViewModel');
  CartTotalViewModel() : super(InitialCartTotalStates());

  Future<void> getTotalPriceViewModel() async {
    try {
      final storedData = await HivePreferencesData().retrieveHiveData(
          boxName: HiveBoxes.cartBox, key: HiveKeys.totalPrice);
      if (storedData != null) {
        final storedTotalPrice = storedData.first;
        if (storedTotalPrice.containsKey("price")) {
          double total = storedTotalPrice['price'];
          log.info("Total price: $total");
          emit(SuccessCartTotalStates(total));
        } else {
          log.error('Key "price" not found in the item');
          emit(FailureCartTotalStates('Key "price" not found in the item'));
        }
      } else {
        await cartUtils.getTotalPrice();
        emit(SuccessCartTotalStates(cartUtils.totalPrice));
      }
    } catch (e) {
      log.error('Failed to retrieve or calculate total price');
      emit(FailureCartTotalStates(
          'Failed to retrieve or calculate total price'));
    }
  }
}
