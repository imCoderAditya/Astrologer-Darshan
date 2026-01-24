import 'dart:developer';

import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';

import 'package:astrology/app/routes/app_pages.dart';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Main CallKit Manager class to handle all call operations
class CallKitManager {
  static final CallKitManager _instance = CallKitManager._internal();
  factory CallKitManager() => _instance;
  CallKitManager._internal();

  final Uuid _uuid = const Uuid();
  String? _currentCallId;

  /// Initialize CallKit and listen to events
  void initialize() {
    _listenToCallEvents();
  }

  /// Request necessary permissions for Android 13+
  Future<void> requestPermissions() async {
    // Request notification permission
    await FlutterCallkitIncoming.requestNotificationPermission({
      "title": "Notification permission",
      "rationaleMessagePermission":
          "Notification permission is required, to show notification.",
      "postNotificationMessageRequired":
          "Notification permission is required, Please allow notification permission from setting.",
    });

    // For Android 14+: Check and request full screen intent permission
    final canUseFullScreen =
        await FlutterCallkitIncoming.canUseFullScreenIntent();
    if (canUseFullScreen == false) {
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }
  }

  /// Show incoming call notification
  Future<String> showIncomingCall({
    required String callerName,
    required String handle,
    String? avatarUrl,
    bool isVideoCall = false,
    Map<String, dynamic>? extraData,
    int duration = 30000,
  }) async {
    _currentCallId = _uuid.v4();

    final callKitParams = CallKitParams(
      id: _currentCallId!,
      nameCaller: callerName,
      appName: "",
      avatar: avatarUrl,
      handle: handle,
      type: isVideoCall ? 1 : 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: duration,
      extra: extraData ?? {},
      headers: {'apiKey': 'your-api-key', 'platform': 'flutter'},

      // Missed call notification configuration
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),

      // Calling notification configuration
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),

