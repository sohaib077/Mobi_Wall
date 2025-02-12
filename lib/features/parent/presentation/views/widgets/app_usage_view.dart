import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobi_wall/core/enums/alert_state_enum.dart';
import 'package:mobi_wall/core/widgets/custom_animated_button.dart';
import 'package:mobi_wall/core/widgets/custom_animated_text.dart';
import 'package:mobi_wall/core/widgets/custom_title_app_bar.dart';
import 'package:mobi_wall/core/widgets/shared_methods.dart';
import 'package:mobi_wall/core/utils/app_colors.dart';
import 'package:mobi_wall/core/utils/icon_broken.dart';
import 'package:mobi_wall/core/utils/styles.dart';
import 'package:mobi_wall/features/children/data/models/app_data_model.dart';
import 'package:mobi_wall/features/parent/presentation/views/widgets/custom_statics_tab.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUsageView extends StatefulWidget {
  const AppUsageView({super.key, required this.app});

  final AppDataModel app;

  @override
  State<AppUsageView> createState() => _AppUsageViewState();
}

class _AppUsageViewState extends State<AppUsageView> {
  int index = 0;

  double getPercent() {
    if (index == 0) return widget.app.dailyUsage!.inMinutes / (24 * 60);
    if (index == 1) return widget.app.weeklyUsage!.inMinutes / (24 * 7 * 60);
    return widget.app.monthlyUsage!.inMinutes / (30 * 24 * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTitleAppBar(title: "Time Spent"),
              SizedBox(height: 20.h),
              Text(
                "Statistic",
                style: Styles.bold24Style(context, size: 20)
                    .copyWith(color: const Color(0xff191919)),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: CustomStaticsTab(
                      flag: index == 0,
                      text: "Day",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: CustomStaticsTab(
                      flag: index == 1,
                      text: "Week",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: CustomStaticsTab(
                      flag: index == 2,
                      text: "Month",
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeColumn(context),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 60.r,
                      animation: true,
                      animationDuration: 800,
                      animateFromLastPercent: true,
                      curve: Curves.easeInOut,
                      lineWidth: 15.w,
                      percent: getPercent(),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      progressColor: AppColors.primaryColor,
                      center: CustomAnimatedText(
                        text:
                            "${(getPercent() * 100).toStringAsFixed(0).toString()}%",
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Center(
                  child: CustomAnimatedButton(
                text: "Visit App",
                onPressed: () async {
                  try {
                    final Uri link = Uri.parse(
                        "https://play.google.com/store/apps/details?id=${widget.app.packageName}");
                    await launchUrl(link);
                  } catch (e) {
                    log(e.toString());
                    showAlertDialog(context,
                        state: AlertState.failed,
                        description:
                            "\nOops, this app may be not in the store\n");
                  }
                },
              )),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildTimeColumn(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconBroken.Time_Circle,
            size: 30.sp,
            color: AppColors.veryDarkBlue.withOpacity(0.8),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.only(left: 30.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                      child: CustomAnimatedText(
                          text: getDurationString(isHours: true)),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      " Hours",
                      style: Styles.regular16Style(context, size: 13),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomAnimatedText(
                            text: getDurationString(isHours: false)),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      " Minutes",
                      style: Styles.regular16Style(context, size: 13),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getDurationString({required bool isHours}) {
    Duration duration;
    if (index == 0)
      duration = widget.app.dailyUsage!;
    else if (index == 1)
      duration = widget.app.weeklyUsage!;
    else
      duration = widget.app.monthlyUsage!;
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    // return "$negativeSign${twoDigits(duration.inHours)} : $twoDigitMinutes : $twoDigitSeconds";
    return isHours ? twoDigits(duration.inHours) : twoDigitMinutes;
  }
}
