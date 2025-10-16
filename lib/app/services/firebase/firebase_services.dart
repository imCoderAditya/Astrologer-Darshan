import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Initialize the plugin (only once, e.g., in main.dart)
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Call this function in main() after initializing Firebase
  Future<void> setupFirebaseForegroundListener() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization settings (optional)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Initialization settings for all platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📩 Foreground message received!');
      log('🔹 Data: ${json.encode(message.data)}');

      if (message.notification != null) {
        final notification = message.notification!;
        log('🔔 Notification: ${notification.title} - ${notification.body}');

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode, // unique id
          notification.title, // title
          notification.body, // body
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel', // channel id
              'General Notifications', // channel name
              sound: RawResourceAndroidNotificationSound("sound"),
              playSound: true,
              color: AppColors.primaryColor,
              icon: '@mipmap/launcher_icon',
              // sound:  const UriAndroidNotificationSound("assets/icons/sound.mp3"),
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              sound: 'sound.mp3', // must be in Runner bundle
            ), // optional iOS settings
          ),
        );
      }
    });
  }

  static Future<String?> firebaseToken() async {
    try {
      // Request notification permission (Provisional for iOS)
      final notificationSettings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        // Log the notification permission status
        LoggerUtils.debug(
          "Notification permission status: ${notificationSettings.authorizationStatus}",
        );

        // Optional: Log APNs token (iOS only)

        if (Platform.isIOS) {
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          LoggerUtils.debug("APNs token: $apnsToken");
          // You might want to handle cases where apnsToken is null
        }

        // Get FCM token (for all platforms)
        final fcmToken = await FirebaseMessaging.instance.getToken();
        LoggerUtils.debug("FCM token: $fcmToken");
        return fcmToken;
      } else {
        LoggerUtils.debug('User declined notification permissions');
        await openAppSettings();
        return null;
      }
      // You can now send this FCM token to your backend if needed
    } catch (e) {
      LoggerUtils.error("Error:$e");
      return null;
    }
  }
}



//For Local Notification 

class FirebaseLocalHandle{
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon'); // launcher icon

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> showLocalNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
       'local_channel_v2', // <-- NEW channel id
     'Local Notifications',
      channelDescription: 'Channel for local notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('sound'), // no extension
      icon: '@mipmap/launcher_icon', // small icon
      fullScreenIntent: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        sound: 'sound.mp3', // must be in Runner bundle
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0, // unique id
      'Hello!',
      'This is a local notification 🔔',
      notificationDetails,
    );
  }

  // Initialize the plugin (only once, e.g., in main.dart)
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Call this function in main() after initializing Firebase
  Future<void> setupFirebaseForegroundListener() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization settings (optional)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Initialization settings for all platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📩 Foreground message received!');
      log('🔹 Data: ${json.encode(message.data)}');

      if (message.notification != null) {
        final notification = message.notification!;
        log('🔔 Notification: ${notification.title} - ${notification.body}');

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode, // unique id
          notification.title, // title
          notification.body, // body
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel', // channel id
              'General Notifications', // channel name
              sound: RawResourceAndroidNotificationSound("sound"),
              playSound: true,
              icon: '@mipmap/launcher_icon',
              // sound:  const UriAndroidNotificationSound("assets/icons/sound.mp3"),
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              sound: 'sound.ogg', // must be in Runner bundle
            ), // optional iOS settings
          ),
        );
      }
    });
  }
}