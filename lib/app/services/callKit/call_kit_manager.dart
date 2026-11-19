import 'dart:developer';

import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';

import 'package:astrology/app/routes/app_pages.dart';

import 'package:audioplayers/audioplayers.dart';
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
  final AudioPlayer _ringtonePlayer = AudioPlayer(
    playerId: 'astro_call_ringtone_player',
  );
  String? _currentCallId;

  Future<void> _startRingtone() async {
    try {
      await _ringtonePlayer.stop();
      await _ringtonePlayer.setReleaseMode(ReleaseMode.loop);
      await _ringtonePlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.notificationRingtone,
            audioFocus: AndroidAudioFocus.gainTransient,
          ),
        ),
      );
      await _ringtonePlayer.play(AssetSource('sound.mp3'));
    } catch (e) {
      debugPrint("Error starting ringtone: $e");
    }
  }

  Future<void> _stopRingtone() async {
    try {
      await _ringtonePlayer.pause();
      await _ringtonePlayer.stop();
      await _ringtonePlayer.release();
    } catch (e) {
      debugPrint("Error stopping ringtone: $e");
    }
  }

  Future<void> startRingtoneSound() async {
    await _startRingtone();
  }

  Future<void> stopRingtoneSound() async {
    await _stopRingtone();
  }

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
    int duration = 300000,
  }) async {
    _currentCallId = _uuid.v4();

    final callKitParams = CallKitParams(
      id: _currentCallId!,
      nameCaller: callerName,
      appName: "Astro Darshan",
      avatar: avatarUrl,
      handle: handle,
      type: isVideoCall ? 1 : 0,
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
        ringtonePath: '',
        backgroundColor: '#0955fa',
        backgroundUrl: avatarUrl,
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName:
            "Incoming Call System Ringing Channel",
        missedCallNotificationChannelName: "Missed Call Channel",
        isShowCallID: false,
        isShowFullLockedScreen: true,
        isFullScreen: true,
        textAccept: 'Accept',
        textDecline: 'Decline',
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
        ringtonePath: 'sound.mp3',
      ),
    );

    await _startRingtone();
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
    await _stopRingtone();
    final id = callId ?? _currentCallId;
    if (id != null) {
      await FlutterCallkitIncoming.hideCallkitIncoming(CallKitParams(id: id));
    }
  }

  /// End a specific call
  Future<void> endCall([String? callId]) async {
    await _stopRingtone();
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
    await _stopRingtone();
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
    return await FlutterCallkitIncoming.activeCalls();
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

      switch (event) {
        case CallEventActionCallIncoming e:
          _handleIncomingCall(e);
          break;
        case CallEventActionCallStart e:
          _handleCallStart(e);
          break;
        case CallEventActionCallAccept e:
          _handleCallAccept(e);
          break;
        case CallEventActionCallDecline e:
          _handleCallDecline(e);
          break;
        case CallEventActionCallEnded e:
          _handleCallEnded(e);
          break;
        case CallEventActionCallTimeout e:
          _handleCallTimeout(e);
          break;
        case CallEventActionCallCallback e:
          _handleCallCallback(e);
          break;
        case CallEventActionCallToggleHold e:
          _handleToggleHold(e);
          break;
        case CallEventActionCallToggleMute e:
          _handleToggleMute(e);
          break;
        case CallEventActionCallToggleDmtf e:
          _handleToggleDmtf(e);
          break;
        case CallEventActionCallToggleGroup e:
          _handleToggleGroup(e);
          break;
        case CallEventActionCallToggleAudioSession e:
          _handleToggleAudioSession(e);
          break;
        case CallEventActionDidUpdateDevicePushTokenVoip e:
          _handleDevicePushTokenUpdate(e);
          break;
        case CallEventActionCallCustom e:
          _handleCustomAction(e);
          break;
        default:
          break;
      }
    });
  }

  // Event handlers
  void _handleIncomingCall(CallEventActionCallIncoming event) {
    try {
      debugPrint('Incoming call: ${event.callKitParams}');
      final callId = event.callKitParams?.id;
      log("sessionId $callId");
    } catch (e) {
      debugPrint("Error handling incoming call: $e");
    }
  }

  void _handleCallStart(CallEventActionCallStart event) {
    try {
      debugPrint('Call started: ${event.callKitParams}');
    } catch (e) {
      debugPrint("Error handling call start: $e");
    }
  }

  void _handleCallAccept(CallEventActionCallAccept event) async {
    try {
      debugPrint("✅ Call Accepted => ${event.callKitParams}");
      await _stopRingtone();

      final callId = event.callKitParams?.id ?? "";

      if (callId.isNotEmpty) {
        await FlutterCallkitIncoming.setCallConnected(callId);
      }
      final sessionType =
          event.callKitParams?.extra?["sessionType"]?.toString() ?? "";
      log(("sessionType $sessionType"));
      await Future.delayed(const Duration(milliseconds: 200));
      if (Get.currentRoute != Routes.USER_REQUEST) {
        Get.to(UserRequestView(sessionType: sessionType));
      }

      if (Get.isRegistered<UserRequestController>()) {
        Get.find<UserRequestController>().fetchUserRequest(
          sessionType: sessionType,
        );
      } else {
        Get.put(
          UserRequestController(),
        ).fetchUserRequest(sessionType: sessionType);
      }
      await Future.delayed(const Duration(milliseconds: 300));
      if (callId.isNotEmpty) {
        await FlutterCallkitIncoming.endCall(callId);
      }
    } catch (e) {
      debugPrint("Error handling call accept: $e");
    }
  }

  void _handleCallDecline(CallEventActionCallDecline event) async {
    try {
      debugPrint('Call declined: ${event.callKitParams}');
      await _stopRingtone();
      _currentCallId = null;

      final extra = event.callKitParams?.extra;
      final data =
          extra?["sessionId"]?.toString() ??
          extra?["SessionId"]?.toString() ??
          "";
      int sessionId = int.tryParse(data) ?? 0;

      if (Get.isRegistered<UserRequestController>()) {
        await Get.find<UserRequestController>().statusUpdate(
          "Cancelled",
          sessionId,
          "Call",
        );
      } else {
        await Get.put(
          UserRequestController(),
        ).statusUpdate("Cancelled", sessionId, "Call");
      }
    } catch (e) {
      debugPrint("Error handling call decline: $e");
    }
  }

  void _handleCallEnded(CallEventActionCallEnded event) async {
    try {
      debugPrint('Call ended: ${event.callKitParams}');
      await _stopRingtone();
      _currentCallId = null;
    } catch (e) {
      debugPrint("Error handling call ended: $e");
    }
  }

  void _handleCallTimeout(CallEventActionCallTimeout event) async {
    try {
      debugPrint('Call timeout: ${event.id}');
      await _stopRingtone();
      _currentCallId = null;
      if (event.id != null) {
        hideCallNotification(event.id);
      }
    } catch (e) {
      debugPrint("Error handling call timeout: $e");
    }
  }

  void _handleCallCallback(CallEventActionCallCallback event) {
    debugPrint('Call callback: ${event.id}');
  }

  void _handleToggleHold(CallEventActionCallToggleHold event) {
    debugPrint('Toggle hold (iOS): ${event.id}, onHold: ${event.isOnHold}');
  }

  void _handleToggleMute(CallEventActionCallToggleMute event) {
    debugPrint('Toggle mute (iOS): ${event.id}, isMuted: ${event.isMuted}');
  }

  void _handleToggleDmtf(CallEventActionCallToggleDmtf event) {
    debugPrint('Toggle DMTF (iOS): ${event.id}, digits: ${event.digits}');
  }

  void _handleToggleGroup(CallEventActionCallToggleGroup event) {
    debugPrint('Toggle group (iOS): ${event.id}');
  }

  void _handleToggleAudioSession(CallEventActionCallToggleAudioSession event) {
    debugPrint('Toggle audio session (iOS): active: ${event.isActive}');
  }

  void _handleDevicePushTokenUpdate(
    CallEventActionDidUpdateDevicePushTokenVoip event,
  ) {
    debugPrint('Device push token updated (iOS)');
  }

  void _handleCustomAction(CallEventActionCallCustom event) {
    debugPrint('Custom action: ${event.body}');
  }
}
