import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:otp_pin_field/otp_pin_field.dart';

import '../controllers/otp_verify_controller.dart';

class OtpVerifyView extends GetView<OtpVerifyController> {
  final bool? isUserExist;
  const OtpVerifyView({super.key, this.isUserExist});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<OtpVerifyController>(
      init: OtpVerifyController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
              ),
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  // Header Section
                  _buildHeaderSection(isDarkMode),

                  SizedBox(height: 40.h),

                  // OTP Input Section
                  _buildOtpInputSection(context, isDarkMode),

                  SizedBox(height: 30.h),

                  // Resend Section
                  _buildResendSection(isDarkMode),

                  SizedBox(height: 40.h),

                  // Verify Button
                  _buildVerifyButton(context, size, isDarkMode),

                  SizedBox(height: 20.h),

                  // Help Section
                  _buildHelpSection(isDarkMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(bool isDarkMode) {
    return Column(
      children: [
        // OTP Icon with gradient background
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.security,
            color: AppColors.lightSurface,
            size: 45.sp,
          ),
        ),

        SizedBox(height: 24.h),

        // Title
        Text(
          'Verify Your Account',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
          ),
        ),

        SizedBox(height: 12.h),

        // Subtitle with phone number
        Obx(
          () => RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.sp,
                color:
                    isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'We\'ve sent a 5-digit verification code to\n',
                ),
                TextSpan(
                  text:
                      controller.phoneNumber.value.isNotEmpty
                          ? "+91 ${controller.phoneNumber.value}"
                          : '+91 XXXXXXXXXX',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Enter Verification Code',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
          ),
        ),

        SizedBox(height: 20.h),

        // OTP Pin Field
        OtpPinField(
          key: controller.otpFieldKey,
          maxLength: 6,
          fieldWidth: 40.w,
          fieldHeight: 40.h,
          onSubmit: (text) {
            controller.otp.value = text;
            // controller.verifyOtp();
          },
          onChange: (text) {
            controller.otp.value = text;
          },
          otpPinFieldStyle: OtpPinFieldStyle(
            // Default field style
            defaultFieldBorderColor:
                isDarkMode ? AppColors.darkDivider : AppColors.lightDivider,
            defaultFieldBackgroundColor:
                isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,

            // Active field style
            activeFieldBorderColor: AppColors.primaryColor,
            activeFieldBackgroundColor: AppColors.primaryColor.withValues(
              alpha: 0.05,
            ),

            // Filled field style
            filledFieldBorderColor: AppColors.accentColor,
            filledFieldBackgroundColor: AppColors.accentColor.withValues(
              alpha: 0.1,
            ),

            // Field border width and radius
            fieldBorderWidth: 2,
            fieldBorderRadius:5.r,

            // Text style
            textStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color:
                  isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
          ),
          otpPinFieldDecoration: OtpPinFieldDecoration.custom,
          cursorColor: AppColors.primaryColor,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 16.h),

        // Error message
        Obx(
          () =>
              controller.errorMessage.value.isNotEmpty
                  ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.red,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildResendSection(bool isDarkMode) {
    return Obx(
      () => Column(
        children: [
          if (controller.canResend.value) ...[
            // Resend available
            GestureDetector(
              onTap: controller.resendOtp,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: AppColors.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Resend Code',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Timer countdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color:
                      isDarkMode
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color:
                        isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Resend in ${controller.resendTimer.value}s',
                    style: TextStyle(
                      color:
                          isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Didn't receive code text
          Text(
            'Didn\'t receive the code?',
            style: TextStyle(
              color:
                  isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, Size size, bool isDarkMode) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size.width,
        height: 56.h,
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value || controller.otp.value.length < 5
                  ? null
                  : controller.verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            disabledBackgroundColor:
                isDarkMode ? AppColors.darkSurface : AppColors.lightDivider,
            elevation: controller.otp.value.length == 6 ? 8 : 0,
            shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child:
              controller.isLoading.value
                  ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: AppColors.lightSurface,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              controller.otp.value.length == 6
                                  ? AppColors.lightSurface
                                  : (isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.white),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color:
                    isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text(
            'If you\'re having trouble receiving the code, please check your phone\'s signal or try requesting a new code.',
            style: TextStyle(
              color:
                  isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),

          SizedBox(height: 12.h),

          GestureDetector(
            onTap: () {
              // Add contact support functionality
              Get.snackbar(
                'Support',
                'Contact support feature will be available soon!',
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                colorText: AppColors.primaryColor,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(16.w),
                borderRadius: 12.r,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.support_agent,
                    color: AppColors.primaryColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Contact Support',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
