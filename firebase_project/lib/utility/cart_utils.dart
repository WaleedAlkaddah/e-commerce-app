import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_project/navigation_bar_app.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';
import 'hive_preferences_data.dart';

class CartUtils {
  final log = const Logger('CartUtils');
  List<dynamic> cartData = [];
  int productsRealPrice = 0;
  double totalPrice = 0.0;
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  Future<bool> getCartData(
      {required String boxName, required String key}) async {
    try {
      cartData = await hivePreferencesData.retrieveHiveData(
          boxName: HiveBoxes.cartBox, key: HiveKeys.cartData);
      await getTotalPrice();
      return true;
    } catch (e) {
      log.error("Error while get cart: $e", includeStackTrace: false);
      return false;
    }
  }

  Future<void> increaseQuantity(String productName) async {
    try {
      var product = cartData.firstWhere((item) => item['name'] == productName,
          orElse: () => null);
      if (product != null) {
        if (product['count'] > product['quantity']) {
          product['quantity'] = product['quantity'] + 1;
          product['price'] = product['price'] + product['real_price'];

          log.info(
              'Quantity increased for $productName with Quantity ${product['quantity']} and new Price ${product['price']}');
          final newQuantity = {
            "quantity": product['quantity'],
            "price": product["price"]
          };
          log.info(newQuantity);
          await hivePreferencesData.updateHiveData(
              boxName: HiveBoxes.cartBox,
              key: HiveKeys.cartData,
              itemName: productName,
              updatedData: newQuantity);
          await getTotalPrice();
        } else {
          EasyLoading.showError("Max of item in warehouse");
          await getTotalPrice();
        }
      }
    } catch (e) {
      log.error("Error while increase $e");
    }
  }

  Future<void> decreaseQuantity(String productName) async {
    try {
      var product = cartData.firstWhere((item) => item['name'] == productName,
          orElse: () => null);
      if (product != null && product['quantity'] > 1) {
        product['quantity'] = product['quantity'] - 1;
        product['price'] = product['price'] - product['real_price'];
        log.info(
            'Quantity decreased for $productName with price ${product["price"]}');
        final newQuantity = {
          "quantity": product['quantity'],
          "price": product["price"]
        };
        await hivePreferencesData.updateHiveData(
            boxName: HiveBoxes.cartBox,
            key: HiveKeys.cartData,
            itemName: productName,
            updatedData: newQuantity);
        await getTotalPrice();
      } else {
        EasyLoading.showError("Minimum is one quantity");
        await getTotalPrice();
      }
    } catch (e) {
      log.error("Error while increase $e");
    }
  }

  Future<void> deleteItemCart(String nameToDelete) async {
    try {
      await hivePreferencesData.deleteFromHive(
          boxName: HiveBoxes.cartBox,
          key: HiveKeys.cartData,
          nameToDelete: nameToDelete);
    } catch (e) {
      log.error("Error: $e");
    }
  }

  Future<void> getTotalPrice() async {
    try {
      totalPrice = cartData.fold(0, (previousValue, cartItem) {
        return previousValue + cartItem['price'];
      });
      final dataStored = {
        'price': totalPrice,
      };
      await hivePreferencesData.updateHiveData(
          boxName: HiveBoxes.cartBox,
          key: HiveKeys.totalPrice,
          itemName: "totalPrice",
          updatedData: dataStored);
    } catch (e) {
      log.error("Error While get total price $e");
    }
  }

  Future<void> moveToFavorites(Map<String, dynamic> cartData) async {
    final dataStored = {
      "name": cartData["name"],
      "image": cartData["image"],
      "price": cartData["price"],
    };
    log.info(dataStored);
    await hivePreferencesData.storeHiveData(
      boxName: HiveBoxes.favoritesBox,
      key: HiveKeys.favoritesData,
      value: dataStored,
    );

    await deleteFromCart(cartData);
  }