      // Android-specific configuration
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        logoUrl: avatarUrl,
        ringtonePath: 'sound',
        backgroundColor: '#0955fa',
        backgroundUrl: avatarUrl,
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
        isShowCallID: false,
      ),

      // iOS-specific configuration
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'assets/icons/sound.mp3',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    return _currentCallId!;
  }

  /// Start an outgoing call
  Future<String> startOutgoingCall({
    required String callerName,
    required String handle,
    bool isVideoCall = false,
    Map<String, dynamic>? extraData,
  }) async {
    _currentCallId = _uuid.v4();

    final callKitParams = CallKitParams(
      id: _currentCallId!,
      nameCaller: callerName,
      handle: handle,
      type: isVideoCall ? 1 : 0,
      extra: extraData ?? {},
      ios: const IOSParams(handleType: 'generic'),

      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),

      android: const AndroidParams(
        isCustomNotification: true,
        isShowCallID: true,
      ),
    );

    await FlutterCallkitIncoming.startCall(callKitParams);
    return _currentCallId!;
  }

  /// Show missed call notification
  Future<void> showMissedCallNotification({
    required String callerName,
    required String handle,
    bool isVideoCall = false,
    Map<String, dynamic>? extraData,
  }) async {
    final callId = _uuid.v4();

    final callKitParams = CallKitParams(
      id: callId,
      nameCaller: callerName,
      handle: handle,
      type: isVideoCall ? 1 : 0,
      extra: extraData ?? {},

      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),

      android: const AndroidParams(
        isCustomNotification: true,
        isShowCallID: true,
      ),
    );

    await FlutterCallkitIncoming.showMissCallNotification(callKitParams);
  }

  /// Hide call notification (Android only)
  Future<void> hideCallNotification([String? callId]) async {
    final id = callId ?? _currentCallId;
    if (id != null) {
      await FlutterCallkitIncoming.hideCallkitIncoming(CallKitParams(id: id));
    }
  }

  /// End a specific call
  Future<void> endCall([String? callId]) async {
    final id = callId ?? _currentCallId;
    if (id != null) {
      await FlutterCallkitIncoming.endCall(id);
      if (id == _currentCallId) {
        _currentCallId = null;
      }
    }
  }

  /// End all active calls
  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
    _currentCallId = null;
  }

  /// Set call as connected (important for timer)
  Future<void> setCallConnected([String? callId]) async {
    final id = callId ?? _currentCallId;
    if (id != null) {
      await FlutterCallkitIncoming.setCallConnected(id);
    }
  }

  /// Get all active calls
  Future<List<dynamic>> getActiveCalls() async {
    return await FlutterCallkitIncoming.activeCalls() ?? [];
  }

  /// Get device push token for VoIP (iOS)
  Future<String?> getDevicePushToken() async {
    return await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }

  /// Get current call ID
  String? get currentCallId => _currentCallId;

  /// Listen to call events
  void _listenToCallEvents() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event == null) return;

      switch (event.event) {
        case Event.actionCallIncoming:
          _handleIncomingCall(event);
          break;
        case Event.actionCallStart:
          _handleCallStart(event);
          break;
        case Event.actionCallAccept:
          _handleCallAccept(event);
          break;
        case Event.actionCallDecline:
          _handleCallDecline(event);
          break;
        case Event.actionCallEnded:
          _handleCallEnded(event);
          break;
        case Event.actionCallTimeout:
          _handleCallTimeout(event);
          break;
        case Event.actionCallCallback:
          _handleCallCallback(event);
          break;
        case Event.actionCallToggleHold:
          _handleToggleHold(event);
          break;
        case Event.actionCallToggleMute:
          _handleToggleMute(event);
          break;
        case Event.actionCallToggleDmtf:
          _handleToggleDmtf(event);
          break;
        case Event.actionCallToggleGroup:
          _handleToggleGroup(event);
          break;
        case Event.actionCallToggleAudioSession:
          _handleToggleAudioSession(event);
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          _handleDevicePushTokenUpdate(event);
          break;
        case Event.actionCallCustom:
          _handleCustomAction(event);
          break;
        default:
          break;
      }
    });
  }

  // Event handlers - Override these in your implementation
  void _handleIncomingCall(CallEvent event) {
    debugPrint('Incoming call: ${event.body}');
    // TODO: Handle incoming call
    final callId = event.body?["id"]?.toString();
    log("sessionId $callId");
  }

  void _handleCallStart(CallEvent event) {
    debugPrint('Call started: ${event.body}');
  }

  void _handleCallAccept(CallEvent event) async {
    debugPrint("✅ Call Accepted => ${event.body}");

    final callId = event.body?["id"]?.toString();

    // ✅ popup ko rehne do (hide/end mat karo)

    // ✅ call connected set karo (CallKit screen active rahega)
    if (callId != null && callId.isNotEmpty) {
      await FlutterCallkitIncoming.setCallConnected(callId);
    }
    final sessionType = event.body?["extra"]?["sessionType"]?.toString() ?? "";
    log(("sessionType $sessionType"));
    await Future.delayed(Duration(microseconds: 200));
    if (Get.currentRoute != Routes.USER_REQUEST) {
      Get.to(UserRequestView(sessionType: sessionType));
    }

    // Get.isRegistered<UserRequestController>()
    //     ? Get.find<UserRequestController>().fetchUserRequest(sessionType: sessionType)
    //     : Get.put(UserRequestController()).fetchUserRequest(sessionType: sessionType);
    // ✅ NOW CLOSE / HANGUP UI (CallKit close)
    await Future.delayed(const Duration(microseconds: 300));
    await FlutterCallkitIncoming.endCall(callId!);
  }

  void _handleCallDecline(CallEvent event) {
    debugPrint('Call declined: ${event.body}');
    _currentCallId = null;

    // hideCallNotification(event.body["id"]);
    final data = event.body?["extra"]?["sessionId"]?.toString() ?? "";
    int sessionId = int.tryParse(data) ?? 0;
    Get.isRegistered<UserRequestController>()
        ? Get.find<UserRequestController>().statusUpdate(
          "Cancelled",
          sessionId,
          "Call",
        )
        : Get.put(
          UserRequestController(),
        ).statusUpdate("Cancelled", sessionId, "Call");
  }

  void _handleCallEnded(CallEvent event) {
    debugPrint('Call ended: ${event.body}');
    _currentCallId = null;
    // TODO: Cleanup call resources
  }

  void _handleCallTimeout(CallEvent event) {
    debugPrint('Call timeout: ${event.body}');
    _currentCallId = null;
    hideCallNotification(event.body["id"]);
    // TODO: Show missed call notification
  }

  void _handleCallCallback(CallEvent event) {
    debugPrint('Call callback: ${event.body}');
    // TODO: Handle call back action
  }

  void _handleToggleHold(CallEvent event) {
    debugPrint('Toggle hold (iOS): ${event.body}');
    // TODO: Handle hold
  }

  void _handleToggleMute(CallEvent event) {
    debugPrint('Toggle mute (iOS): ${event.body}');
    // TODO: Handle mute
  }

  void _handleToggleDmtf(CallEvent event) {
    debugPrint('Toggle DMTF (iOS): ${event.body}');
    // TODO: Handle DMTF
  }

  void _handleToggleGroup(CallEvent event) {
    debugPrint('Toggle group (iOS): ${event.body}');
    // TODO: Handle group
  }

  void _handleToggleAudioSession(CallEvent event) {
    debugPrint('Toggle audio session (iOS): ${event.body}');
    // TODO: Handle audio session
  }

  void _handleDevicePushTokenUpdate(CallEvent event) {
    debugPrint('Device push token updated (iOS): ${event.body}');
    // TODO: Send token to your server
  }

  void _handleCustomAction(CallEvent event) {
    debugPrint('Custom action: ${event.body}');
    // TODO: Handle custom action
  }
}
