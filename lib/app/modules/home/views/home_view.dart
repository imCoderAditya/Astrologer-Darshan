// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/app/modules/userRequest/views/user_request_view.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Icon(Icons.menu, color: AppColors.white),
        title: Text(
          "Astro Darshan Astrologer",
          style: AppTextStyles.headlineLarge().copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.NOTIFICATION);
                },
                icon: Icon(Icons.notifications_none, color: AppColors.white),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "7",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Online Status
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? AppColors.black.withOpacity(0.3)
                            : AppColors.lightDivider.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "You are Currently Online",
                    style: AppTextStyles.body().copyWith(
                      color: AppColors.sucessPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Online",
                        style: AppTextStyles.body().copyWith(
                          color: AppColors.sucessPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.sucessPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Grid of Services
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildServiceCard(
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

                _buildServiceCard(
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
                _buildServiceCard(
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
                _buildServiceCard(
                  icon: Icons.wb_sunny_outlined,
                  title: "Daily Horoscope",
                  color: AppColors.primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
                _buildServiceCard(
                  icon: Icons.auto_graph,
                  title: "Free kundli",
                  color: AppColors.red,
                  cardColor: cardColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
                _buildServiceCard(
                  icon: Icons.favorite_border,
                  title: "Kundli Matching",
                  color: AppColors.sucessPrimary,
                  cardColor: cardColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
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
                _buildServiceCard(
                  icon: Icons.people_outline,
                  title: "My Followers",
                  color: AppColors.red,
                  cardColor: cardColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
                // _buildServiceCard(
                //   icon: Icons.inventory_2_outlined,
                //   title: "Products",
                //   color: AppColors.sucessPrimary,
                //   cardColor: cardColor,
                //   textColor: textColor,
                //   isDark: isDark,
                // ),
                _buildServiceCard(
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

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required bool isDark,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? AppColors.black.withOpacity(0.2)
                      : AppColors.lightDivider.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: AppTextStyles.small().copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
