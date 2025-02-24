import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'account_utils.dart';

class GlobalUtils {
  final log = const Logger('GlobalUtils');
  Map<String, String> signInKeys = {};
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static void easyLoadingFunction() {
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.textStyle = TextStyle(fontSize: 12.0.sp);
    EasyLoading.instance.textColor = const Color(0xFF848484);
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.instance.indicatorColor = const Color(0xff00C569);
    EasyLoading.instance.backgroundColor = Colors.white;
  }

  void showDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    required Widget bodyWidget,
    required AlertType alertType,
  }) {
    Alert(
      context: context,
      type: alertType,
      content: bodyWidget,
      style: const AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          fontFamily: 'SFProDisplay',
        ),
      ),
      buttons: [
        DialogButton(
          border: const Border.fromBorderSide(
            BorderSide(
              color: Color(0xff00C569),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          color: Colors.white,
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        DialogButton(
          color: const Color(0xff00C569),
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SFProDisplay',
            ),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  void showCustomSnackBar({
    required String message,
    required String title,
    required ToastificationType type,
    int? duration,
  }) {
    toastification.show(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF000000),
        ),
      ),
      autoCloseDuration: Duration(seconds: duration ?? 8),
      animationDuration: const Duration(milliseconds: 300),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      borderRadius: BorderRadius.circular(20),
      type: type,
      style: ToastificationStyle.flat,
      description: Text(
        message,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF848484),
        ),
      ),
      alignment: Alignment.topLeft,
      direction: TextDirection.ltr,
    );
  }

  String checkSignInMethod() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          log.fine('User signed in with Google.', includeStackTrace: false);
          AccountHomeUtils.checkGoogle = true;
          return "User signed in with Google";
        } else if (provider.providerId == 'facebook.com') {
          log.fine('User signed in with Facebook.', includeStackTrace: false);
          AccountHomeUtils.checkGoogle = true;
          return "User signed in with Facebook.";
        } else if (provider.providerId == 'password') {
          log.fine('User signed up using email and password.',
              includeStackTrace: false);
          AccountHomeUtils.checkGoogle = false;
          return "User signed up using email and password.";
        }
      }
      log.warning('User signed in with an unknown provider.',
          includeStackTrace: false);
      return "User signed in with an unknown provider.";
    } else {
      log.warning('No user is currently signed in.', includeStackTrace: false);
      return "No user is currently signed in.";
    }
  }

  Future<bool> requestStoragePermission(Permission permission) async {
    final result = await permission.request();

    if (!result.isGranted) {
      log.error("Permission Not Granted!", includeStackTrace: false);
      return result.isDenied;
    }
    return result.isGranted;
  }

  Widget slideRightBackground() {
    return Container(
      color: const Color(0xffFFC107),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: const Icon(Icons.star, color: Colors.white),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  static TextStyle googleFontsFunction({
    double? fontSizeText,
    FontWeight? fontWeightText,
    Color? colorText,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSizeText,
      fontWeight: fontWeightText ?? FontWeight.normal,
      color: colorText ?? Colors.black,
    );
  }
}
