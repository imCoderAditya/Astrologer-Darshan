// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:astrology/app/core/config/theme/app_colors.dart';
// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/entities/notification_params.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';

// import 'firebase_services.dart' as FlutterCallkitIncoming;

// class FirebaseServices {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   // Initialize the plugin (only once, e.g., in main.dart)

//   // Call this function in main() after initializing Firebase
//   Future<void> setupFirebaseForegroundListener() async {
//     // Android initialization settings
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     // iOS initialization settings (optional)
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     // Initialization settings for all platforms
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );

//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log('📩 Foreground message received!');
//       log('🔹 Data: ${json.encode(message.data)}');

//       if (message.notification != null) {
//         final notification = message.notification!;
//         log('🔔 Notification: ${notification.title} - ${notification.body}');

//         // Show local notification
//         await flutterLocalNotificationsPlugin.show(
//           notification.hashCode, // unique id
//           notification.title, // title
//           notification.body, // body
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               'default_channel', // channel id
//               'General Notifications', // channel name
//               sound: RawResourceAndroidNotificationSound("sound"),
//               playSound: true,
//               color: AppColors.primaryColor,
//               icon: '@mipmap/launcher_icon',
//               timeoutAfter: 60000,
//               // sound:  const UriAndroidNotificationSound("assets/icons/sound.mp3"),
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//             iOS: DarwinNotificationDetails(
//               presentAlert: true,
//               presentSound: true,
//               sound: 'sound.mp3', // must be in Runner bundle
//             ), // optional iOS settings
//           ),
//         );
//       }
//     });
//   }

//   static Future<String?> firebaseToken() async {
//     try {
//       // Request notification permission (Provisional for iOS)
//       final notificationSettings = await FirebaseMessaging.instance
//           .requestPermission(
//             alert: true,
//             announcement: false,
//             badge: true,
//             carPlay: false,
//             criticalAlert: false,
//             provisional: false,
//             sound: true,
//           );

//       if (notificationSettings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//         // Log the notification permission status
//         LoggerUtils.debug(
//           "Notification permission status: ${notificationSettings.authorizationStatus}",
//         );

//         // Optional: Log APNs token (iOS only)

//         if (Platform.isIOS) {
//           final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//           LoggerUtils.debug("APNs token: $apnsToken");
//           // You might want to handle cases where apnsToken is null
//         }

//         // Get FCM token (for all platforms)
//         final fcmToken = await FirebaseMessaging.instance.getToken();
//         LoggerUtils.debug("FCM token: $fcmToken");
//         return fcmToken;
//       } else {
//         LoggerUtils.debug('User declined notification permissions');
//         await openAppSettings();
//         return null;
//       }
//       // You can now send this FCM token to your backend if needed
//     } catch (e) {
//       LoggerUtils.error("Error:$e");
//       return null;
//     }
//   }
// }

// //For Local Notification

// // class FirebaseLocalHandle{
// //     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   Future<void> initLocalNotifications() async {
// //     const AndroidInitializationSettings androidSettings =
// //         AndroidInitializationSettings('@mipmap/launcher_icon'); // launcher icon

// //     const DarwinInitializationSettings iosSettings =
// //         DarwinInitializationSettings();

// //     const InitializationSettings settings = InitializationSettings(
// //       android: androidSettings,
// //       iOS: iosSettings,
// //     );

// //     await flutterLocalNotificationsPlugin.initialize(settings);
// //   }

// //   Future<void> showLocalNotification() async {
// //     AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
// //        'local_channel_v2', // <-- NEW channel id
// //      'Local Notifications',
// //       channelDescription: 'Channel for local notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       playSound: true,
// //       sound: RawResourceAndroidNotificationSound('sound'), // no extension
// //       icon: '@mipmap/launcher_icon', // small icon
// //       fullScreenIntent: true,
// //     );

