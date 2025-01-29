import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';

class CustomTitleAppBar extends StatelessWidget {
  const CustomTitleAppBar({
    super.key,
    required this.title,
    this.backText = false,
    this.backToHome = false,
    // this.refresh = false,
    this.onBack,
    this.onRefresh,
  });

  final String title;
  final bool backText;
  final bool backToHome;

  // final bool refresh;
  final void Function()? onBack;
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBack ??
                () {
                  Navigator.pop(context);
                },
            customBorder: const CircleBorder(),
            child: Icon(
              IconBroken.Arrow___Left_2,
              size: 30.sp,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: Styles.medium25Style(context, size: 16)
                .copyWith(color: const Color(0xff101010)),
          ),
          if (onRefresh == null) SizedBox(width: 30.sp),
          const Spacer(),
          if (onRefresh != null)
            InkWell(
              onTap: onRefresh,
              customBorder: const CircleBorder(),
              child: Icon(
                FontAwesomeIcons.arrowsRotate,
                size: 20.sp,
                color: AppColors.primaryColor.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
}
