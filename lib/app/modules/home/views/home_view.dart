// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, unused_field

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/home/controllers/home_controller.dart';
import 'package:astrology/app/modules/notification/controllers/notification_controller.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final userRequestController = Get.put(UserRequestController());

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: background,
          drawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            centerTitle: false,

            title: Text(
              "Astro Darshan Astrologer",
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
            actions: [
              GetBuilder<NotificationController>(
                init: NotificationController(),
                builder: (controller) {
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (controller.notificationModel.value?.unreadCount !=
                              0) {
                            controller.readNotification();
                          }
                          Get.toNamed(Routes.NOTIFICATION);
                        },
                        icon: Icon(
                          Icons.notifications_none,
                          color: AppColors.white,
                        ),
                      ),
                      controller.notificationModel.value?.unreadCount == null ||
                              controller.notificationModel.value?.unreadCount ==
                                  0
                          ? SizedBox()
                          : Positioned(
                            right: 8,
                            top: 5,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                controller.notificationModel.value?.unreadCount
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grid of Services
                GridView.count(
                  padding: EdgeInsets.only(top: 8.h, bottom: 14.h),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  childAspectRatio: 0.7,
                  children: [
                    AnimatedServiceCard(
                      onTap: () {
                        userRequestController.fetchUserRequest(
                          sessionType: "Chat",
                        );
                        Get.to(UserRequestView(sessionType: "Chat"));
                      },
                      icon: Icons.chat_bubble_outline,
                      title: "Chat Request",
                      color: AppColors.sucessPrimary,
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),

                    AnimatedServiceCard(
                      onTap: () {
                        userRequestController.fetchUserRequest(
                          sessionType: "Call",
                        );
                        Get.to(UserRequestView(sessionType: "Call"));
                      },
                      icon: Icons.phone,
                      title: "Call Request",
                      color: AppColors.secondaryPrimary,
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    AnimatedServiceCard(
                      onTap: () {
                        // userRequestController.fetchUserRequest(sessionType: "Call");
                        Get.toNamed(Routes.HOST_ASTRO);
                      },
                      icon: Icons.live_tv,
                      title: "Go Live",
                      color: AppColors.red,
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),

                    AnimatedServiceCard(
                      onTap: () {
                        // userRRequestController.fetchUserRequest(sessionType: "Call");
                        Get.toNamed(Routes.WALLET);
                      },
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Wallet Transactions",
                      color: AppColors.primaryColor,
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    AnimatedServiceCard(
                      onTap: () {
                        // userRequestController.fetchUserRequest(sessionType: "Call");
                        Get.toNamed(Routes.CUSTOMER);
                      },
                      icon: Icons.people,
                      title: "Customer",
                      color: AppColors.yellow.withRed(67),
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    AnimatedServiceCard(
                      onTap: () {
                        // userRequestController.fetchUserRequest(sessionType: "Call");

                        Get.toNamed(Routes.GIFT);
                      },
                      icon: Icons.card_giftcard,
                      title: "Gift",
                      color: AppColors.primaryColor.withRed(60),
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    AnimatedServiceCard(
                      onTap: () {
                        // userRequestController.fetchUserRequest(sessionType: "Call");
                        Get.toNamed(Routes.REVIEW);
                      },
                      icon: Icons.reviews,
                      title: "Review",
                      color: AppColors.darkTextPrimary.withRed(60),
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    AnimatedServiceCard(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      icon: Icons.person,
                      title: "Profile",
                      color: AppColors.primaryColor.withBlue(30),
                      cardColor: cardColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                  ],
                ),
                _buildOnlineOffline(
                  textColor,
                  AppColors.primaryColor,
                  AppColors.primaryColor,
                  AppColors.primaryColor,
                  isDark,
                ),
                // SizedBox(height: 20),
                // Obx(() {
                //   final profile =
                //       controller.profileController.profileModel.value;

                //   if (profile == null) {
                //     return Center(
                //       child: CircularProgressIndicator(
                //         color: AppColors.primaryColor,
                //       ),
                //     );
                //   }

                //   final isOnline = profile.data?.isOnline ?? false;
                //   return AnimatedOnlineStatus(
                //     cardColor: AppColors.primaryColor,
                //     isDark: true,
                //     initialStatus: isOnline,
                //     onStatusChanged: (status) {},
                //   );
                // }),
                SizedBox(height: 10),
                notificationView(),
                SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnlineOffline(
    Color textColor,
    Color highlightColor,
    Color highlightTextColor,
    Color secondaryColor,
    bool isDark,
  ) {
    final bool isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Column(
          children: [
            Obx(
              () => customToggleButton(
                isOnline: controller.isAvailableForChat.value,
                onToggle: () async {
                  controller.isAvailableForChat.value =
                      !controller.isAvailableForChat.value;
                  await controller.onlineOffline(
                    isAvailableForCall: controller.isAvailableForCall.value,
                    isAvailableForChat: controller.isAvailableForChat.value,
                  );
                  controller.update();
                },
                label: "Chat",
                activeIcon: Icons.chat,
                inactiveIcon: Icons.chat,
                activeColor: AppColors.accentColor,
                inactiveColor: Colors.grey,
                textColor: isDark ? AppColors.white : AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 5.h),
            Obx(
              () => customToggleButton(
                isOnline: controller.isAvailableForCall.value,
                onToggle: () async {
                  controller.isAvailableForCall.value =
                      !controller.isAvailableForCall.value;
                  await controller.onlineOffline(
                    isAvailableForCall: controller.isAvailableForCall.value,
                    isAvailableForChat: controller.isAvailableForChat.value,
                  );
                  controller.update();
                },
                label: "Call",
                activeIcon: Icons.call,
                inactiveIcon: Icons.call,
                activeColor: AppColors.accentColor,
                inactiveColor: Colors.grey,
                textColor: isDark ? AppColors.white : AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Container customToggleButton({
    required bool isOnline,
    required VoidCallback onToggle,
    String label = "Call",
    IconData? activeIcon,
    IconData? inactiveIcon,
    Color? activeColor,
    Color? inactiveColor,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(10),
          splashColor: (activeColor ?? AppColors.accentColor).withValues(
            alpha: 0.1,
          ),
          highlightColor: (activeColor ?? AppColors.accentColor).withValues(
            alpha: 0.05,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                // Icon Container with gradient
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isOnline
                              ? [
                                (activeColor ?? AppColors.accentColor)
                                    .withValues(alpha: 0.8),
                                (activeColor ?? AppColors.accentColor)
                                    .withValues(alpha: 0.5),
                              ]
                              : [
                                (inactiveColor ?? Colors.grey).withValues(
                                  alpha: 0.2,
                                ),
                                (inactiveColor ?? Colors.grey).withValues(
                                  alpha: 0.1,
                                ),
                              ],
                    ),
                    boxShadow:
                        isOnline
                            ? [
                              BoxShadow(
                                color: (activeColor ?? AppColors.accentColor)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : [],
                  ),
                  child: Icon(
                    isOnline
                        ? (activeIcon ?? Icons.call_rounded)
                        : (inactiveIcon ?? Icons.call_end_rounded),
                    color: AppColors.white,
                    size: 20.h,
                  ),
                ),
                SizedBox(width: 16.w),

                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.body().copyWith(
                          color:
                              isOnline
                                  ? (textColor ?? Colors.white)
                                  : (textColor ?? Colors.white).withValues(
                                    alpha: 0.5,
                                  ),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        isOnline ? "Enabled" : "Disabled",
                        style: AppTextStyles.body().copyWith(
                          color:
                              isOnline
                                  ? (textColor ?? AppColors.accentColor)
                                      .withValues(alpha: 0.9)
                                  : (textColor ?? Colors.grey).withValues(
                                    alpha: 0.7,
                                  ),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated Toggle Switch
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 56,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        isOnline
                            ? (activeColor ?? AppColors.accentColor)
                            : (inactiveColor ?? Colors.grey).withValues(
                              alpha: 0.3,
                            ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isOnline
                                ? (activeColor ?? AppColors.accentColor)
                                    .withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.1),
                        blurRadius: isOnline ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background indicator
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: isOnline ? null : 4,
                        right: isOnline ? 4 : null,
                        top: 4,
                        bottom: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Icon overlay
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: isOnline ? null : 8,
                        right: isOnline ? 8 : null,
                        top: 8,
                        child: Icon(
                          isOnline ? Icons.check_rounded : Icons.close_rounded,
                          size: 16,
                          color:
                              isOnline
                                  ? (activeColor ?? AppColors.accentColor)
                                  : (inactiveColor ?? Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card notificationView() {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h, top: 6.h),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('🔔', style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Important Notification',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Greeting
              Text(
                'Dear Astrologer,',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 12),

              // Main content
              Text(
                'We kindly remind you to strictly follow our Privacy Policy and Terms & Conditions.',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.95),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 12),

              // Warning box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚠️', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please do not contact users directly or share any personal details outside the app.',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Additional info
              Text(
                'All communications must take place only through the official app to ensure a safe and trusted experience for both you and the users.',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.95),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              // Footer
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text('✨', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank you for your understanding and cooperation.',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '— Team Astro Darshan',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color cardColor;
  final Color textColor;
  final bool isDark;
  final void Function()? onTap;

  // ignore: use_super_parameters
  const AnimatedServiceCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.cardColor,
    required this.textColor,
    required this.isDark,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedServiceCardState createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.cardColor, widget.cardColor.withOpacity(0.9)],
                ),
                borderRadius: BorderRadius.circular(14.sp),
                border: Border.all(
                  color: widget.color.withOpacity(_isPressed ? 0.4 : 0.2),
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        widget.isDark
                            ? Colors.black.withOpacity(
                              0.4 * _elevationAnimation.value,
                            )
                            : widget.color.withOpacity(
                              0.2 * _elevationAnimation.value,
                            ),
                    spreadRadius: 0,
                    blurRadius: 15 * _elevationAnimation.value,
                    offset: Offset(0, 6 * _elevationAnimation.value),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: _isPressed ? 1 : 1.0),
                    duration: Duration(milliseconds: 200),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                widget.color.withOpacity(
                                  _isPressed ? 0.25 : 0.15,
                                ),
                                widget.color.withOpacity(
                                  _isPressed ? 0.15 : 0.08,
                                ),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.color.withOpacity(
                                _isPressed ? 0.4 : 0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 14),

                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedOnlineStatus extends StatefulWidget {
  final Color cardColor;
  final bool isDark;
  final bool initialStatus;
  final Function(bool)? onStatusChanged;

  const AnimatedOnlineStatus({
    super.key,
    required this.cardColor,
    required this.isDark,
    this.initialStatus = false,
    this.onStatusChanged,
  });

  @override
  _AnimatedOnlineStatusState createState() => _AnimatedOnlineStatusState();
}

class _AnimatedOnlineStatusState extends State<AnimatedOnlineStatus>
    with TickerProviderStateMixin {
  late bool isOnline;
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    isOnline = widget.initialStatus;

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (isOnline) {
      _pulseController.repeat(reverse: true);
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleStatus() {
    setState(() {
      isOnline = !isOnline;
    });

    _controller.reset();
    _controller.forward();

    if (isOnline) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }

    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!(isOnline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: isOnline ? 2000 : 0),
      height: (isOnline) ? 410.h : 300.h,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors:
                isOnline
                    ? [
                      Color.fromARGB(255, 47, 121, 1),
                      Color.fromARGB(255, 7, 70, 9),
                      Color.fromARGB(255, 47, 121, 1),
                    ]
                    : [
                      AppColors.primaryColor,
                      AppColors.accentColor,
                      AppColors.primaryColor,
                    ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            isOnline ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              AnimatedContainer(
                duration: Duration(milliseconds: isOnline ? 2000 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Status Icon
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _controller,
                        _pulseController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.8 * (isOnline ? _pulseAnimation.value : 0.8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow rings
                              if (isOnline) ...[
                                Container(
                                  width: 280,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                              ],
                              // Main circle
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isOnline ? Icons.power : Icons.power_off,
                                  size: 80,
                                  color:
                                      isOnline
                                          ? Color(0xFF4CAF50)
                                          : Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Status Text
                    AnimatedContainer(
                      duration: Duration(milliseconds: isOnline ? 2000 : 0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              isOnline ? 'ONLINE' : 'OFFLINE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              isOnline
                                  ? 'You are available for consultations'
                                  : 'Tap below to go online',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // Toggle Button
              GestureDetector(
                onTap: _toggleStatus,
                child: AnimatedContainer(
                  width: 130.w,
                  duration: Duration(milliseconds: isOnline ? 2000 : 0),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isOnline ? Icons.toggle_on : Icons.toggle_off,
                        color: isOnline ? Color(0xFF4CAF50) : Color(0xFF757575),
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Text(
                        isOnline ? 'Go Offline' : 'Go Online',
                        style: TextStyle(
                          color:
                              isOnline ? Color(0xFF4CAF50) : Color(0xFF757575),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
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
}
