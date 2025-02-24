import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';

import '../model/explore/firebase_explore_model.dart';
import '../states/explore_states/explore_get_shoes_states.dart';

class ExploreUtils {
  static final TextEditingController searchController = TextEditingController();
  static String selectedItem = '';
  final log = const Logger('ExploreUtils');
}

class ExploreManShoesUtils {
  static late TabController tabController;
  static List<ShoesModel> getShoesListByType(
      SuccessExploreGetShoesStates state, ShoesType shoesType) {
    switch (shoesType) {
      case ShoesType.newBalance:
        return state.newBalanceShoes;
      case ShoesType.nike:
        return state.nikeShoes;
      case ShoesType.adidas:
        return state.adidasShoes;
      case ShoesType.puma:
        return state.pumaShoes;
    }
  }
}

enum ShoesType { newBalance, nike, adidas, puma }

class ExploreDetailsUtils {
  static final TextEditingController reviewsController =
      TextEditingController();
  static bool isFav = false;
  double rating = 0.0;
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  Color? getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case "gray":
        return Colors.grey;
      default:
        return null;
    }
  }

  Future<void> cartDetails({
    required Map<String, dynamic> dataStored,
  }) async {
    final cartData = await hivePreferencesData.storeHiveData(
        boxName: HiveBoxes.cartBox, key: HiveKeys.cartData, value: dataStored);

    final Map<String, dynamic> totalPrice = {
      'name': "totalPrice",
      'price': 0,
    };
    await hivePreferencesData.storeHiveData(
        boxName: HiveBoxes.cartBox,
        key: HiveKeys.totalPrice,
        value: totalPrice);

    if (cartData) {
      EasyLoading.showSuccess("Added!");
      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.showInfo("Added before!");
      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
      });
    }
  }

  String getProductType(dynamic product) {
    if (product is WatchesModel) return product.movementType;
    if (product is PhonesModel) return product.operatingSystem;
    if (product is ShoesModel) return product.heelHeight.toString();
    return "";
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0.r),
      border: Border.all(color: const Color(0xFFEBEBEB), width: 2.0.w),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff00C569).withValues(alpha: 0.7),
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
