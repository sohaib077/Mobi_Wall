import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/assets_data.dart';
import 'package:mobi_wall/core/utils/size_config.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/core/widgets/log_out_button.dart';

import 'widgets/parent_or_child_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
                alignment: Alignment.centerRight, child: LogOutButton()),
            Center(
              child: Lottie.asset(AssetsData.parentChildLottie,
                  height: SizeConfig.screenHeight * 0.2 , repeat: false),
            ),
            const Spacer(),
            Text(
              "Whose device is this",
              style: Styles.bold24Style(context),
            ),
            SizedBox(height: 8.h),
            Text(
              "We will prepared a customized options depended on your device ",
              style: Styles.regular14Style(context)
                  .copyWith(color: AppColors.labelTextColor),
            ),
            const Spacer(),
            const ParentOrChildButton(isParent: true),
            SizedBox(height: 15.h),
            const ParentOrChildButton(isParent: false),
            const Spacer(flex: 2),
          ],
        ),
      )),
    );
  }
}
