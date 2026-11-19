// 1. Agora Controller - GetX Controller for managing voice call state
import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/callKit/call_kit_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  static const String APPID = "8afca3f27f524c65a4ead12c1f5f92fa";
  static const String APPCERTIFICATE = "d1dc9896ab264eb18df26c49dfe96e01";

  final userRequestController =
      Get.isRegistered<UserRequestController>()
          ? Get.find<UserRequestController>()
          : Get.put(UserRequestController());

  final profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  // Agora Engine instance
  RtcEngine? engine;

  // Observable variables
  RxBool isJoined = false.obs;
  RxBool isMuted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCalling = false.obs;
  RxBool isSpeakerOn = false.obs;
  RxList<int> remoteUsers = <int>[].obs;
  RxString channelName = ''.obs;
  RxInt localUid = 0.obs;

  String? token;
  bool _isStarting = false;

  @override
  void onClose() {
    leaveChannel();
    try {
      engine?.release();
      engine = null;
    } catch (e) {
      LoggerUtils.error("Error releasing Agora engine: $e");
    }
    super.onClose();
  }

  /// Start call with specified channel name safely
  Future<void> startCall(String channel) async {
    if (channel.trim().isEmpty) {
      LoggerUtils.error("Invalid empty channel name for call");
      return;
    }
    if (_isStarting || isJoined.value) return;
    _isStarting = true;
    channelName.value = channel;
    await generateToken(channelName: channel, userName: "User");
    _isStarting = false;
  }

  // Initialize Agora SDK
  Future<void> initializeAgora() async {
    if (channelName.value.trim().isEmpty) return;
    try {
      await CallKitManager().stopRingtoneSound();

      // Request microphone permission
      if (Platform.isAndroid) {
        await requestMicrophonePermission();
      }

      // Create Agora engine if null
      engine ??= createAgoraRtcEngine();

      await engine?.initialize(
        RtcEngineContext(
          appId: APPID,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Set event handlers before joining
      _setEventHandlers();

      // Enable audio
      await engine?.enableAudio();

      await joinChannel(channelName.value, uid: localUid.value);

      LoggerUtils.debug("Agora SDK initialized successfully");
    } catch (e) {
      isLoading.value = false;
      LoggerUtils.error("Error initializing Agora: $e");
      Get.snackbar("Error", "Failed to initialize voice call: $e");
    }
  }

  /// Requests microphone & bluetooth permission safely
  Future<void> requestMicrophonePermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.microphone, Permission.bluetoothConnect].request();

    if (statuses[Permission.microphone]?.isGranted != true) {
      throw Exception('Microphone permission not granted');
    }
  }

  // Set up event handlers safely
  void _setEventHandlers() {
    if (engine == null) return;

    engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          LoggerUtils.debug(
            "Local user joined channel: ${connection.channelId}",
          );
          isJoined.value = true;
          localUid.value = connection.localUid ?? localUid.value;
          isLoading.value = false;
          isSpeakerOn.value = true;
          try {
            await engine?.setEnableSpeakerphone(isSpeakerOn.value);
          } catch (e) {
            LoggerUtils.error("Error enabling speakerphone: $e");
          }
        },
        onUserJoined: (
          RtcConnection connection,
          int remoteUid,
          int elapsed,
        ) async {
          LoggerUtils.debug("Remote user joined: $remoteUid");
          if (!remoteUsers.contains(remoteUid)) {
            remoteUsers.add(remoteUid);
          }
        },

        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) async {
          LoggerUtils.debug("Remote user left: $remoteUid");
          remoteUsers.remove(remoteUid);
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          if (Get.currentRoute == Routes.VOICE_CALL) {
            Get.back();
          }
          userRequestController.fetchUserRequest(sessionType: "Call");
        },

        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          LoggerUtils.debug("Left channel");
          isJoined.value = false;
          remoteUsers.clear();
          localUid.value = 0;
          channelName.value = '';
          userRequestController.fetchUserRequest();
        },

        onAudioVolumeIndication: (
          RtcConnection connection,
          List<AudioVolumeInfo> speakers,
          int speakerNumber,
          int totalVolume,
        ) {
          // Handle volume indication if needed
        },

        onError: (ErrorCodeType err, String msg) {
          LoggerUtils.error("Agora Error: $err - $msg");
          Get.snackbar(
            "Error",
            "Voice call error: $msg",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      ),
    );
  }

  Future<void> generateToken({String? channelName, String? userName}) async {
    final channel = channelName ?? this.channelName.value;
    if (channel.trim().isEmpty) return;

    GlobalLoader.show();
    try {
      isLoading.value = true;
      const int tokenExpireSeconds = 3600; // 1 hour
      final uniqueUid = DateTime.now().millisecondsSinceEpoch % 1000000000;

      // Generate RTC token
      String etcToken = RtcTokenBuilder.buildTokenWithUid(
        appId: APPID,
        appCertificate: APPCERTIFICATE,
        channelName: channel,
        uid: uniqueUid,
        tokenExpireSeconds: tokenExpireSeconds,
      );
      token = etcToken;
      localUid.value = uniqueUid;
      this.channelName.value = channel;
      update();

      LoggerUtils.debug('🎯initial RTC Token: $token');
      LoggerUtils.debug('🎯initial RTC UId: $uniqueUid');
      LoggerUtils.debug('🎯initial RTC Channel: $channel');

      await initializeAgora();
    } catch (e) {
      isLoading.value = false;
      LoggerUtils.error("Error generating token: $e");
    } finally {
      GlobalLoader.hide();
    }
  }

  // Join a voice channel
  Future<void> joinChannel(String channel, {int uid = 0}) async {
    if (channel.trim().isEmpty) return;
    if (isJoined.value) {
      LoggerUtils.debug("Already in a channel");
      return;
    }

    try {
      isLoading.value = true;
      channelName.value = channel;

      await engine?.joinChannel(
        token: token ?? "",
        channelId: channel,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          isAudioFilterable: true,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          autoSubscribeAudio: true,
        ),
      );
    } catch (e) {
      isLoading.value = false;
      LoggerUtils.error("Error joining channel: $e");
      Get.snackbar("Error", "Failed to join channel: $e");
    }
  }

  // Leave the current channel safely
  Future<void> leaveChannel() async {
    if (!isJoined.value && engine == null) return;

    try {
      await engine?.leaveChannel();
      isJoined.value = false;
      remoteUsers.clear();
      LoggerUtils.debug("Left channel successfully");
    } catch (e) {
      LoggerUtils.error("Error leaving channel: $e");
    }
  }

  // Toggle mute/unmute safely
  Future<void> toggleMute() async {
    if (!isJoined.value || engine == null) return;

    try {
      isMuted.value = !isMuted.value;
      await engine?.muteLocalAudioStream(isMuted.value);
      LoggerUtils.debug("Audio ${isMuted.value ? 'muted' : 'unmuted'}");
    } catch (e) {
      LoggerUtils.error("Error toggling mute: $e");
    }
  }

  // Toggle speaker on/off safely
  Future<void> toggleSpeaker() async {
    if (engine == null) return;
    try {
      isSpeakerOn.value = !isSpeakerOn.value;
      await engine?.setEnableSpeakerphone(isSpeakerOn.value);
      LoggerUtils.debug(
        "Speaker ${isSpeakerOn.value ? 'enabled' : 'disabled'}",
      );
    } catch (e) {
      LoggerUtils.error("Error toggling speaker: $e");
    }
  }

  // Get connection status
  String get connectionStatus {
    if (isLoading.value) return "Connecting...";
    if (isJoined.value) return "Connected";
    return "Disconnected";
  }

  // Get participants count
  int get participantsCount => remoteUsers.length + (isJoined.value ? 1 : 0);
}
