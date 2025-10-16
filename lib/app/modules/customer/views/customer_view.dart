// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/followers/followers_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      init: CustomerController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.headerGradientColors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(controller),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Obx(() {
                        if (controller.followersModel.value == null) {
                          return _buildLoadingState();
                        }

                        final followers =
                            controller.followersModel.value!.data ?? [];

                        if (followers.isEmpty) {
                          return _buildEmptyState();
                        }

                        return _buildFollowersList(followers, context);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(CustomerController controller) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                onPressed: () => Get.back(),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Followers',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your customer base',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Obx(() {
                final count = controller.followersModel.value?.totalCount ?? 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading followers...',
            style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 100,
            color: AppColors.lightTextSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Followers Yet',
            style: TextStyle(
              color: AppColors.lightTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your followers will appear here',
            style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersList(List<dynamic> followers, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<CustomerController>().fetchCustomer();
      },
      color: AppColors.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final follower = followers[index];
          final user = follower.user;

          return _buildFollowerCard(user, context);
        },
      ),
    );
  }

  Widget _buildFollowerCard(FollowrsUser user, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to customer details
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                _buildAvatar(user),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                .trim()
                                .isEmpty
                            ? ''
                            : '${user.firstName ?? ''} ${user.lastName ?? ''}',
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (user.email != null && user.email!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 14,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                user.placeOfBirth ?? "",
                                style: TextStyle(
                                  color:
                                      isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (user.phoneNumber != null &&
                          user.phoneNumber!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_sharp,
                              size: 14,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              AppDateUtils.extractDate(
                                user.dateOfBirth ?? "",
                                5,
                              ),
                              style: TextStyle(
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(dynamic user) {
    final hasImage =
        user?.profilePicture != null && user!.profilePicture!.isNotEmpty;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            !hasImage
                ? LinearGradient(colors: AppColors.headerGradientColors)
                : null,
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child:
            hasImage
                ? Image.network(
                  user.profilePicture!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar(user);
                  },
                )
                : _buildDefaultAvatar(user),
      ),
    );
  }

  Widget _buildDefaultAvatar(dynamic user) {
    final initial =
        (user?.firstName?.isNotEmpty ?? false)
            ? user!.firstName![0].toUpperCase()
            : 'U';

    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
