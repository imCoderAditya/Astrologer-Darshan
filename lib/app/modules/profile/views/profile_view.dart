// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/profile/profile_model.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        ProfileData? profileData = controller.profileModel.value?.data;
        return Scaffold(
          backgroundColor: background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280.0,
                backgroundColor: AppColors.primaryColor,
                floating: false,
                pinned: false,

                // title: Text(
                //   "Profile",
                //   style: AppTextStyles.body().copyWith(
                //     color: AppColors.white,
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                centerTitle: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                ),

                actionsPadding: EdgeInsets.symmetric(horizontal: 10),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16.0),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // Enhanced profile picture with zodiac ring
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer zodiac ring
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryColor.withOpacity(
                                              0.8,
                                            ),
                                            AppColors.accentColor.withOpacity(
                                              0.8,
                                            ),
                                            AppColors.secondaryPrimary
                                                .withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 95,
                                          height: 95,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: background,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Profile picture
                                    CircleAvatar(
                                      radius: 42,
                                      backgroundColor: AppColors.white,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          profileData?.profilePicture ?? "",
                                        ),
                                      ),
                                    ),

                                    // Zodiac sign indicator
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          "♌", // Leo symbol as example
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Name with mystical styling
                          Text(
                            "${profileData?.firstName ?? ""} ${profileData?.lastName ?? ""}",
                            style: AppTextStyles.headlineMedium().copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: AppColors.primaryColor.withOpacity(
                                    0.5,
                                  ),
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Astrologer designation
                          Text(
                            profileData?.specializations ?? "",
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            profileData?.email ?? "",
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Bio :\t",
                                  style: AppTextStyles.caption().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: profileData?.bio,
                                  style: AppTextStyles.caption().copyWith(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: 10.sp,
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
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Astrology Stats Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? AppColors.black.withOpacity(0.3)
                                    : AppColors.lightDivider.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Astrological Profile",
                              style: AppTextStyles.body().copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  "♌",
                                  "Leo",
                                  "Sun Sign",
                                  textColor,
                                  secondaryTextColor,
                                ),
                                _buildStatItem(
                                  "♋",
                                  "Cancer",
                                  "Moon Sign",
                                  textColor,
                                  secondaryTextColor,
                                ),
                                _buildStatItem(
                                  "♍",
                                  "Virgo",
                                  "Rising",
                                  textColor,
                                  secondaryTextColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Personal Info Card with enhanced design
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? AppColors.black.withOpacity(0.3)
                                    : AppColors.lightDivider.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Information",
                              style: AppTextStyles.body().copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              Icons.phone_android,
                              "Phone Number",
                              profileData?.phoneNumber ?? "",
                              textColor,
                              secondaryTextColor,
                            ),
                            Divider(
                              color: dividerColor.withOpacity(0.6),
                              height: 35,
                              thickness: 1,
                            ),
                            _buildInfoRow(
                              Icons.location_on,
                              "Current Location",
                              profileData?.placeOfBirth ?? "",
                              textColor,
                              secondaryTextColor,
                            ),
                            Divider(
                              color: dividerColor.withOpacity(0.6),
                              height: 35,
                              thickness: 1,
                            ),
                            _buildInfoRow(
                              Icons.cake,
                              "Birth Date",
                              AppDateUtils.extractDate(
                                profileData?.dateOfBirth,
                                5,
                              ),
                              textColor,
                              secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Account Settings Section
                  _buildSectionTitle("Account Settings", textColor),
                  _buildSettingsTile(
                    Icons.lock_outline,
                    "Change Password",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Change Password Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  _buildSettingsTile(
                    Icons.notifications_none,
                    "Notifications",
                    textColor: textColor,
                    trailing: Switch(
                      value: true,
                      onChanged: (bool value) {
                        Get.snackbar(
                          "Notifications",
                          "Notifications Toggled: $value",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.sucessPrimary,
                          colorText: AppColors.white,
                        );
                      },
                      activeColor: AppColors.primaryColor,
                      inactiveThumbColor: secondaryTextColor,
                      inactiveTrackColor: dividerColor,
                    ),
                  ),

                  _buildSettingsTile(
                    Icons.auto_awesome,
                    "Daily Horoscope Settings",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Horoscope Settings Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  _buildSettingsTile(
                    Icons.security,
                    "Privacy Policy",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Privacy Policy Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  const SizedBox(height: 25),

                  // App Section
                  _buildSectionTitle("Astrology Services", textColor),
                  _buildSettingsTile(
                    Icons.article_outlined,
                    "Birth Chart Analysis",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Service",
                          "Birth Chart Analysis Available",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  _buildSettingsTile(
                    Icons.favorite_outline,
                    "Compatibility Report",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Service",
                          "Compatibility Report Available",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  _buildSettingsTile(
                    Icons.star_rate_rounded,
                    "Rate Our Services",
                    textColor: textColor,
                    onTap:
                        () => Get.snackbar(
                          "Action",
                          "Rate Us Tapped",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.primaryColor,
                          colorText: AppColors.white,
                        ),
                  ),

                  const SizedBox(height: 35),

                  // Enhanced Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.red.withOpacity(0.8),
                                  AppColors.red,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.red.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showAttractiveLogoutDialog(
                                  isDark,
                                  cardColor,
                                  textColor,
                                  secondaryTextColor,
                                );
                              },
                              icon: Icon(Icons.logout, color: AppColors.white),
                              label: Text(
                                "Logout",
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method for astrology stats
  Widget _buildStatItem(
    String symbol,
    String sign,
    String type,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        Text(
          symbol,
          style: TextStyle(fontSize: 28, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          sign,
          style: AppTextStyles.small().copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          type,
          style: AppTextStyles.caption().copyWith(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 22),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 20, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: AppTextStyles.caption().copyWith(
              fontWeight: FontWeight.w700,
              color: color.withOpacity(0.85),
              letterSpacing: 1.0,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body().copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: textColor.withOpacity(0.6),
                    size: 24,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAttractiveLogoutDialog(
  bool isDark,
  Color cardColor,
  Color textColor,
  Color secondaryTextColor,
) {
  Get.defaultDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.logout, color: AppColors.red, size: 40),
        ),
        const SizedBox(height: 20),
        Text(
          "Leave Your Cosmic Journey?",
          style: AppTextStyles.headlineMedium().copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "The stars will miss your presence. Are you sure you want to logout?",
          style: AppTextStyles.body().copyWith(color: secondaryTextColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Stay Connected",
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await LocalStorageService.logout().then((value) {
                    Get.offAllNamed(Routes.LOGIN);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 5,
                ),
                child: Text(
                  "Logout",
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    backgroundColor: cardColor,
    title: "",
    middleText: "",
  );
}
