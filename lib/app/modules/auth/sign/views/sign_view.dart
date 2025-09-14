// ignore_for_file: deprecated_member_use
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../controllers/sign_controller.dart';

class SignView extends GetView<SignController> {
  const SignView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<SignController>(
      init: SignController(),
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

              // Main content
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120.h),

                    // Brand Logo
                    Container(
                      padding: EdgeInsets.all(20.w),
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
                        size: 40.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Title
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryPrimary,
                            ],
                          ).createShader(bounds),
                      child: Text(
                        'Join as Astrologer',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'Share your cosmic wisdom with seekers\naround the world',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.6),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40.h),

                    // Registration Form
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
                          // Profile Photo Section
                          Center(
                            child: GestureDetector(
                              onTap:
                                  () => {
                                    _showImagePickerDialog(controller, isDark),
                                  },
                              child: Obx(
                                () => Container(
                                  width: 100.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isDark
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.05),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child:
                                      controller.selectedImage.value != null
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50.r,
                                            ),
                                            child: Image.file(
                                              controller.selectedImage.value!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 30.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'Add Photo',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color:
                                                      isDark
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // First Name & Last Name Row
                          _buildInputField(
                            label: 'First Name',
                            icon: Icons.person_outline,
                            controller: controller.firstNameController,
                            isDark: isDark,
                          ),
                          SizedBox(height: 20.h),
                          _buildInputField(
                            label: 'Last Name',
                            icon: Icons.person_outline,
                            controller: controller.lastNameController,
                            isDark: isDark,
                          ),

                          SizedBox(height: 20.h),

                          // Email Field
                          _buildInputField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            isDark: isDark,
                          ),

                          SizedBox(height: 20.h),

                          // Phone Number Field
                          _buildPhoneField(isDark, controller),

                          SizedBox(height: 20.h),

                          // Date of Birth
                          _buildDateField(
                            label: 'Date of Birth',
                            icon: Icons.calendar_today_outlined,
                            selectedDate: controller.dateOfBirth,
                            onTap: () => controller.selectDate(context),
                            isDark: isDark,
                          ),

                          SizedBox(height: 20.h),

                          // Time of Birth
                          _buildTimeField(
                            label: 'Time of Birth',
                            icon: Icons.access_time,
                            selectedTime: controller.timeOfBirth,
                            onTap: () => controller.selectTime(context),
                            isDark: isDark,
                          ),

                          SizedBox(height: 20.h),

                          // Place of Birth
                          _buildInputField(
                            label: 'Place of Birth',
                            icon: Icons.location_on_outlined,
                            controller: controller.placeOfBirthController,
                            isDark: isDark,
                          ),

                          SizedBox(height: 20.h),

                          // Gender Selection
                          _buildGenderField(isDark, controller),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Register Button
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
                                : controller.registerAstrologer,
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
                                        AppColors.secondaryPrimary.withOpacity(
                                          0.4,
                                        ),
                                      ],
                                    )
                                    : LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.secondaryPrimary,
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
                                            'Start Your Journey',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.rocket_launch,
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

                    SizedBox(height: 32.h),

                    // Terms and Conditions
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
                              text: 'By registering, you agree to our ',
                              style: TextStyle(
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
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.6),
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
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
                        AppColors.secondaryPrimary.withOpacity(0.05),
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

              // Floating geometric shapes
              Positioned(
                top: 50.h,
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

              // Back button and theme toggle
              Positioned(
                top: 50.h,
                left: 16.w,
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
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? Colors.white : Colors.black,
                      size: 20.sp,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, size: 14.sp, color: AppColors.primaryColor),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                fontSize: 16.sp,
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
    );
  }

  Widget _buildPhoneField(bool isDark, SignController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.phone_android,
                size: 14.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: PhoneFormField(
            initialValue: PhoneNumber.parse('+91'),
            onChanged: (phoneNumber) {
              controller.phoneNumber.value = phoneNumber;
            },
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              hintStyle: TextStyle(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                fontSize: 16.sp,
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
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required Rx<DateTime?> selectedDate,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, size: 14.sp, color: AppColors.primaryColor),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.white.withOpacity(0.05) : AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color:
                    isDark
                        ? AppColors.white.withOpacity(0.1)
                        : AppColors.black.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Obx(
              () => Text(
                selectedDate.value != null
                    ? "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}"
                    : 'Select date',
                style: TextStyle(
                  color:
                      selectedDate.value != null
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark
                              ? AppColors.white.withOpacity(0.5)
                              : AppColors.black.withOpacity(0.5)),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required IconData icon,
    required Rx<TimeOfDay?> selectedTime,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, size: 14.sp, color: AppColors.primaryColor),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Obx(
              () => Text(
                selectedTime.value != null
                    ? selectedTime.value!.format(Get.context!)
                    : 'Select time',
                style: TextStyle(
                  color:
                      selectedTime.value != null
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark
                              ? AppColors.white.withOpacity(0.5)
                              : AppColors.black.withOpacity(0.5)),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(bool isDark, SignController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.person,
                size: 14.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedGender.value = 'Male',
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color:
                          controller.selectedGender.value == 'Male'
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : (isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            controller.selectedGender.value == 'Male'
                                ? AppColors.primaryColor
                                : (isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1)),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Male',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            controller.selectedGender.value == 'Male'
                                ? AppColors.primaryColor
                                : (isDark ? Colors.white : Colors.black),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedGender.value = 'Female',
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color:
                          controller.selectedGender.value == 'Female'
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : (isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            controller.selectedGender.value == 'Female'
                                ? AppColors.primaryColor
                                : (isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1)),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Female',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            controller.selectedGender.value == 'Female'
                                ? AppColors.primaryColor
                                : (isDark ? Colors.white : Colors.black),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImagePickerDialog(SignController? controller, bool isDark) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 220.h,
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.2)
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 30.h),
              // Camera Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: () {
                    Get.back();
                    controller?.pickImage(sourc: ImageSource.camera);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              // Gallery Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                height: 50.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: () {
                    Get.back();
                    controller?.pickImage(sourc: ImageSource.gallery);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
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
