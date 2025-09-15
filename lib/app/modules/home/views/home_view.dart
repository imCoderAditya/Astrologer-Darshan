// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:ui';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/notification/controllers/notification_controller.dart';
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

    return Scaffold(
      backgroundColor: background,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: Icon(Icons.menu, color: AppColors.white),
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
                          controller.notificationModel.value?.unreadCount == 0
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
            AnimatedOnlineStatus(
              cardColor: isDark ? AppColors.darkBackground : AppColors.white,
              isDark: isDark,
            ),
            SizedBox(height: 20),

            // Grid of Services
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                AnimatedServiceCard(
                  onTap: () {
                    userRequestController.fetchUserRequest(sessionType: "Chat");
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
                    userRequestController.fetchUserRequest(sessionType: "Call");
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
                // _buildServiceCard(
                //   icon: Icons.assignment,
                //   title: "Report Request",
                //   color: AppColors.accentColor,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.wb_sunny_outlined,
                //   title: "Daily Horoscope",
                //   color: AppColors.primaryColor,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.auto_graph,
                //   title: "Free kundli",
                //   color: AppColors.red,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.favorite_border,
                //   title: "Kundli Matching",
                //   color: AppColors.sucessPrimary,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.temple_hindu,
                //   title: "My Puja",
                //   color: AppColors.secondaryPrimary,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.play_circle_outline,
                //   title: "Get Course",
                //   color: AppColors.red,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.school_outlined,
                //   title: "My Courses",
                //   color: AppColors.primaryColor,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.people_outline,
                //   title: "My Followers",
                //   color: AppColors.red,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.inventory_2_outlined,
                //   title: "Products",
                //   color: AppColors.sucessPrimary,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                AnimatedServiceCard(
                  onTap: () {
                    // userRequestController.fetchUserRequest(sessionType: "Call");
                    Get.toNamed(Routes.WALLET);
                  },
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Wallet Transactions",
                  color: AppColors.primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  isDark: isDark,
                ),

                // _buildServiceCard(
                //   icon: Icons.history,
                //   title: "History",
                //   color: AppColors.primaryColor,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                // _buildServiceCard(
                //   icon: Icons.rate_review_outlined,
                //   title: "Customer Review",
                //   color: AppColors.accentColor,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
              ],
            ),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Widget _buildServiceCard({
  //   required IconData icon,
  //   required String title,
  //   required Color color,
  //   required Color cardColor,
  //   required Color textColor,
  //   required bool isDark,
  //   void Function()? onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: cardColor,
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(color: color.withOpacity(0.3), width: 1.5),
  //         boxShadow: [
  //           BoxShadow(
  //             color:
  //                 isDark
  //                     ? AppColors.black.withOpacity(0.2)
  //                     : AppColors.lightDivider.withOpacity(0.1),
  //             spreadRadius: 1,
  //             blurRadius: 4,
  //             offset: Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(0.1),
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(icon, color: color, size: 28),
  //           ),
  //           SizedBox(height: 8),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 8),
  //             child: Text(
  //               title,
  //               style: AppTextStyles.small().copyWith(
  //                 color: textColor,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               textAlign: TextAlign.center,
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.cardColor, widget.cardColor.withOpacity(0.9)],
                ),
                borderRadius: BorderRadius.circular(22),
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
                    tween: Tween(begin: 0.0, end: _isPressed ? 1.2 : 1.0),
                    duration: Duration(milliseconds: 200),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: EdgeInsets.all(16),
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
                            size: 34,
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
                      fontSize: 14.5,
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

// Animated version with pulsing indicator
class AnimatedOnlineStatus extends StatefulWidget {
  final Color cardColor;
  final bool isDark;

  const AnimatedOnlineStatus({
    Key? key,
    required this.cardColor,
    required this.isDark,
  }) : super(key: key);

  @override
  _AnimatedOnlineStatusState createState() => _AnimatedOnlineStatusState();
}

class _AnimatedOnlineStatusState extends State<AnimatedOnlineStatus>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.cardColor, widget.cardColor.withOpacity(0.95)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.sucessPrimary.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                widget.isDark
                    ? AppColors.black.withOpacity(0.6)
                    : AppColors.sucessPrimary.withOpacity(0.12),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(widget.isDark ? 0.05 : 0.8),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Enhanced icon with glow effect
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.sucessPrimary.withOpacity(0.15),
                  AppColors.sucessPrimary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.sucessPrimary.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sucessPrimary.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.wifi_rounded,
              color: AppColors.sucessPrimary,
              size: 22,
            ),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Text(
              "You are Currently Online",
              style: AppTextStyles.body().copyWith(
                color: AppColors.sucessPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                height: 1.2,
              ),
            ),
          ),

          // Animated status indicator
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Row(
                children: [
                  Text(
                    "Online",
                    style: AppTextStyles.body().copyWith(
                      color: AppColors.sucessPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                  SizedBox(width: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 20 * _pulseAnimation.value,
                        height: 20 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          color: AppColors.sucessPrimary.withOpacity(
                            0.3 * (1 - _pulseAnimation.value),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.sucessPrimary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.sucessPrimary.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
