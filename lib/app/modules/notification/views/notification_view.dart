// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/notification/controllers/notification_controller.dart';
import 'package:astrology/app/data/models/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    // Fetch notifications when the view initializes
    controller.fetchNotification();
  }

  IconData _getNotificationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'promotion':
      case 'offer':
        return Icons.campaign;
      case 'order':
      case 'purchase':
        return Icons.shopping_bag;
      case 'reminder':
      case 'appointment':
        return Icons.notifications_active;
      case 'system':
      case 'update':
        return Icons.info;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'promotion':
      case 'offer':
        return AppColors.accentColor;
      case 'order':
      case 'purchase':
        return AppColors.primaryColor;
      case 'reminder':
      case 'appointment':
        return AppColors.secondaryPrimary;
      case 'system':
      case 'update':
        return AppColors.lightTextSecondary;
      case 'message':
        return AppColors.primaryColor;
      default:
        return AppColors.primaryColor;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    return today.isAtSameMomentAs(notificationDate) ||
        now.difference(dateTime).inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: AppTextStyles.headlineMedium().copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace:
                isDark
                    ? null
                    : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.headerGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
            elevation: 0,
          ),
          body: Obx(() {
            // Show loading indicator
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            final notifications =
                controller.notificationModel.value?.data ?? [];

            // Show empty state
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: secondaryTextColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Notifications",
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    Text(
                      "You're all caught up!",
                      style: AppTextStyles.body().copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Separate notifications by time
            final todayNotifications =
                notifications.where((n) => _isToday(n.createdAt)).toList();
            final earlierNotifications =
                notifications.where((n) => !_isToday(n.createdAt)).toList();

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                await controller.fetchNotification();
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [
                  if (todayNotifications.isNotEmpty) ...[
                    _buildSectionTitle("Today", textColor),
                    ...todayNotifications.map(
                      (notif) => _buildNotificationItem(
                        notification: notif,
                        cardColor: cardColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    if (earlierNotifications.isNotEmpty)
                      const SizedBox(height: 20),
                  ],
                  if (earlierNotifications.isNotEmpty) ...[
                    _buildSectionTitle("Earlier", textColor),
                    ...earlierNotifications.map(
                      (notif) => _buildNotificationItem(
                        notification: notif,
                        cardColor: cardColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w700,
            color: color.withOpacity(0.85),
            letterSpacing: 1.0,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required NotificationData notification,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final IconData icon = _getNotificationIcon(notification.type);
    final Color iconColor = _getIconColor(notification.type);
    final String formattedTime = _formatDateTime(notification.createdAt);

    return GestureDetector(
      onTap: () {
        // Handle action URL if present
        if (notification.actionUrl != null &&
            notification.actionUrl!.isNotEmpty) {}
      },
      child: Card(
        color: cardColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? '',
                      style: AppTextStyles.body().copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message ?? '',
                      style: AppTextStyles.caption().copyWith(
                        color: secondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedTime,
                      style: AppTextStyles.small().copyWith(
                        color: secondaryTextColor.withOpacity(0.6),
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
