// host_controller.dart - For Astrologer (Broadcasting Live)
// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const String APPID = "25747e4b1b9c43d8a8b7cde83abddf45";
const String APPCERTIFICATE = "3bac8b59eec041909daf6ef145021e45";

class HostController extends GetxController {
  final userId = LocalStorageService.getUserId();
  late RtcEngine engine;
  String? channelName;
  String? userName;
  String? token;
  int? uId;

  // Basic states
  final isEngineReady = false.obs;
  final isLive = false.obs;
  final isMuted = false.obs;
  final isCameraOff = false.obs;
  final connectionState = 'disconnected'.obs;

  // Host-specific features
  final isRecording = false.obs;
  final isScreenSharing = false.obs;
  final viewerCount = 0.obs;
  final liveDuration = '00:00'.obs;
  final networkQuality = 'excellent'.obs;
  final beautyFilterEnabled = false.obs;
  final virtualBackgroundEnabled = false.obs;
  final noiseSuppressionEnabled = false.obs;

  // Video controller
  late VideoViewController localVideoViewController;

  // Timer
  Timer? _liveTimer;
  int _liveStartTime = 0;

  // Audio/Video settings
  final audioVolume = 100.obs;
  final videoResolution = 'HD'.obs;
  final frameRate = 30.obs;

  Future<bool> initData({
    String? etcToken,
    String? channelName,
    int? uId,
    String? userName,
  }) async {
    token = etcToken;
    this.uId = uId;
    this.channelName = channelName;
    this.userName = userName;
    LoggerUtils.debug('🎯Host UId: $uId');
    LoggerUtils.debug('🎯Host Channel: $channelName');
    LoggerUtils.debug('🎯Host Token: $etcToken');
    await initAgora();
    update();
    return true;
  }

  Future<void> generateToken({String? channelName, String? userName}) async {
    GlobalLoader.show();
    const String appId = APPID;
    const String appCertificate = APPCERTIFICATE;
    const int tokenExpireSeconds = 3600; // 1 hour
    final uniqueUid = DateTime.now().millisecondsSinceEpoch % 1000000000;

    // Generate RTC token for broadcaster
    String etcToken = RtcTokenBuilder.buildTokenWithUid(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName ?? "",
      uid: uniqueUid,
      tokenExpireSeconds: tokenExpireSeconds,
    );
    token = etcToken;
    uId = uniqueUid;
    this.channelName = channelName;
    this.userName = userName;
    update();
    LoggerUtils.debug('🎯Host Token Generated: $token');
    LoggerUtils.debug('🎯Host UId: $uId');
    LoggerUtils.debug('🎯Host Channel: $channelName');

    await initAgora();
    GlobalLoader.hide();
    Get.toNamed(Routes.HOST_ASTRO);
  }

  @override
  void onClose() {
    _liveTimer?.cancel();
    // stopLive();
    endLiveStram();
    super.onClose();
  }

