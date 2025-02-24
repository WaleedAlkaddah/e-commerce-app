import 'package:firebase_project/utility/hive_constants.dart';
import 'package:flutter/material.dart';
import 'package:quick_log/quick_log.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';

class WelcomeViewUtils {
  static TextEditingController emailController = TextEditingController();
  static TextEditingController emailForgetPasswordController =
      TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isChecked = false;
  bool isPasswordVisible = false;
  final log = const Logger('WelcomeViewUtils');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  void checkRemember(bool value) async {
    isChecked = value;
    String? email = emailController.text;
    String? password = passwordController.text;
    final dataStored = {"email_login": email, "password_login": password};
    if (isChecked == true) {
      await hivePreferencesData.storeHiveData(
          key: HiveKeys.dataLogin,
          value: dataStored,
          boxName: HiveBoxes.singInBox);
    } else {
      log.error(
          "isChecked :$isChecked , With Email : $email , Password : $password",
          includeStackTrace: false);
    }
  }
}

class ValidateText {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateName(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2 || value.length > 20) {
      return '$fieldName must be between 2 and 20 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}

class SignupUtils {
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
}
