import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseServices {
  static Future<void> firebaseToken() async {
    try {
      // Request notification permission (Provisional for iOS)
      final notificationSettings = await FirebaseMessaging.instance
          .requestPermission(
            provisional: true,
            alert: true,
            badge: true,
            sound: true,
          );

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        // Log the notification permission status
        LoggerUtils.debug(
          "Notification permission status: ${notificationSettings.authorizationStatus}",
        );

        // Optional: Log APNs token (iOS only)
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        LoggerUtils.debug("APNs token: $apnsToken");

        // Get FCM token (for all platforms)
        final fcmToken = await FirebaseMessaging.instance.getToken();
        LoggerUtils.debug("FCM token: $fcmToken");
      } else {
        LoggerUtils.debug('User declined notification permissions');
        await openAppSettings();
      }
      // You can now send this FCM token to your backend if needed
    } catch (e) {
      LoggerUtils.error("Error:$e");
    }
  }

  // static Future<void> firebaseToken() async {
  //   // Request permission on iOS before trying to get the token
  //   NotificationSettings settings = await FirebaseMessaging.instance
  //       .requestPermission(alert: true, badge: true, sound: true);

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //     print('APNs Token: $apnsToken');

  //     String? deviceToken = await FirebaseMessaging.instance.getToken();
  //     print('FCM Token: $deviceToken');
  //   } else {
  //     print('User declined notification permissions');
  //   }
  // }
}