// //     NotificationDetails notificationDetails = NotificationDetails(
// //       android: androidDetails,
// //       iOS: DarwinNotificationDetails(
// //         presentAlert: true,
// //         presentSound: true,
// //         sound: 'sound.mp3', // must be in Runner bundle
// //       ),
// //     );
// //     await flutterLocalNotificationsPlugin.show(
// //       0, // unique id
// //       'Hello!',
// //       'This is a local notification 🔔',
// //       notificationDetails,
// //     );
// //   }

// //   // Initialize the plugin (only once, e.g., in main.dart)
// //   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   //     FlutterLocalNotificationsPlugin();

// //   // Call this function in main() after initializing Firebase
// //   Future<void> setupFirebaseForegroundListener() async {
// //     // Android initialization settings
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/launcher_icon');

// //     // iOS initialization settings (optional)
// //     const DarwinInitializationSettings initializationSettingsIOS =
// //         DarwinInitializationSettings();

// //     // Initialization settings for all platforms
// //     const InitializationSettings initializationSettings =
// //         InitializationSettings(
// //           android: initializationSettingsAndroid,
// //           iOS: initializationSettingsIOS,
// //         );

// //     // Initialize the plugin
// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

// //     // Listen to foreground messages
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
// //       log('📩 Foreground message received!');
// //       log('🔹 Data: ${json.encode(message.data)}');

// //       if (message.notification != null) {
// //         final notification = message.notification!;
// //         log('🔔 Notification: ${notification.title} - ${notification.body}');

// //         // Show local notification
// //         await flutterLocalNotificationsPlugin.show(
// //           notification.hashCode, // unique id
// //           notification.title, // title
// //           notification.body, // body
// //           NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               'default_channel', // channel id
// //               'General Notifications', // channel name
// //               sound: RawResourceAndroidNotificationSound("sound"),
// //               playSound: true,
// //               icon: '@mipmap/launcher_icon',
// //               // sound:  const UriAndroidNotificationSound("assets/icons/sound.mp3"),
// //               importance: Importance.max,
// //               priority: Priority.high,
// //             ),
// //             iOS: DarwinNotificationDetails(
// //               presentAlert: true,
// //               presentSound: true,
// //               sound: 'sound.ogg', // must be in Runner bundle
// //             ), // optional iOS settings
// //           ),
// //         );
// //       }
// //     });
// //   }
// // }

// // ============================================================================
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:astrology/app/core/config/theme/app_colors.dart';
// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:astrology/app/services/call_kit_manager.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/entities/notification_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';

// /// Firebase Services - Handles FCM and Local Notifications
// /// ============================================================================
// class FirebaseServices {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final CallKitManager _callKitManager = CallKitManager();
//     NoticationFirebaseModel noticationFirebaseModel = NoticationFirebaseModel();
//   /// Initialize Firebase foreground listener with CallKit support
//   Future<void> setupFirebaseForegroundListener() async {
//     // Android initialization settings
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     // iOS initialization settings
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     // Initialization settings for all platforms
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );

//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Initialize CallKit
//     _callKitManager.initialize();

//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log('📩 Foreground message received!');
//       log('🔹 Data: ${json.encode(message.data)}');
//       noticationFirebaseModel = noticationFirebaseModelFromJson(
//         json.encode(message.data),
//       );

//       log("Firebase Model : ${json.encode( noticationFirebaseModel)}");
//       // Check if this is a call notification
//       // if (message.data.containsKey('type') &&
//       // message.data['type'] == 'call') {
//       // Handle incoming call with CallKit
//       await _handleIncomingCallNotification(message);
//       // } else {
//       //   // Handle normal notification
//       //   await _showLocalNotification(message);
//       // }
//     });
//   }

//   /// Handle incoming call notification from Firebase
//   Future<void> _handleIncomingCallNotification(RemoteMessage message) async {
//     try {
//       final data = message.data;

//       // Extract call details from Firebase message
//       final callerName = data['caller_name'] ?? 'Unknown';
//       final handle = data['caller_phone'] ?? '';
//       final avatarUrl = data['caller_avatar'];
//       final isVideoCall = data['is_video'] == 'true' || data['is_video'] == '1';
//       final callId = data['call_id'];
//       final roomId = data['room_id'];

