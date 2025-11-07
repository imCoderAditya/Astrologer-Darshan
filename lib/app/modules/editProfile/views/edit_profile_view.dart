// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/specialization/specialization_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark
            ? AppColors.white.withValues(alpha: 0.8)
            : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTextStyles.headlineMedium().copyWith(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      ImageProvider? img;

                      if (controller.profileImage.value != null) {
                        // local picked file
                        img = FileImage(controller.profileImage.value!);
                      } else if ((controller.profilePicture?.value ?? '')
                          .isNotEmpty) {
                        // url available
                        img = CachedNetworkImageProvider(
                          controller.profilePicture!.value,
                        );
                      } else {
                        img = null; // no image -> use icon
                      }

                      return CircleAvatar(
                        radius: 60.r,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.2,
                        ),
                        backgroundImage: img,
                        child:
                            img == null
                                ? Icon(
                                  Icons.person,
                                  size: 60.sp,
                                  color: AppColors.primaryColor,
                                )
                                : null,
                      );
                    }),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Personal Information Section
              _buildSectionTitle("Personal Information", textColor),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.firstNameController,
                label: "First Name",
                icon: Icons.person_outline,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.lastNameController,
                label: "Last Name",
                icon: Icons.person_outline,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.displayNameController,
                label: "Display Name",
                icon: Icons.badge_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              // _buildDatePickerField(
              //   controller: controller.dateOfBirthController,
              //   label: "Date of Birth",
              //   icon: Icons.cake_outlined,
              //   textColor: textColor,
              //   secondaryTextColor: secondaryTextColor,
              //   onTap: () => controller.selectDate(context),
              // ),
              // SizedBox(height: 15.h),
              // _buildTimePickerField(
              //   controller: controller.timeOfBirthController,
              //   label: "Time of Birth",
              //   icon: Icons.access_time,
              //   textColor: textColor,
              //   secondaryTextColor: secondaryTextColor,
              //   onTap: () => controller.selectTime(context),
              // ),
              // SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.placeOfBirthController,
                label: "Place of Birth",
                icon: Icons.location_on_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildDropdownField(
                value: controller.selectedGender,
                label: "Gender",
                icon: Icons.wc_outlined,
                items: ['Male', 'Female', 'Other'],
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                onChanged: (value) => controller.selectedGender.value = value!,
              ),
              SizedBox(height: 30.h),

              // Professional Information Section
              _buildSectionTitle("Professional Information", textColor),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.bioController,
                label: "Bio",
                icon: Icons.info_outline,
                maxLines: 1,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),

              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.experienceController,
                label: "Experience (Years)",
                icon: Icons.work_outline,
                keyboardType: TextInputType.number,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              // _buildTextField(
              //   controller: controller.specializationsController,
              //   label: "Specializations (comma separated)",
              //   icon: Icons.star_outline,
              //   maxLines: 2,
              //   textColor: textColor,
              //   secondaryTextColor: secondaryTextColor,
              //   hint: "e.g., Vedic, Kundli, Love, Finance",
              // ),
              _buildSpecializationDropdownField(
                value: controller.selectSpecialization.value,
                label: "Specializations (comma separated)",
                icon: Icons.wc_outlined,
                items: ['Male', 'Female', 'Other'],
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                onChanged:
                    (value) => controller.selectSpecialization.value = value!,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.languagesController,
                label: "Languages (comma separated)",
                icon: Icons.language_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                hint: "e.g., English, Hindi, Urdu",
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.educationController,
                label: "Education",
                icon: Icons.school_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.certificationsController,
                label: "Certifications",
                icon: Icons.card_membership_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 30.h),

              // Bank Details Section
              _buildSectionTitle("Bank Details", textColor),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.accountNumberController,
                label: "Account Number",
                icon: Icons.account_balance_outlined,
                keyboardType: TextInputType.number,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.bankNameController,
                label: "Bank Name",
                icon: Icons.account_balance,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.ifscController,
                label: "IFSC Code",
                icon: Icons.code,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.panController,
                label: "PAN Number",
                icon: Icons.credit_card,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                controller: controller.gstController,
                label: "GST Number (Optional)",
                icon: Icons.receipt_long,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              // SizedBox(height: 15.h),
              // _buildTextField(
              //   controller: controller.passwordController,
              //   label: "Password",
              //   icon: Icons.lock_outline,
              //   obscureText: true,
              //   textColor: textColor,
              //   secondaryTextColor: secondaryTextColor,
              // ),
              SizedBox(height: 40.h),

              // Update Button
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child:
                        controller.isLoading.value
                            ? CircularProgressIndicator(color: AppColors.white)
                            : Text(
                              "Update Profile",
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 1.0,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color textColor,
    required Color secondaryTextColor,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTextStyles.caption().copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTextStyles.body().copyWith(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint ?? label,
              labelStyle: AppTextStyles.body().copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: AppTextStyles.small().copyWith(
                color: secondaryTextColor.withValues(alpha: 0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 22.sp,
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

  Widget _buildSpecializationDropdownField({
    Specialization? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Color textColor,
    required Color secondaryTextColor,
    required Function(Specialization?) onChanged,
  }) {
    final bool isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            "Specialization",
            style: AppTextStyles.caption().copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Obx(
            () => DropdownButtonFormField<Specialization>(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              value: controller.selectSpecialization.value,
              decoration: InputDecoration(
                hintText: "Select Specialization",
                labelStyle: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.6),
                ),
                helperStyle: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
                border: InputBorder.none,
              ),
              dropdownColor:
                  isDark ? AppColors.darkBackground : AppColors.white,
              style: AppTextStyles.body().copyWith(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),

              items:
                  controller.specializationModel.value?.specialization?.map((
                    Specialization? item,
                  ) {
                    return DropdownMenuItem<Specialization>(
                      value: item,
                      child: Text(item?.categoryName ?? ""),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
     
      ],
    );
  }

  Widget _buildDropdownField({
    required Rx<String> value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Color textColor,
    required Color secondaryTextColor,
    required Function(String?) onChanged,
  }) {
    final bool isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            "Gender",
            style: AppTextStyles.caption().copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Obx(
            () => DropdownButtonFormField<String>(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              value: value.value.isEmpty ? null : value.value,
              decoration: InputDecoration(
                hintText: "Gender",
                labelStyle: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.6),
                ),
                helperStyle: AppTextStyles.caption().copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
                border: InputBorder.none,
              ),
              dropdownColor:
                  isDark ? AppColors.darkBackground : AppColors.white,
              style: AppTextStyles.body().copyWith(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),

              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildDatePickerField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   required Color textColor,
  //   required Color secondaryTextColor,
  //   required VoidCallback onTap,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
  //         child: Text(
  //           label,
  //           style: AppTextStyles.caption().copyWith(
  //             color: textColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: AppColors.primaryColor.withOpacity(0.05),
  //           borderRadius: BorderRadius.circular(12.r),
  //           border: Border.all(
  //             color: AppColors.primaryColor.withOpacity(0.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: TextField(
  //           controller: controller,
  //           readOnly: true,
  //           onTap: onTap,
  //           style: AppTextStyles.body().copyWith(color: textColor),
  //           decoration: InputDecoration(
  //             hintText: label,
  //             hintStyle: AppTextStyles.small().copyWith(
  //               color: secondaryTextColor.withOpacity(0.5),
  //             ),
  //             prefixIcon: Icon(
  //               icon,
  //               color: AppColors.primaryColor,
  //               size: 22.sp,
  //             ),
  //             suffixIcon: Icon(
  //               Icons.calendar_today,
  //               color: AppColors.primaryColor,
  //               size: 20.sp,
  //             ),
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.symmetric(
  //               horizontal: 16.w,
  //               vertical: 16.h,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTimePickerField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   required Color textColor,
  //   required Color secondaryTextColor,
  //   required VoidCallback onTap,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
  //         child: Text(
  //           label,
  //           style: AppTextStyles.caption().copyWith(
  //             color: textColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: AppColors.primaryColor.withOpacity(0.05),
  //           borderRadius: BorderRadius.circular(12.r),
  //           border: Border.all(
  //             color: AppColors.primaryColor.withOpacity(0.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: TextField(
  //           controller: controller,
  //           readOnly: true,
  //           onTap: onTap,
  //           style: AppTextStyles.body().copyWith(color: textColor),
  //           decoration: InputDecoration(
  //             hintText: label,
  //             hintStyle: AppTextStyles.small().copyWith(
  //               color: secondaryTextColor.withOpacity(0.5),
  //             ),
  //             prefixIcon: Icon(
  //               icon,
  //               color: AppColors.primaryColor,
  //               size: 22.sp,
  //             ),
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.symmetric(
  //               horizontal: 16.w,
  //               vertical: 16.h,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
