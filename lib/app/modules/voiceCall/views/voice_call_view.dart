// ignore_for_file: deprecated_member_use
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/voice_call_controller.dart';

class VoiceCallView extends StatefulWidget {
  final String? channelName;
  final Session? session;
  const VoiceCallView({super.key, this.channelName, this.session});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  final VoiceCallController controller = Get.put(VoiceCallController());

  @override
  void dispose() {
    controller.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.channelName.value = widget.channelName ?? "";
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voice Call'),
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    controller.connectionStatus,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Channel Info
                // _buildChannelInfo(),

                // Participants List
                Expanded(child: _buildParticipantsList()),

                // Control Buttons
                _buildControlButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    return Obx(() {
      if (!controller.isJoined.value && !controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic_off, size: 80, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'Tap "Join Call" to start',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed:
                    () => controller.joinChannel(widget.channelName ?? ""),
                icon: const Icon(Icons.call),
                label: const Text('Join Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        );
      }

      // Show participants
      List<Widget> participants = [];

      // Add local user
      participants.add(
        _buildParticipantCard(
          uid: controller.localUid.value,
          isLocal: true,
          isMuted: controller.isMuted.value,
          name: "You",
          photo:
              controller
                  .profileController
                  .profileModel
                  .value
                  ?.data
                  ?.profilePicture ??
              "",
        ),
      );

      // Add remote users
      for (int uid in controller.remoteUsers) {
        participants.add(
          _buildParticipantCard(
            name:
                "${widget.session?.customer?.firstName ?? ''} ${widget.session?.customer?.lastName ?? ''}",

            photo: widget.session?.customer?.profilePicture ?? "",
            uid: uid,
            isLocal: false,
            isMuted: false, // You can track remote mute status if needed
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: participants.length,
        itemBuilder: (context, index) => participants[index],
      );
    });
  }

  // Widget _buildParticipantCard({
  //   required int uid,
  //   required bool isLocal,
  //   required bool isMuted,
  //   String? name,
  //   String? photo,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: isLocal ? Border.all(color: Colors.white, width: 2) : null,
  //     ),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundColor: isLocal ? Colors.green : Colors.blue,
  //           child: Text(
  //             isLocal ? 'You' : uid.toString(),
  //             style: const TextStyle(color: Colors.white, fontSize: 12),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             isLocal ? 'You (Local)' : 'User $uid',
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //         if (isMuted) const Icon(Icons.mic_off, color: Colors.red, size: 20),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildParticipantCard({
    required int uid,
    required bool isLocal,
    required bool isMuted,
    String? name,
    String? photo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isLocal ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.grey.shade300,
            child:
                widget.session?.astrologerPhoto?.isNotEmpty ?? false
                    ? ClipOval(
                      child: Image.network(
                        photo ?? "",
                        fit: BoxFit.cover,
                        width: 100.w,
                        height: 100.h,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, color: Colors.white);
                        },
                      ),
                    )
                    : const Icon(Icons.person, color: Colors.white),
          ),

          SizedBox(height: 10.h),

          Text(
            "$name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          //  Text(
          //   controller.timerText.value.isEmpty?"Calling...":controller.timerText.value,
          //   style:  TextStyle(
          //     color: Colors.white,
          //     fontSize: 19.sp,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
          if (isMuted) const Icon(Icons.mic_off, color: Colors.red, size: 20),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        if (!controller.isJoined.value) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute/Unmute Button
            _buildControlButton(
              icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
              color: controller.isMuted.value ? Colors.red : Colors.green,
              onPressed: controller.toggleMute,
            ),

            // Speaker Button
            _buildControlButton(
              icon:
                  controller.isSpeakerOn.value
                      ? Icons.volume_up
                      : Icons.volume_down,
              color: controller.isSpeakerOn.value ? Colors.blue : Colors.grey,
              onPressed: controller.toggleSpeaker,
            ),

            // End Call Button
            _buildControlButton(
              icon: Icons.call_end,
              color: Colors.red,
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 28,
      ),
    );
  }
}
