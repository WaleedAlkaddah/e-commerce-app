import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationsServices {
  Future<void> awesomeNotificationsInitialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic notifications",
          channelDescription: "Notification channel",
          defaultColor: Colors.white,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          criticalAlerts: true,
        )
      ],
      debug: true,
    );
    await awesomeNotificationsPermission();
  }

  Future<void> awesomeNotificationsPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
          if (!isAllowed)
            {AwesomeNotifications().requestPermissionToSendNotifications()}
        });
  }

  void showNotifications({
    required String titleNotification,
    required String bodyNotification,
    String? bigPictureNotification,
  }) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: "basic_channel",
        title: titleNotification,
        body: bodyNotification,
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: bigPictureNotification,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "MARK_AS_READ",
          label: "Mark as Read",
          autoDismissible: true,
        ),
      ],
    );
  }
}
