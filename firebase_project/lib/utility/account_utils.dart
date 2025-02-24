import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/view/signup-login/signin/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_log/quick_log.dart';

import 'global_utils.dart';

class AccountHomeUtils {
  final log = const Logger('AccountHomeUtils');
  static bool checkGoogle = false;
  static String defaultImage =
      'https://avatar.iran.liara.run/public/boy?username=Ash';

  Future<void> storeUserCartInHive(
      List<dynamic> userCart, Map<String, dynamic> totalPrice) async {
    Map<String, dynamic> dataStored = {};
    for (var item in userCart) {
      String name = item["name"] ?? "Name Unavailable";
      String image = item["image"] ?? "";
      int price = item["price"] ?? 0;
      int quantity = item["quantity"] ?? 0;
      int count = item["count"] ?? 0;
      dataStored = {
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
        'count': count,
        'real_price': price
      };
      await HivePreferencesData().storeHiveData(
          boxName: HiveBoxes.cartBox,
          key: HiveKeys.cartData,
          value: dataStored);
    }
    await HivePreferencesData().storeHiveData(
        boxName: HiveBoxes.cartBox,
        key: HiveKeys.totalPrice,
        value: totalPrice);
  }
}

class AccountEditProfileUtils {
  final log = const Logger('AccountEditProfileUtils');
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController newPasswordController = TextEditingController();
  static TextEditingController oldPasswordController = TextEditingController();
  static TextEditingController emailDeleteController = TextEditingController();
  static TextEditingController passwordDeleteController =
      TextEditingController();
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  Future<String?> pickImageUtils() async {
    final requestPermission = await GlobalUtils()
        .requestStoragePermission(Permission.manageExternalStorage);
    if (requestPermission) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSizeInBytes = await file.length();
        final fileSizeInKB = fileSizeInBytes / 1024;
        log.fine("Picked image path: ${pickedFile.path}",
            includeStackTrace: false);
        log.fine("Image size: ${fileSizeInKB.toStringAsFixed(2)} KB",
            includeStackTrace: false);
        final dataStored = {"image": pickedFile.path};
        log.info(dataStored);
        await hivePreferencesData.storeHiveData(
            boxName: HiveBoxes.imagePathBox,
            key: HiveKeys.imagePath,
            value: dataStored);
        return pickedFile.path;
      } else {
        log.error("No image selected.");
      }
    } else {
      log.error("Storage permission not granted.");
    }
    return null;
  }
}

class AccountShippingAddressUtils {
  final log = const Logger('AccountShippingAddressUtils');
  LatLng currentPosition = const LatLng(0, 0);
  Future<Map<String, dynamic>?> getUserLocationUtils() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      currentPosition = LatLng(position.latitude, position.longitude);
      log.info("currentPosition : $currentPosition", includeStackTrace: false);
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];
      Map<String, dynamic> address = {
        "street": place.street,
        "locality": place.locality,
        "postalCode": place.postalCode,
        "country": place.country,
        "latitude": position.latitude,
        "longitude": position.longitude
      };
      await HivePreferencesData().storeHiveData(
          boxName: HiveBoxes.addressBox, key: HiveKeys.address, value: address);
      log.fine("Address : $address", includeStackTrace: false);
      return address;
    } catch (error) {
      log.error("Error getting location or address: $error",
          includeStackTrace: false);
      return null;
    }
  }
}

class AccountCardsUtils {
  final log = const Logger('AccountCardsUtils');
  static TextEditingController cardNumberController = TextEditingController();
  static TextEditingController expiryDateController = TextEditingController();
  static TextEditingController cardHolderNameController =
      TextEditingController();
  static TextEditingController cvvCodeController = TextEditingController();
  static bool isCvvFocused = false;

  InputDecoration buildInputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.black54),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: const Color(0xFF00C569),
          width: 2.0.w,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }
}

class AccountLogoutUtils {
  final log = const Logger('AccountLogoutUtils');
  Future<void> handleLogoutSuccess(BuildContext context) async {
    try {
      final HivePreferencesData hivePreferencesData = HivePreferencesData();

      final List<Map<String, String>> hiveKeysToDelete = [
        {'key': HiveKeys.dataUser, 'box': HiveBoxes.userBox},
        {'key': HiveKeys.cartData, 'box': HiveBoxes.cartBox},
        {'key': HiveKeys.creditCard, 'box': HiveBoxes.creditCardBox},
        {'key': HiveKeys.favoritesData, 'box': HiveBoxes.favoritesBox},
        {'key': HiveKeys.totalPrice, 'box': HiveBoxes.cartBox},
        {'key': HiveKeys.address, 'box': HiveBoxes.addressBox},
        {'key': HiveKeys.imagePath, 'box': HiveBoxes.imagePathBox},
        {'key': HiveKeys.productPrice, 'box': HiveBoxes.cartBox},
      ];

      for (var entry in hiveKeysToDelete) {
        await hivePreferencesData.deleteFromHive(
          key: entry['key']!,
          boxName: entry['box']!,
        );

        await Future.delayed(Duration(milliseconds: 10));
      }

      await FirebaseAuth.instance.signOut();

      await Future.delayed(const Duration(milliseconds: 500));

      if (!context.mounted) return;

      Navigator.of(context).pushReplacement(
        PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: WelcomeView()),
      );
    } catch (e) {
      log.error('Logout process failed: $e', includeStackTrace: false);
    }
  }
}
