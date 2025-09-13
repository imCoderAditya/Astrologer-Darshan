import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerDoctorCard extends StatelessWidget {
  final int? itemCount;
  const ShimmerDoctorCard({super.key,this.itemCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount??4,
            padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          interval: const Duration(seconds: 0),
          color: Colors.white,
          enabled: true,
          direction: const ShimmerDirection.fromLTRB(),
          child: Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile + name row
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[400],
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDark
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),

                    // 🛠 Wrap this in Expanded to prevent overflow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[400],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: 80.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[400],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Stars
                Row(
                  children: List.generate(5, (_) {
                    return Container(
                      width: 16.w,
                      height: 16.h,
                      margin: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[400],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12.h),

                // Review text
                Container(
                  width: 100.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