//       // Show CallKit incoming call
//       await _callKitManager.showIncomingCall(
//         callerName: callerName,
//         handle: handle,
//         avatarUrl: avatarUrl,
//         isVideoCall: isVideoCall,
//         extraData: {
//           'call_id': callId,
//           'room_id': roomId,
//           'caller_name': callerName,
//           'caller_phone': handle,
//         },
//       );

//       LoggerUtils.debug('📞 CallKit incoming call displayed');
//     } catch (e) {
//       LoggerUtils.error('Error handling incoming call: $e');
//     }
//   }

//   /// Show local notification for non-call messages
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     if (message.notification != null) {
//       final notification = message.notification!;
//       log('🔔 Notification: ${notification.title} - ${notification.body}');

//       await flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'default_channel',
//             'General Notifications',
//             sound: const RawResourceAndroidNotificationSound("sound"),
//             playSound: true,
//             color: AppColors.primaryColor,
//             icon: '@mipmap/launcher_icon',
//             timeoutAfter: 60000,
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentSound: true,
//             sound: 'sound.mp3',
//           ),
//         ),
//       );
//     }
//   }

//   /// Get Firebase token
//   static Future<String?> firebaseToken() async {
//     try {
//       final notificationSettings = await FirebaseMessaging.instance
//           .requestPermission(
//             alert: true,
//             announcement: false,
//             badge: true,
//             carPlay: false,
//             criticalAlert: false,
//             provisional: false,
//             sound: true,
//           );

//       if (notificationSettings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//         LoggerUtils.debug(
//           "Notification permission status: ${notificationSettings.authorizationStatus}",
//         );

//         if (Platform.isIOS) {
//           final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//           LoggerUtils.debug("APNs token: $apnsToken");
//         }

//         final fcmToken = await FirebaseMessaging.instance.getToken();
//         LoggerUtils.debug("FCM token: $fcmToken");
//         return fcmToken;
//       } else {
//         LoggerUtils.debug('User declined notification permissions');
//         await openAppSettings();
//         return null;
//       }
//     } catch (e) {
//       LoggerUtils.error("Error getting Firebase token: $e");
//       return null;
//     }
//   }
// }

// /// ============================================================================
// /// Background Message Handler (Add to main.dart)
// /// ============================================================================
// /// This function MUST be top-level (not inside a class)
// /// Add this annotation for background handling
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log('🔔 Background message received: ${message.messageId}');
//   log('🔹 Data: ${json.encode(message.data)}');

//   // Check if this is a call notification
//   if (message.data.containsKey('type') && message.data['type'] == 'call') {
//     try {
//       final callerName = message.data['caller_name'] ?? 'Unknown';
//       final handle = message.data['caller_phone'] ?? '';
//       final avatarUrl = message.data['caller_avatar'];
//       final isVideoCall =
//           message.data['is_video'] == 'true' || message.data['is_video'] == '1';
//       final callId = message.data['call_id'];
//       final roomId = message.data['room_id'];

//       final uuid = const Uuid().v4();

//       // Show CallKit incoming call in background
//       await FlutterCallkitIncoming.showCallkitIncoming(
//         CallKitParams(
//           id: uuid,
//           nameCaller: callerName,
//           appName: 'Astrology',
//           avatar: avatarUrl,
//           handle: handle,
//           type: isVideoCall ? 1 : 0,
//           textAccept: 'Accept',
//           textDecline: 'Decline',
//           duration: 30000,
//           extra: {
//             'call_id': callId,
//             'room_id': roomId,
//             'caller_name': callerName,
//             'caller_phone': handle,
//           },
//           missedCallNotification: const NotificationParams(
//             showNotification: true,
//             isShowCallback: true,
//             subtitle: 'Missed call',
//             callbackText: 'Call back',
//           ),
//           android: AndroidParams(
//             isCustomNotification: true,
//             isShowLogo: false,
//             logoUrl: avatarUrl,
//             ringtonePath: 'sound',
//             backgroundColor: '#0955fa',
//             backgroundUrl: avatarUrl,
//             actionColor: '#4CAF50',
//             textColor: '#ffffff',
//             incomingCallNotificationChannelName: "Incoming Call",
//             missedCallNotificationChannelName: "Missed Call",
//             isShowCallID: false,
//           ),
//           ios: const IOSParams(
//             iconName: 'CallKitLogo',
//             handleType: 'generic',
//             supportsVideo: true,
//             ringtonePath: 'sound.mp3',
//           ),
//         ),
//       );

//       log('📞 Background call shown successfully');
//     } catch (e) {
//       log('❌ Error showing background call: $e');
//     }
//   }
// }

// NoticationFirebaseModel noticationFirebaseModelFromJson(String str) => NoticationFirebaseModel.fromJson(json.decode(str));

// String noticationFirebaseModelToJson(NoticationFirebaseModel data) => json.encode(data.toJson());

// class NoticationFirebaseModel {
//     final String? sound;
//     final String? deeplink;
//     final String? screen;
//     final String? sessionId;
//     final String? priority;
//     final String? body;
//     final String? type;
//     final String? title;
//     final String? clickAction;
//     final String? customerId;
//     final String? sessionType;
//     final String? id;
//     final String? event;
//     final String? channelId;
//     final DateTime? timestamp;

//     NoticationFirebaseModel({
//         this.sound,
//         this.deeplink,
//         this.screen,
//         this.sessionId,
//         this.priority,
//         this.body,
//         this.type,
//         this.title,
//         this.clickAction,
//         this.customerId,
//         this.sessionType,
//         this.id,
//         this.event,
//         this.channelId,
//         this.timestamp,
//     });

//     NoticationFirebaseModel copyWith({
//         String? sound,
//         String? deeplink,
//         String? screen,
//         String? sessionId,
//         String? priority,
//         String? body,
//         String? type,
//         String? title,
//         String? clickAction,
//         String? customerId,
//         String? sessionType,
//         String? id,
//         String? event,
//         String? channelId,
//         DateTime? timestamp,
//     }) =>
//         NoticationFirebaseModel(
//             sound: sound ?? this.sound,
//             deeplink: deeplink ?? this.deeplink,
//             screen: screen ?? this.screen,
//             sessionId: sessionId ?? this.sessionId,
//             priority: priority ?? this.priority,
//             body: body ?? this.body,
//             type: type ?? this.type,
//             title: title ?? this.title,
//             clickAction: clickAction ?? this.clickAction,
//             customerId: customerId ?? this.customerId,
//             sessionType: sessionType ?? this.sessionType,
//             id: id ?? this.id,
//             event: event ?? this.event,
//             channelId: channelId ?? this.channelId,
//             timestamp: timestamp ?? this.timestamp,
//         );

//     factory NoticationFirebaseModel.fromJson(Map<String, dynamic> json) => NoticationFirebaseModel(
//         sound: json["sound"],
//         deeplink: json["deeplink"],
//         screen: json["screen"],
//         sessionId: json["sessionId"],
//         priority: json["priority"],
//         body: json["body"],
//         type: json["type"],
//         title: json["title"],
//         clickAction: json["click_action"],
//         customerId: json["customerId"],
//         sessionType: json["sessionType"],
//         id: json["id"],
//         event: json["event"],
//         channelId: json["channelId"],
//         timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "sound": sound,
//         "deeplink": deeplink,
//         "screen": screen,
//         "sessionId": sessionId,
//         "priority": priority,
//         "body": body,
//         "type": type,
//         "title": title,
//         "click_action": clickAction,
//         "customerId": customerId,
//         "sessionType": sessionType,
//         "id": id,
//         "event": event,
//         "channelId": channelId,
//         "timestamp": timestamp?.toIso8601String(),
//     };
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/firebase/firebase_notification_model.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/call_kit_manager.dart';
import 'package:astrology/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseServices {
  FirebaseServices._internal();
  static final FirebaseServices instance = FirebaseServices._internal();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final CallKitManager _callKitManager = CallKitManager();

  /// ✅ Call this once in main()
  Future<void> init() async {
    await _initLocalNotification();
    _callKitManager.initialize();
    await _callKitManager.requestPermissions(); // ✅ Android 13/14
    _listenForeground();
  }

  Future<void> _initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _local.initialize(
      settings,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("🔔 Local Notification Tapped: ${response.payload}");

        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          final sessionType = data["sessionType"] ?? "";
          Get.to(UserRequestView(sessionType: sessionType));
        }
      },
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    log("🔔 BG Notification Tapped: ${response.payload}");
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("📩 Foreground Message => ${jsonEncode(message.toMap())}");
      log("📦 Data => ${jsonEncode(message.data)}");

      // if only notification (no data)
      if (message.data.isEmpty) {
        await _showLocalNotification(message);
        return;
      }

      final model = NoticationFirebaseModel.fromJson(message.data);

      log("✅ Parsed Model => ${jsonEncode(model.toJson())}");

      // final type = (message.data["type"] ?? "").toString().toLowerCase();
      final sessionType = (model.sessionType ?? "").toLowerCase().trim();
      // final screen = (model.screen ?? "").toLowerCase();
      log("Session Type : $sessionType");
      // ✅ Call only when call type
      if (sessionType == "call") {
        await _showIncomingCall(model);
      } else {
        await _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🔔 Notification Clicked (background) => ${message.data}");

      final screen = message.data["screen"] ?? "";

      if (screen == "call_screen") {
        Get.toNamed(Routes.USER_REQUEST);
      } else {
        Get.toNamed(Routes.HOME);
      }
    });
  }

  /// ✅ CallKit show
  Future<void> _showIncomingCall(NoticationFirebaseModel model) async {
    try {
      final callerName = model.title ?? "Incoming Call";
      final handle = model.customerId ?? model.sessionId ?? "Unknown";

      await _callKitManager.showIncomingCall(
        callerName: callerName,
        handle: handle,
        avatarUrl: null,
        isVideoCall: false,
        extraData: model.toJson(),
      );

      LoggerUtils.debug("📞 CallKit Incoming Call Shown");
    } catch (e) {
      LoggerUtils.error("❌ CallKit Error: $e");
    }
  }

  /// ✅ Normal Local Notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    log("🔔 BG Message => ${jsonEncode(message.toMap())}");
    log("📦 BG Data => ${jsonEncode(message.data)}");

    if (message.data.isEmpty) return;

    final model = NoticationFirebaseModel.fromJson(message.data);
    log("Firebase model : ${json.encode(model)}");
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      model.title.toString(),
      model.body.toString(),

      NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          sound: const RawResourceAndroidNotificationSound("sound"),
          playSound: true,
          color: AppColors.primaryColor,
          icon: '@mipmap/launcher_icon',
          timeoutAfter: 60000,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          sound: 'sound',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// ✅ Token
  static Future<String?> firebaseToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        await openAppSettings();
        return null;
      }

      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        LoggerUtils.debug("🍏 APNs Token: $apnsToken");
      }

      final token = await FirebaseMessaging.instance.getToken();
      LoggerUtils.debug("🔥 FCM Token: $token");
      return token;
    } catch (e) {
      LoggerUtils.error("❌ Token Error: $e");
      return null;
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  log("🔔 BG Message => ${jsonEncode(message.toMap())}");
  log("📦 BG Data => ${jsonEncode(message.data)}");

  if (message.data.isEmpty) return;

  final model = NoticationFirebaseModel.fromJson(message.data);
  final sessionType = (model.sessionType ?? "").toLowerCase();

  if (sessionType == "call") {
    final callKit = CallKitManager(); // ✅ use your class
    // ✅ (Optional) permission request avoid in background (sometimes issue)
    // await callKit.requestPermissions();

    await callKit.showIncomingCall(
      callerName: model.title ?? "Incoming Call",
      handle: model.customerId ?? model.sessionId ?? "Unknown",
      avatarUrl: null,
      isVideoCall: false,
      extraData: message.data, // full payload
      duration: 30000,
    );
  }
}
