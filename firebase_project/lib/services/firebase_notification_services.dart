import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:quick_log/quick_log.dart';
import '../model/account/firebase_account_edit_profile_model.dart';

class FirebaseNotificationServices {
  final log = const Logger('NotificationServices');
  final firebaseMessaging = FirebaseMessaging.instance;
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  Future<void> iniNotifications() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    firebaseMessaging.subscribeToTopic('new-products');
    log.info("Token of notifications: $fCMToken", includeStackTrace: false);
    final dataUser = await hivePreferencesData.retrieveHiveData(
        boxName: HiveBoxes.userBox, key: HiveKeys.dataUser);
    FirebaseAccountEditProfileModel().updateUserDataModel(
        uid: dataUser['uid'], updatedData: {"notifications_token": fCMToken});
    handleBackgroundNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      log.info('handleMessage called with null message',
          includeStackTrace: false);
      return;
    }
    log.info(
        'Navigating to AccountNotificationView with title message: ${message.notification?.title} and text: ${message.notification?.body}',
        includeStackTrace: false);
  }

  Future handleBackgroundNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
