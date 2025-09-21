// host_view.dart - UI for Astrologer (Broadcasting Live)
// ignore_for_file: deprecated_member_use

import 'dart:convert';


import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/host_astro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostView extends GetView<HostController> {
  const HostView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HostController());
    controller.liveWebSocketService?.sendMessage({
      "liveSessionID": 16,
      "userID": 800,
      "Username": "Honey",
      "message": "Hello, this is a test message!",
      "messageType": "Text",
      "profile_Url": "c://upload/abc.png",
      "amount": 0,
      "isVisible": true,
    });
   debugPrint("==>${json.encode(controller.messages)}");
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Obx(() {
          if (!controller.isEngineReady.value) {
            return _buildLoadingScreen();
          }

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0A0E27),
                      Color(0xFF1A1F3A),
                      Color(0xFF2A2F4A),
                    ],
                  ),
                ),
              ),

              // Main Video View (Host's camera)
              _buildHostVideoView(),

              // Top Controls
              _buildTopControls(),

              // Bottom Controls
              _buildBottomControls(),

              // Side Controls
              _buildSideControls(),

              // Live Status
              _buildLiveStatus(),

              // Live Timer
              _buildLiveTimer(),

              // Viewer Count
              _buildViewerCount(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2A2F4A)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Preparing live stream...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Setting up your broadcast',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostVideoView() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(
            children: [
              // Host's camera feed
              AgoraVideoView(controller: controller.localVideoViewController),
              // Live overlay when not live
              if (!controller.isLive.value)
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.live_tv,
                          color: Color(0xFFFF6B6B),
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to go live?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap "Go Live" to start broadcasting',
                          style: TextStyle(color: Colors.white60, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: controller.startLive,
                          icon: const Icon(Icons.live_tv, color: Colors.white),
                          label: const Text(
                            'Go Live',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B6B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () => _showEndLiveDialog(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),

          // Recording indicator
          if (controller.isRecording.value)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fiber_manual_record, color: Colors.white, size: 8),
                  SizedBox(width: 4),
                  Text(
                    'REC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Settings button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () => _showSettingsDialog(),
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute Button
            _buildControlButton(
              icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
              isActive: !controller.isMuted.value,
              onPressed: controller.toggleMute,
              tooltip: controller.isMuted.value ? 'Unmute' : 'Mute',
            ),

            // Camera Toggle Button
            _buildControlButton(
              icon:
                  controller.isCameraOff.value
                      ? Icons.videocam_off
                      : Icons.videocam,
              isActive: !controller.isCameraOff.value,
              onPressed: controller.toggleCamera,
              tooltip:
                  controller.isCameraOff.value
                      ? 'Turn on camera'
                      : 'Turn off camera',
            ),

            // End Live Button
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color:
                    controller.isLive.value
                        ? Colors.red
                        : const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed:
                    controller.isLive.value
                        ? () => _showEndLiveDialog()
                        : controller.startLive,
                icon: Icon(
                  controller.isLive.value ? Icons.stop : Icons.live_tv,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: controller.isLive.value ? 'End live' : 'Go live',
              ),
            ),

            // Switch Camera Button
            _buildControlButton(
              icon: Icons.switch_camera,
              isActive: true,
              onPressed: controller.switchCamera,
              tooltip: 'Switch camera',
            ),

            // More options
            _buildControlButton(
              icon: Icons.more_vert,
              isActive: true,
              onPressed: () => _showMoreOptions(),
              tooltip: 'More options',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideControls() {
    return Positioned(
      right: 16,
      top: 260,
      child: Column(
        children: [
          // Beauty filter button
          _buildSideButton(
            icon: Icons.face_retouching_natural,
            onPressed: controller.toggleBeautyFilter,
            tooltip: 'Beauty filter',
            isActive: controller.beautyFilterEnabled.value,
          ),
          const SizedBox(height: 12),

          // Screen share button
          _buildSideButton(
            icon:
                controller.isScreenSharing.value
                    ? Icons.stop_screen_share
                    : Icons.screen_share,
            onPressed: controller.toggleScreenShare,
            tooltip:
                controller.isScreenSharing.value
                    ? 'Stop sharing'
                    : 'Share screen',
            isActive: controller.isScreenSharing.value,
          ),
          const SizedBox(height: 12),

          // Recording button
          _buildSideButton(
            icon:
                controller.isRecording.value
                    ? Icons.stop
                    : Icons.radio_button_checked,
            onPressed: controller.toggleRecording,
            tooltip:
                controller.isRecording.value
                    ? 'Stop recording'
                    : 'Start recording',
            isActive: controller.isRecording.value,
          ),
          const SizedBox(height: 12),

          // // Virtual background button
          // _buildSideButton(
          //   icon: Icons.image,
          //   onPressed: controller.toggleVirtualBackground,
          //   tooltip: 'Virtual background',
          //   isActive: controller.virtualBackgroundEnabled.value,
          // ),
        ],
      ),
    );
  }

  Widget _buildLiveStatus() {
    return Positioned(
      top: 80,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              controller.isLive.value ? const Color(0xFFFF6B6B) : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isLive.value)
              const Icon(
                Icons.fiber_manual_record,
                color: Colors.white,
                size: 14,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                color: Colors.white,
                size: 14,
              ),
            const SizedBox(width: 6),
            Text(
              controller.isLive.value ? 'LIVE' : 'OFFLINE',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTimer() {
    return Positioned(
      top: 120.h,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Obx(
              () => Text(
                controller.liveDuration.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewerCount() {
    return Positioned(
      top: 70.h,
      right: 16.h,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Obx(
              () => Text(
                '${controller.viewerCount.value} viewer${controller.viewerCount.value != 1 ? 's' : ''}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFFFF6B6B)
                  : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isActive
                    ? const Color(0xFFFF6B6B)
                    : Colors.white.withOpacity(0.3),
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFFFF6B6B)
                  : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _showEndLiveDialog() {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.live_tv_rounded,
                color: AppColors.primaryColor,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'End Live Stream',
                style: GoogleFonts.poppins(
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to end your live stream?',
              style: GoogleFonts.openSans(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: AppColors.primaryColor,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'This will disconnect all viewers',
                      style: GoogleFonts.openSans(
                        color: AppColors.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),
          ),

          // End Live Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                Get.back();
                await controller.endLiveStram();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.white,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.stop_rounded,
                size: 16.r,
                color: AppColors.white,
              ),
              label: Text(
                'End Live',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showSettingsDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Live Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildSettingsItem(
              'Video Quality',
              Icons.hd,
              () => _showVideoQualityDialog(),
            ),
            _buildSettingsItem(
              'Audio Settings',
              Icons.volume_up,
              () => _showAudioSettingsDialog(),
            ),
            // _buildSettingsItem('Network Info', Icons.network_check, () => controller.runNetworkTest()),
            _buildSettingsItem('Help & Support', Icons.help, () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'More Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildSettingsItem(
              'Beauty Filter',
              Icons.face_retouching_natural,
              () {
                controller.toggleBeautyFilter();
              },
            ),
            _buildSettingsItem(
              'Noise Suppression',
              Icons.noise_control_off,
              () {
                controller.toggleNoiseSuppression();
              },
            ),
            _buildSettingsItem(
              'Voice Effects',
              Icons.record_voice_over,
              () => _showVoiceEffectsDialog(),
            ),
            _buildSettingsItem('Virtual Background', Icons.image, () {
              controller.toggleVirtualBackground();
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showVideoQualityDialog() {
    Get.back(); // Close settings first
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          'Video Quality',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQualityOption('SD (480p)', 'SD'),
            _buildQualityOption('HD (720p)', 'HD'),
            _buildQualityOption('FHD (1080p)', 'FHD'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _buildQualityOption(String title, String value) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        groupValue: controller.videoResolution.value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.setVideoResolution(newValue);
            Get.back();
          }
        },
        activeColor: const Color(0xFFFF6B6B),
      ),
    );
  }

  void _showAudioSettingsDialog() {
    Get.back(); // Close settings first
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          'Audio Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Audio Volume', style: TextStyle(color: Colors.white)),
            Obx(
              () => Slider(
                value: controller.audioVolume.value.toDouble(),
                min: 0,
                max: 100,
                divisions: 10,
                label: '${controller.audioVolume.value}%',
                activeColor: const Color(0xFFFF6B6B),
                onChanged: (double value) => controller.setAudioVolume(value),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Done')),
        ],
      ),
    );
  }

  void _showVoiceEffectsDialog() {
    Get.back(); // Close more options first
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Voice Effects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildVoiceEffectItem(
              'None',
              VoiceBeautifierPreset.voiceBeautifierOff,
            ),
            _buildVoiceEffectItem(
              'Magnetic',
              VoiceBeautifierPreset.chatBeautifierMagnetic,
            ),
            _buildVoiceEffectItem(
              'Fresh',
              VoiceBeautifierPreset.chatBeautifierFresh,
            ),
            _buildVoiceEffectItem(
              'Vitality',
              VoiceBeautifierPreset.chatBeautifierVitality,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceEffectItem(String title, VoiceBeautifierPreset preset) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        controller.setVoiceEffect(preset);
        Get.back();
      },
    );
  }
}