  Future<void> initAgora() async {
    try {
      await _requestPermissions();

      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(appId: APPID));

      localVideoViewController = VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('Host joined channel: ${connection.channelId}');
            isLive.value = true;
            connectionState.value = 'live';
            _startLiveTimer();
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            debugPrint('Viewer joined: $uid');
            viewerCount.value++;
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            debugPrint('Viewer left: $uid');
            if (viewerCount.value > 0) {
              viewerCount.value--;
            }
          },
          onConnectionStateChanged: (
            RtcConnection connection,
            ConnectionStateType state,
            ConnectionChangedReasonType reason,
          ) {
            debugPrint('Host connection state: $state');
            switch (state) {
              case ConnectionStateType.connectionStateConnected:
                connectionState.value = 'live';
                break;
              case ConnectionStateType.connectionStateConnecting:
                connectionState.value = 'connecting';
                break;
              case ConnectionStateType.connectionStateReconnecting:
                connectionState.value = 'reconnecting';
                break;
              case ConnectionStateType.connectionStateFailed:
                connectionState.value = 'failed';
                break;
              default:
                connectionState.value = 'disconnected';
            }
          },
          onNetworkQuality: (
            RtcConnection connection,
            int remoteUid,
            QualityType txQuality,
            QualityType rxQuality,
          ) {
            switch (txQuality) {
              case QualityType.qualityExcellent:
              case QualityType.qualityGood:
                networkQuality.value = 'excellent';
                break;
              case QualityType.qualityPoor:
              case QualityType.qualityBad:
                networkQuality.value = 'poor';
                break;
              default:
                networkQuality.value = 'fair';
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Host Agora Error: $err - $msg');
            connectionState.value = 'failed';
          },
        ),
      );

      // Configure for broadcasting
      await _configureForBroadcasting();

      isEngineReady.value = true;
    } catch (e) {
      debugPrint('Error initializing Host Agora: $e');
      SnackBarUiView.showError(message: 'Failed to initialize live stream: $e');
    }
  }

  Future<void> _configureForBroadcasting() async {
    // Enable video and audio
    await engine.enableVideo();
    await engine.enableAudio();

    // Set client role as broadcaster (host)
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // Set channel profile for live broadcasting
    await engine.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );

    // Configure video for broadcasting
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 1280, height: 720),
        frameRate: 30,
        bitrate: 2000, // Higher bitrate for broadcasting
        orientationMode: OrientationMode.orientationModeFixedPortrait,
      ),
    );

    // Enable audio processing
    await engine.enableAudioVolumeIndication(
      interval: 200,
      smooth: 3,
      reportVad: true,
    );

    // Start local preview
    await engine.startPreview();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  void _startLiveTimer() {
    _liveStartTime = DateTime.now().millisecondsSinceEpoch;
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final duration = DateTime.now().millisecondsSinceEpoch - _liveStartTime;
      final hours = (duration ~/ 3600000).toString().padLeft(2, '0');
      final minutes = ((duration % 3600000) ~/ 60000).toString().padLeft(
        2,
        '0',
      );
      final seconds = ((duration % 60000) ~/ 1000).toString().padLeft(2, '0');
      liveDuration.value = '$hours:$minutes:$seconds';
    });
  }

  // Start live streaming
  Future<void> startLive() async {
    try {
      await engine.joinChannel(
        token: token ?? "",
        channelId: channelName ?? "",
        uid: uId ?? 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          isAudioFilterable: true,
        ),
      );

      SnackBarUiView.showSuccess(message: 'Live stream started!');
    } catch (e) {
      debugPrint('Error starting live: $e');
      SnackBarUiView.showError(message: 'Failed to start live stream');
    }
  }

  // Basic controls
  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await engine.muteLocalAudioStream(isMuted.value);
    SnackBarUiView.showSuccess(
      message: isMuted.value ? 'Microphone muted' : 'Microphone unmuted',
    );
  }

  Future<void> toggleCamera() async {
    isCameraOff.value = !isCameraOff.value;
    await engine.muteLocalVideoStream(isCameraOff.value);
    SnackBarUiView.showSuccess(
      message: isCameraOff.value ? 'Camera turned off' : 'Camera turned on',
    );
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    SnackBarUiView.showSuccess(message: 'Camera switched');
  }

  // Advanced features
  Future<void> toggleRecording() async {
    isRecording.value = !isRecording.value;
    SnackBarUiView.showSuccess(
      message: isRecording.value ? 'Recording started' : 'Recording stopped',
    );
  }

  Future<void> toggleScreenShare() async {
    isScreenSharing.value = !isScreenSharing.value;

    try {
      if (isScreenSharing.value) {
        await engine.startScreenCapture(const ScreenCaptureParameters2());
      } else {
        await engine.stopScreenCapture();
      }
      SnackBarUiView.showSuccess(
        message:
            isScreenSharing.value
                ? 'Screen sharing started'
                : 'Screen sharing stopped',
      );
    } catch (e) {
      debugPrint('Screen share error: $e');
      isScreenSharing.value = false;
      SnackBarUiView.showError(message: 'Failed to start screen sharing');
    }
  }

  Future<void> toggleBeautyFilter() async {
    beautyFilterEnabled.value = !beautyFilterEnabled.value;

    const beautyOptions = BeautyOptions(
      lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
      lighteningLevel: 0.7,
      smoothnessLevel: 0.5,
      rednessLevel: 0.1,
      sharpnessLevel: 0.3,
    );

    await engine.setBeautyEffectOptions(
      enabled: beautyFilterEnabled.value,
      options: beautyOptions,
    );
    SnackBarUiView.showSuccess(
      message:
          beautyFilterEnabled.value
              ? 'Beauty filter enabled'
              : 'Beauty filter disabled',
    );
  }

  Future<void> toggleNoiseSuppression() async {
    noiseSuppressionEnabled.value = !noiseSuppressionEnabled.value;
    SnackBarUiView.showSuccess(
      message:
          noiseSuppressionEnabled.value
              ? 'Noise suppression enabled'
              : 'Noise suppression disabled',
    );
  }

  Future<void> toggleVirtualBackground() async {
    virtualBackgroundEnabled.value = !virtualBackgroundEnabled.value;
    SnackBarUiView.showSuccess(
      message:
          virtualBackgroundEnabled.value
              ? 'Virtual background enabled'
              : 'Virtual background disabled',
    );
  }

  Future<void> setAudioVolume(double volume) async {
    audioVolume.value = volume.round();
    await engine.adjustPlaybackSignalVolume(audioVolume.value);
  }

  Future<void> setVideoResolution(String resolution) async {
    videoResolution.value = resolution;

    VideoDimensions dimensions;
    int bitrate;
    switch (resolution) {
      case 'HD':
        dimensions = const VideoDimensions(width: 1280, height: 720);
        bitrate = 2000;
        break;
      case 'FHD':
        dimensions = const VideoDimensions(width: 1920, height: 1080);
        bitrate = 4000;
        break;
      case 'SD':
        dimensions = const VideoDimensions(width: 640, height: 480);
        bitrate = 1000;
        break;
      default:
        dimensions = const VideoDimensions(width: 1280, height: 720);
        bitrate = 2000;
    }

    await engine.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: dimensions,
        frameRate: frameRate.value,
        bitrate: bitrate,
      ),
    );
  }

  Future<void> stopLive() async {
    try {
      _liveTimer?.cancel();
      await engine.leaveChannel();
      await engine.stopPreview();
      await engine.release();

      // Reset states
      isLive.value = false;
      isEngineReady.value = false;
      connectionState.value = 'disconnected';
      viewerCount.value = 0;
      liveDuration.value = '00:00';
      isRecording.value = false;
      isScreenSharing.value = false;
    } catch (e) {
      debugPrint('Error stopping live: $e');
    }
  }

  // Voice effects for astrologer
  Future<void> setVoiceEffect(VoiceBeautifierPreset preset) async {
    await engine.setVoiceBeautifierPreset(preset);
    SnackBarUiView.showSuccess(message: 'Voice effect applied');
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initTokenAndEngine();
    });
    super.onInit();
  }

  int? liveStramId;
  Future<void> _initTokenAndEngine() async {
    await goLiveAPI();
    // await generateToken(channelName:"abcd1423544fffdf67", userName: "Astrologer");
  }

  // Go Live API integrate  it given below

  Future<void> goLiveAPI() async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.goLive,
        formData: FormData.fromMap({
          "AstrologerID": 28,
          "Title": "Live Astrology Q&A",
          "Description": "Ask me anything live!",
          "Category": "Horoscope",

          // 'ThumbnailFile': await MultipartFile.fromFile(
          //   'D:/aditya_new/Astrologer-Darshan/assets/images/astro.png',
          //   filename: 'astro.png',
          // ),
        }),
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug(
          "Response------------:-- ${res.data}",
          tag: 'goLiveAPI',
        );
        var streamkey = res.data['data'];
        liveStramId = streamkey["LiveSessionID"];
        log("LiveStramId $liveStramId");
        await generateToken(
          channelName: streamkey['StreamKey'] ?? '',
          userName: streamkey['Title'] ?? '',
        );
      } else {
        LoggerUtils.error("Error:${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error:$e");
    } finally {
      update();
    }
  }

  Future<void> endLiveStram() async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.liveSessionUpdateStatus,
        data: {"LiveSessionID": liveStramId, "NewStatus": "Ended"},
      );

      if (res != null && res.statusCode == 200) {
        await stopLive();
        Get.back();
        GlobalLoader.hide();
        LoggerUtils.debug("Response : ${res.data}");
      } else {
        GlobalLoader.hide();
        LoggerUtils.debug("Failed : ${res?.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("Error: $e");
    }
  }
}
