import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/firebase/firebase_notification_model.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/callKit/call_kit_manager.dart';
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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
        );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      description: 'General notifications',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _local.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        log("🔔 Local Notification Tapped: ${response.payload}");

        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);

          await handleUserRequestNavigation(data: data);
        }
      },
    );
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("📩 Foreground Message => ${jsonEncode(message.toMap())}");
      log("📦 Data => ${jsonEncode(message.data)}");

      // if only notification (no data)
      if (message.data.isEmpty) {
        // data nahi hai to local show mat karo (because _showLocalNotification requires data)
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log("🔔 Opened from background: ${message.data}");
      await Future.delayed(Duration(microseconds: 300));

      if (message.data.isNotEmpty) {
        await handleUserRequestNavigation(data: message.data);
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

  Future<void> handleUserRequestNavigation({Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> finalData = {};

      // payload priority

      if (data != null && data.isNotEmpty) {
        finalData = data;
      } else {
        return;
      }
      log("UserRequestNavigation ${json.encode(data)}");

      final sessionType = (finalData["sessionType"] ?? "").toString();
      if (sessionType.isEmpty) return;

      log("✅ sessionType => $sessionType");

      // navigate
      if (Get.currentRoute != Routes.USER_REQUEST) {
        Get.to(() => UserRequestView(sessionType: sessionType));
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // controller + api call
      if (Get.isRegistered<UserRequestController>()) {
        await Get.find<UserRequestController>().fetchUserRequest(
          sessionType: sessionType,
        );
      } else {
        await Get.put(
          UserRequestController(),
        ).fetchUserRequest(sessionType: sessionType);
      }
    } catch (e) {
      log("❌ handleUserRequestNavigation error: $e");
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
