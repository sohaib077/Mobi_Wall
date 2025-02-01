import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class CustomStaticsTab extends StatelessWidget {
  const CustomStaticsTab({
    super.key,
    required this.flag, required this.text,
  });

  final bool flag;
  final String text;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: flag ? 1 : .8,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: flag ? AppColors.primaryColor : const Color(0xffFBFBFB),
          borderRadius: BorderRadius.circular(60.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 25.w),
        child: Text(
          text,
          style: Styles.medium16Style(context)
              .copyWith(color: flag ? Colors.white : const Color(0xffADAFBD)),
        ),
      ),
    );
  }
}
