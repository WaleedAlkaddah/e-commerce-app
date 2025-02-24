import 'package:firebase_project/model/account/firebase_account_add_cards_model.dart';
import 'package:firebase_project/model/checkout/firebase_checkout_update_model.dart';
import 'package:firebase_project/states/checkout_states/checkout_states.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class CheckoutViewModel extends Cubit<CheckoutStates> {
  CheckoutViewModel() : super(InitialCheckoutStates());
  final log = const Logger('CheckoutViewModel');

  Future<void> uploadDataViewModel(List<dynamic> summary) async {
    emit(LoadingCheckoutStates());

    try {
      final userData = await HivePreferencesData().retrieveHiveData(
        boxName: HiveBoxes.userBox,
        key: HiveKeys.dataUser,
      );

      if (userData == null || userData["uid"] == null) {
        log.error("User ID is null. Cannot proceed.");
        emit(FailureCheckoutStates("User ID not found."));
        return;
      }

      final String userId = userData["uid"];

      final List<Map<String, dynamic>> cartData = (summary[0] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      final Map<String, dynamic> address =
          Map<String, dynamic>.from(summary[1]);
      final Map<String, dynamic> creditCard =
          Map<String, dynamic>.from(summary[2]);

      final String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final Map<String, dynamic> orderData = {
        "orderId": orderId,
        "cart": cartData,
        "address": address,
        "creditCard": creditCard,
      };
      log.info("Order Data: $orderData");

      final FirebaseAccountAddCardsModel model = FirebaseAccountAddCardsModel();
      final result = await model.addDataToUserCollection(
        uid: userId,
        updatedData: orderData,
        key: "order",
      );

      result.fold(
        (failure) {
          log.error("Failed to update order: ${failure.message}");
          emit(FailureCheckoutStates(failure.message));
        },
        (data) async {
          log.fine("Order successfully added: $data");
          await updateProducts(cartData);
          emit(SuccessCheckoutStates(orderId));
        },
      );
    } catch (e) {
      log.error("Unexpected error occurred: $e");
      emit(FailureCheckoutStates("An unexpected error occurred."));
    }
  }

  Future<void> updateProducts(List<Map<String, dynamic>> cartData) async {
    final FirebaseCheckoutUpdateModel productUpdateModel =
        FirebaseCheckoutUpdateModel();

    final List<Map<String, dynamic>> productUpdates = cartData.map((cart) {
      return {
        "name": cart['name'],
        "docId": cart["docId"],
        "brand": cart["brand"].toLowerCase().replaceAll(' ', ''),
        "count": cart['count'] - cart['quantity'],
      };
    }).toList();

    log.info("Product Updates: $productUpdates");

    for (var product in productUpdates) {
      if (product["docId"] == "ShoesModel") {
        await productUpdateModel.updateShoeModel(product["brand"],
            product["name"], {"count": product["count"]}, "shoes");
      } else if (product["docId"] == "PhonesModel") {
        await productUpdateModel.updateShoeModel(product["brand"],
            product["name"], {"count": product["count"]}, "phones");
      } else if (product["docId"] == "WatchesModel") {
        await productUpdateModel.updateShoeModel(product["brand"],
            product["name"], {"count": product["count"]}, "watches");
      }
    }
  }
}
