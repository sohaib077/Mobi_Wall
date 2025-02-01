import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StepperItem extends StatelessWidget {
  const StepperItem({
    super.key,
    required this.number,
    required this.stepperLength,
    this.totalSteps,
    required this.text,
    this.linkText,
    this.link,
  });

  final String number;
  final double stepperLength;
  final int? totalSteps;
  final String text;
  final String? linkText;
  final String? link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Text(
                  number,
                  style: Styles.medium25Style(context, size: 14)
                      .copyWith(color: Colors.white),
                ),
              ),
              StepProgressIndicator(
                fallbackLength: stepperLength,
                direction: Axis.vertical,
                totalSteps: totalSteps ?? 10,
                size: 1.5.w,
                unselectedColor: const Color(0xff0062CC).withOpacity(1),
                selectedColor: const Color(0xff0062CC),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Styles.regular14Style(context).copyWith(
                    color: const Color(0xff3A3A3A),
                  ),
                ),
                if (linkText != null) SizedBox(height: 10.h),
                if (linkText != null)
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(4.r),
                    highlightColor: AppColors.primaryColor.withOpacity(0.2),
                    splashColor:  AppColors.primaryColor.withOpacity(0.2),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 1.w),
                      child: Text(
                        linkText!,
                        style: Styles.regular14Style(context).copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
