import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';

import '../utils/styles.dart';
class PasswordValidationItem extends StatelessWidget {
  const PasswordValidationItem({
    super.key,
    required this.text,
    required this.hasValidated,
  });

  final String text;
  final bool hasValidated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.r,
            backgroundColor: Colors.grey,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: Styles.regular14Style(context, size: 12).copyWith(
              decoration: hasValidated ? TextDecoration.lineThrough : null,
              decorationColor: Colors.green,
              decorationThickness: 2,
              color: hasValidated
                  ? AppColors.veryDarkBlue.withOpacity(0.5)
                  : AppColors.labelTextColor,
            ),
          )
        ],
      ),
    );
  }
}
