// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart'
    show AppTextStyles;
import 'package:astrology/app/core/config/theme/theme_controller.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/login_controller.dart';
import 'package:phone_form_field/phone_form_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.put(ThemeController());
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFF),
          body: Stack(
            children: [
              // Animated gradient background
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient:
                      isDark
                          ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0A0A0A),
                              Color(0xFF1A1A2E),
                              Color(0xFF16213E),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          )
                          : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF8FAFF),
                              Color(0xFFE8F4FD),
                              Color(0xFFDCF2FF),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                ),
              ),

              // Floating geometric shapes
              Positioned(
                top: -20,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.1),
                        AppColors.primaryColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main content
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),

                    // Brand Logo with animation container
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.stars_rounded,
                        size: 48.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Welcome text with better typography
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.8),
                            ],
                          ).createShader(bounds),
                      child: Text(
                        'Welcome Back',
                        style: AppTextStyles.brandLogo.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Subtitle with better spacing
                    Text(
                      'Enter your mobile number to continue your\njourney with us',
                      style: AppTextStyles.subtitle().copyWith(
                        fontSize: 16.sp,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.6),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 64.h),

                    // Phone input card with glassmorphism effect
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Phone Number Label with icon
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.phone_android,
                                  size: 16.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Mobile Number',
                                style: AppTextStyles.body().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Enhanced Phone Form Field
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.1),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: PhoneFormField(
                              // controller: controller.phoneController,
                              initialValue: PhoneNumber.parse('+91'),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                  11,
                                ), // limits input length to 10
                                FilteringTextInputFormatter
                                    .digitsOnly, // optional: only digits allowed
                              ],
                              countrySelectorNavigator:
                                  const CountrySelectorNavigator.page(),
                              onChanged: (phoneNumber) {
                                controller.phoneController.value = phoneNumber;
                                debugPrint(
                                  "${controller.phoneController.value}",
                                );
                              },
                              isCountrySelectionEnabled: true,
                              isCountryButtonPersistent: true,
                              countryButtonStyle: CountryButtonStyle(
                                showDialCode: true,
                                showIsoCode: true,
                                showFlag: true,
                                flagSize: 18.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your phone number',
                                
                                hintStyle: TextStyle(
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.black.withOpacity(0.5),
                                  fontSize: 13.sp,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Enhanced Continue Button with gradient
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient:
                                controller.isLoading.value
                                    ? LinearGradient(
                                      colors: [
                                        AppColors.primaryColor.withOpacity(0.6),
                                        AppColors.primaryColor.withOpacity(0.4),
                                      ],
                                    )
                                    : LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.primaryColor.withOpacity(0.8),
                                      ],
                                    ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Obx(
                              () =>
                                  controller.isLoading.value
                                      ? SizedBox(
                                        height: 24.h,
                                        width: 24.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Continue',
                                            style: AppTextStyles.button
                                                .copyWith(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16.sp,
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 16.h),
                    // RichText(
                    //   text: TextSpan(
                    //     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    //     children: [
                    //       const TextSpan(text: "Don't have an account? "),
                    //       TextSpan(
                    //         text: 'Sign up',
                    //         style: TextStyle(
                    //           color: AppColors.primaryColor,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //         recognizer:
                    //             TapGestureRecognizer()
                    //               ..onTap = () {
                    //                 Get.offNamed(Routes.LOGIN);
                    //               },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 64.h),

                    // Enhanced Terms and Privacy with better design
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.02)
                                : Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: AppTextStyles.caption().copyWith(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.6),
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: AppTextStyles.caption().copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: AppTextStyles.caption().copyWith(
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: AppTextStyles.caption().copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),

              // Theme toggle button
              Positioned(
                top: 60.h,
                right: 16.w,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? Colors.white : Colors.black,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      themeController.toggleTheme();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