  Future<void> removeFromCart(Map<String, dynamic> cartData) async {
    await deleteFromCart(cartData);
  }

  Future<void> deleteFromCart(Map<String, dynamic> cartData) async {
    await hivePreferencesData.deleteFromHive(
      boxName: HiveBoxes.cartBox,
      nameToDelete: cartData["name"],
      key: HiveKeys.cartData,
    );
    await hivePreferencesData.deleteFromHive(
      boxName: HiveBoxes.cartBox,
      nameToDelete: cartData["name"],
      key: HiveKeys.productPrice,
    );
  }
}

class CheckoutUtils {
  final log = const Logger('CheckoutUtils');
  static int activeStep = 0;
  static bool isChecked = true;
  TextEditingController streetController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();
  bool isCvvFocused = false;

  var data = {};
  static List<EasyStep> steps = [
    EasyStep(
      icon: Icon(
        Icons.check_circle,
        color: activeStep == 0 ? Colors.green : Colors.grey,
      ),
      title: 'Delivery',
    ),
    EasyStep(
      icon: Icon(
        Icons.check_circle,
        color: activeStep == 1 ? Colors.green : Colors.grey,
      ),
      title: 'Address',
    ),
    EasyStep(
      icon: Icon(
        Icons.check_circle,
        color: activeStep == 1 ? Colors.green : Colors.grey,
      ),
      title: 'Payments',
    ),
  ];

  Future<void> getUserAddress(BuildContext context) async {
    try {
      data = await HivePreferencesData().retrieveHiveData(
          boxName: HiveBoxes.addressBox, key: HiveKeys.address);
      log.info(data);
      final street = data["street"];
      final country = data["country"];
      final city = data["locality"];
      streetController.text = street;
      countryController.text = country;
      cityController.text = city;
    } catch (e) {
      log.error("Error while retrieve address from Hive $e");
      if (!context.mounted) return;
      GlobalUtils().showCustomSnackBar(
          message: 'Error while retrieving address. Check you Data!',
          title: "Error",
          type: ToastificationType.error);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const NavigationBarApp(
                  index: 1,
                )),
      );
    }
  }

  Future<void> getUserCreditCard(BuildContext context) async {
    try {
      data = await HivePreferencesData().retrieveHiveData(
          boxName: HiveBoxes.creditCardBox, key: HiveKeys.creditCard);
      log.info(data);
      final cardNumber = data["card_number"];
      final cardHolder = data["card_holder"];
      final expiryDate = data["expiry_date"];
      final cvvCode = data["cvv_code"];
      cardHolderNameController.text = cardHolder;
      cardNumberController.text = cardNumber;
      expiryDateController.text = expiryDate;
      cvvCodeController.text = cvvCode;
    } catch (e) {
      log.error("Error while retrieve creditCard from Hive $e");
      if (!context.mounted) return;
      GlobalUtils().showCustomSnackBar(
          message: 'Error while retrieving creditCard. Check you Data!',
          title: "Error",
          duration: 3,
          type: ToastificationType.error);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const NavigationBarApp(
                  index: 1,
                )),
      );
    }
  }
}

class SummaryUtils {
  final log = const Logger('SummaryUtils');

  final List cartData = [];
  final List address = [];
  final List creditCard = [];

  Future<dynamic> loadData() async {
    final data1 = await HivePreferencesData()
        .retrieveHiveData(boxName: HiveBoxes.cartBox, key: HiveKeys.cartData);
    cartData.add(data1);
    final data2 = await HivePreferencesData()
        .retrieveHiveData(boxName: HiveBoxes.addressBox, key: HiveKeys.address);
    address.add(data2);

    final data3 = await HivePreferencesData().retrieveHiveData(
        boxName: HiveBoxes.creditCardBox, key: HiveKeys.creditCard);
    creditCard.add(data3);

    final dataReturn = {
      "cartData": cartData,
      "address": address,
      "creditCard": creditCard
    };
    return dataReturn;
  }
}
